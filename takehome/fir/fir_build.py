"""fir_build.py -- the build pipeline for the streaming polynomial accelerator.

    python fir_build.py --list-steps
    python fir_build.py --through check_pysim       # Python only, no Vitis
    python fir_build.py --through summary           # everything, Vitis included

Every step covers both stream widths, 32 and 64 bits, unless its name ends in ``_w32`` or
``_w64``.  The pipeline, in reading order:

    scenarios        write each scenario's stimulus and expected response (scenarios.py)
    py_model         run the pure bit-exact model on every scenario
    check_model      ...and compare it with the expected response
    py_sim           run pysim (the timing model) on the scenarios a pysim stream can express
    check_pysim      ...compare
    gen_include      schema headers, serializers and the stream/testbench helpers
    sources          the hand-written C++ in place (a build outside this directory)
    gen_kernel       the kernel boundary (gen/fir.hpp, gen/fir.cpp: tops fir and
                     fir_bw64); the body is the hand-written fir_body_impl.tpp
    csim             Vitis C simulation, every scenario, hand-written fir_tb.cpp
    check_csim       ...compare
    csynth_w*        C synthesis, then RTL co-simulation of the timing scenario
    inspect_synth_w* loops, II and resources from the synthesis report
    check_cosim      the co-simulated responses, compared
    summary          every check, the synthesis reports and the verdicts

Every check compares against the same expected response, computed from each scenario's
intent (scenarios.py) rather than from any implementation.
"""
from __future__ import annotations

import csv
import json
import shutil
from dataclasses import dataclass
from pathlib import Path


from waveflow.build.build import BuildConfig, BuildDag, BuildStep, SourceStep
from waveflow.build.cli import run_dag_cli
from waveflow.build.hwcodegen_steps import HlsCodegenStep
from waveflow.build.resource_steps import InspectSynthStep
from waveflow.build.streamutils import StreamUtilsStep
from waveflow.hw.arrayutils import ArrayUtilsStep
from waveflow.hw.clock import Clock
from waveflow.hw.dataschema import DataSchemaStep
from waveflow.simulation.logger import Logger
from waveflow.simulation.simulation import Simulation
from waveflow.toolchain import toolchain
from waveflow.utils.burst_io import read_bursts, write_bursts

import scenarios as S
from fir import (
    SCHEMA_CLASSES, WORD_BW_SUPPORTED, Float32, FirAccel, FirTB, connect, fir_stream_model,
)

_SOURCE_DIR = Path(__file__).resolve().parent

#: The stream widths every step covers.
WIDTHS = tuple(WORD_BW_SUPPORTED)

#: The kernel top for each width (``param_supports`` names the 64-bit one).
TOPS = {32: "fir"}

#: The hand-written sources Vitis needs beside the generated ones.  A build in another
#: directory (the tests build in a temporary one) gets a copy.
HAND_WRITTEN = ("run.tcl", "fir_tb.cpp", "fir_body_impl.tpp")


def width_dir(root: Path, word_bw: int) -> Path:
    """One width's scenario data: ``data/w32`` or ``data/w64``."""
    return root / "data" / f"w{word_bw}"


def _ensure_sources(root: Path) -> None:
    for name in HAND_WRITTEN:
        if not (root / name).exists():
            shutil.copy(_SOURCE_DIR / name, root / name)


_STUB_MARK = "TODO: implement body"


def _require_real_body(root: Path) -> None:
    """Refuse to simulate the generated stub.

    The generator writes ``fir_body_impl.tpp`` only when it is missing, as a ``// TODO``
    stub with an empty body.  Simulating that is not an error to Vitis -- the kernel just
    does nothing -- so the symptom is every scenario failing at once.  Say what it is.
    """
    body = root / "fir_body_impl.tpp"
    if _STUB_MARK in body.read_text(encoding="utf-8"):
        raise RuntimeError(f"{body} is the generated stub, not the kernel body: copy the "
                           f"hand-written fir_body_impl.tpp into the build directory")


@dataclass(kw_only=True)
class SourcesStep(BuildStep):
    """Place the hand-written C++ in the build directory, before anything is generated.

    In the example's own directory they are already there.  A build elsewhere (the tests
    build in a temporary directory) gets a copy -- and it must come before ``gen_kernel``,
    or the generator writes its stub in place of the body and the copy then (correctly)
    refuses to overwrite it.
    """
    description = "Copy the hand-written body, testbench and Tcl into the build directory."
    consumes = ["fir_source"]
    produces = {"kernel_sources": Path("fir_body_impl.tpp")}
    params = {}

    def run(self, config: BuildConfig, **_) -> dict:
        _ensure_sources(config.root_dir)
        return {"kernel_sources": config.root_dir / "fir_body_impl.tpp"}


def _write_status(path: Path, status: dict) -> None:
    path.write_text(json.dumps(status) + "\n", encoding="utf-8")


def _names(root: Path, word_bw: int) -> list[str]:
    return (width_dir(root, word_bw) / "scenarios.txt").read_text(encoding="utf-8").split()


def _meta(root: Path, word_bw: int, name: str) -> dict:
    return json.loads((width_dir(root, word_bw) / name / "scenario.json").read_text(encoding="utf-8"))


# ---------------------------------------------------------------------------
# Python: scenarios, the pure model, pysim
# ---------------------------------------------------------------------------


@dataclass(kw_only=True)
class ScenariosStep(BuildStep):
    description = "Write every scenario's stimulus and expected response, at each width."
    consumes = ["fir_source", "scenarios_source"]
    produces = {"scenario_list": Path("data/scenarios.txt")}
    params = {}

    def run(self, config: BuildConfig, **_) -> dict:
        root = config.root_dir
        for bw in WIDTHS:
            S.write_scenarios(width_dir(root, bw), bw)
        out = root / "data" / "scenarios.txt"
        out.write_text("\n".join(S.scenarios()) + "\n", encoding="utf-8")
        return {"scenario_list": out}


@dataclass(kw_only=True)
class ModelStep(BuildStep):
    description = "Run the pure bit-exact model (fir_stream_model) on every scenario."
    consumes = ["scenario_list"]
    produces = {"model_done": Path("results/model_done.txt")}
    params = {}

    def run(self, config: BuildConfig, **_) -> dict:
        root = config.root_dir
        for bw in WIDTHS:
            for name in _names(root, bw):
                d = width_dir(root, bw) / name
                res = fir_stream_model(read_bursts(d / "in"), word_bw=bw)
                write_bursts(res.out, d / "model")
                _write_status(d / "model" / "status.json", res.status())
        done = root / "results" / "model_done.txt"
        done.parent.mkdir(parents=True, exist_ok=True)
        done.write_text("done\n", encoding="utf-8")
        return {"model_done": done}


@dataclass(kw_only=True)
class PySimStep(BuildStep):
    """pysim: the module's Python body with its timing model.

    Runs every scenario a pysim stream can express (all but a missing TLAST), at each width.
    The timing scenario's event log becomes the cycle estimate cosim is checked against.
    """
    description = "Run pysim on every scenario it can express; log the timing scenario."
    consumes = ["scenario_list", "fir_source"]
    produces = {"pysim_done": Path("results/pysim_done.txt"),
                **{f"log_w{bw}": Path(f"results/sim_log_w{bw}.csv") for bw in WIDTHS}}
    params = {"clk_freq": 100e6, "unroll_factor": 1}

    def run(self, config: BuildConfig, clk_freq, unroll_factor, **_) -> dict:
        root = config.root_dir
        out: dict = {}
        for bw in WIDTHS:
            log_path = root / "results" / f"sim_log_w{bw}.csv"
            log_path.parent.mkdir(parents=True, exist_ok=True)
            for name in _names(root, bw):
                if not _meta(root, bw, name)["pysim"]:
                    continue
                d = width_dir(root, bw) / name
                sim = Simulation()
                clk = Clock(freq=clk_freq)
                logger = None
                accel = FirAccel(name="fir_accel", sim=sim, clk=clk, in_bw=bw, out_bw=bw,
                                  unroll_factor=unroll_factor,
                                  **({"logger": logger} if logger else {}))
                tb = FirTB(name="fir_tb", sim=sim, stimulus=d / "in", word_bw=bw,
                            n_out=len(read_bursts(d / "expected")))
                connect(sim, tb, accel, clk)
                sim.run_sim()
                write_bursts(tb.out, d / "pysim")
                _write_status(d / "pysim" / "status.json", tb.status)
            out[f"log_w{bw}"] = log_path
        done = root / "results" / "pysim_done.txt"
        done.write_text("done\n", encoding="utf-8")
        return {"pysim_done": done, **out}


@dataclass(kw_only=True)
class CheckStep(BuildStep):
    """Compare one stage's recorded responses with the expected ones (scenarios.check).

    Checks every scenario the stage ran, at each width: ``which`` names a scenario.json
    flag that selects them, and ``only`` lists them by name (neither: all).
    """
    stage: str
    done_artifacts: tuple[str, ...]
    which: str | None = None
    only: tuple[str, ...] | None = None
    description = "Compare a stage's responses with the expected responses."
    params = {}

    @property
    def consumes(self) -> list:  # type: ignore[override]
        return [*self.done_artifacts, "scenario_list"]

    @property
    def produces(self) -> dict:  # type: ignore[override]
        return {f"check_{self.stage}": Path(f"results/check_{self.stage}.json")}

    def run(self, config: BuildConfig, **_) -> dict:
        root = config.root_dir
        report: dict[str, list[str]] = {}
        for bw in WIDTHS:
            names = [n for n in _names(root, bw)
                     if (self.which is None or _meta(root, bw, n)[self.which])
                     and (self.only is None or n in self.only)]
            for name, problems in S.check(width_dir(root, bw), self.stage, names).items():
                report[f"w{bw}/{name}"] = problems
        out = root / "results" / f"check_{self.stage}.json"
        out.write_text(json.dumps(report, indent=2), encoding="utf-8")
        failed = {k: v for k, v in report.items() if v}
        for name, problems in report.items():
            print(f"    {self.stage:6s} {name:20s} {'PASS' if not problems else 'FAIL'}")
            for p in problems:
                print(f"        {p}")
        if failed:
            raise RuntimeError(f"{self.stage}: {len(failed)} scenario(s) differ from the "
                               f"expected response: {sorted(failed)}")
        return {f"check_{self.stage}": out}


# ---------------------------------------------------------------------------
# Vitis: headers, the kernel boundary, csim, csynth + cosim
# ---------------------------------------------------------------------------


@dataclass(kw_only=True)
class HlsGenIncludeStep(BuildStep):
    description = "Generate the schema headers, serializers, and stream/testbench helpers."
    consumes = ["fir_source"]
    params = {}
    include_dir: str = "include"

    @property
    def produces(self) -> dict:  # type: ignore[override]
        return {"include_dir": Path(self.include_dir)}

    def run(self, config: BuildConfig, **_) -> dict:
        inner = BuildDag()
        inner.add(StreamUtilsStep(output_dir=self.include_dir))
        for cls in SCHEMA_CLASSES:
            inner.add(DataSchemaStep(cls, word_bw_supported=WORD_BW_SUPPORTED,
                                     include_dir=self.include_dir))
        inner.add(ArrayUtilsStep(Float32, WORD_BW_SUPPORTED))
        failed = [n for n, r in inner.run(config).items() if not r.success]
        if failed:
            raise RuntimeError(f"header generation failed: {failed}")
        return {"include_dir": config.root_dir / self.include_dir}


def _run_vitis(config: BuildConfig, stage: str, word_bw: int, live_output: bool,
               clk_freq: float) -> None:
    _ensure_sources(config.root_dir)
    # The stage goes in the environment: vitis-run 2025.1 has no --tclargs.
    env = {"WAVEFLOW_POLY_STAGE": stage, "WAVEFLOW_POLY_WIDTH": str(word_bw),
           "WAVEFLOW_POLY_CLK_PERIOD_NS": f"{1e9 / clk_freq:g}"}
    try:
        result = toolchain.run_vitis_hls(config.root_dir / "run.tcl", work_dir=config.root_dir,
                                         capture_output=not live_output, env=env)
    except Exception as exc:  # CalledProcessError carries the Vitis log
        out = getattr(exc, "stdout", "") or ""
        raise RuntimeError(f"Vitis {stage} (w{word_bw}) failed: {exc}\n{out[-3000:]}") from exc
    if not live_output and result.stdout:
        print(result.stdout[-2000:])


@dataclass(kw_only=True)
class CSimStep(BuildStep):
    description = "Vitis C simulation of every scenario at each width, with fir_tb.cpp."
    consumes = ["fir_cpp", "fir_hpp", "fir_body_impl", "include_dir", "scenario_list"]
    produces = {"csim_done": Path("results/csim_done.txt")}
    params = {"live_output": False, "clk_freq": 100e6}

    def run(self, config: BuildConfig, live_output, clk_freq, **_) -> dict:
        root = config.root_dir
        _require_real_body(root)
        for bw in WIDTHS:
            for name in _names(root, bw):
                (width_dir(root, bw) / name / "csim").mkdir(parents=True, exist_ok=True)
            _run_vitis(config, "csim", bw, live_output, clk_freq)
        done = root / "results" / "csim_done.txt"
        done.write_text("done\n", encoding="utf-8")
        return {"csim_done": done}


@dataclass(kw_only=True)
class CSynthStep(BuildStep):
    """C synthesis of one width's top, then RTL co-simulation of the timing scenario."""
    word_bw: int
    description = "Vitis C synthesis, then RTL co-simulation of the timing scenario."
    params = {"live_output": False, "clk_freq": 100e6}

    @property
    def consumes(self) -> list:  # type: ignore[override]
        return ["fir_cpp", "fir_hpp", "fir_body_impl", "include_dir", "check_csim"]

    @property
    def produces(self) -> dict:  # type: ignore[override]
        w = self.word_bw
        return {f"report_dir_w{w}": Path(f"w{w}_proj/solution1"),
                f"cosim_done_w{w}": Path(f"results/cosim_done_w{w}.txt")}

    def run(self, config: BuildConfig, live_output, clk_freq, **_) -> dict:
        root, w = config.root_dir, self.word_bw
        for n in _names(root, w):
            (width_dir(root, w) / n / "cosim").mkdir(parents=True, exist_ok=True)
        _run_vitis(config, "synth", w, live_output, clk_freq)
        done = root / "results" / f"cosim_done_w{w}.txt"
        done.write_text("all\n", encoding="utf-8")
        return {f"report_dir_w{w}": root / f"w{w}_proj" / "solution1",
                f"cosim_done_w{w}": done}


@dataclass(kw_only=True)
class SummaryStep(BuildStep):
    """Everything in one place, and the target that runs every check.

    ``--through`` runs only a step's ancestors, so a pipeline ending at a timing check
    would skip the cosim response check and the synthesis reports.  This step depends on
    all of them and writes ``results/summary.json``.
    """
    description = "Collect every check, the synthesis reports and the verdicts."
    consumes = ["check_model", "check_pysim", "check_csim", "check_cosim",
                *[f"{a}_w{w}" for w in WIDTHS for a in ("loop_df", "resources")]]
    produces = {"summary": Path("results/summary.json")}
    params = {}

    def run(self, config: BuildConfig, **art) -> dict:
        def load(key):
            return json.loads(Path(art[key]).read_text(encoding="utf-8"))
        summary = {
            "checks": {k.removeprefix("check_"): {n: (not v) for n, v in load(k).items()}
                       for k in ("check_model", "check_pysim", "check_csim", "check_cosim")},
            "loops": {f"w{w}": Path(art[f"loop_df_w{w}"]).read_text(encoding="utf-8")
                      for w in WIDTHS},
            "resources": {f"w{w}": load(f"resources_w{w}") for w in WIDTHS},
        }
        out = config.root_dir / "results" / "summary.json"
        out.write_text(json.dumps(summary, indent=2), encoding="utf-8")
        return {"summary": out}


def build_fir_dag() -> BuildDag:
    """The whole pipeline.  Parameters come from ``BuildConfig.params``: ``clk_freq``,
    ``unroll_factor`` and ``live_output``."""
    dag = BuildDag()
    dag.add(SourceStep(artifact="fir_source", path=_SOURCE_DIR / "fir.py",
                       description="Schemas, the pure model, the module and the pysim testbench."))
    dag.add(SourceStep(artifact="scenarios_source", path=_SOURCE_DIR / "scenarios.py",
                       description="The scenarios, their expected responses, and the checker."))

    # Python: the model and pysim, checked against the expected responses.
    dag.add(ScenariosStep(name="scenarios"))
    dag.add(ModelStep(name="py_model"))
    dag.add(CheckStep(name="check_model", stage="model", done_artifacts=("model_done",)))
    dag.add(PySimStep(name="py_sim"))
    dag.add(CheckStep(name="check_pysim", stage="pysim", done_artifacts=("pysim_done",),
                      which="pysim"))

    # Code generation: headers, and the kernel boundary around the hand-written body.
    dag.add(HlsGenIncludeStep(name="gen_include"))
    dag.add(SourcesStep(name="sources"))
    dag.add(HlsCodegenStep(name="gen_kernel", comp_class=FirAccel,
                           source_artifact="kernel_sources", output_dir="gen", impl_dir="."))

    # Vitis: csim on every scenario, then synthesis and cosim of the timing scenario.
    dag.add(CSimStep(name="csim"))
    dag.add(CheckStep(name="check_csim", stage="csim", done_artifacts=("csim_done",)))
    for w in WIDTHS:
        dag.add(CSynthStep(name=f"csynth_w{w}", word_bw=w))
        # The framework's step: the report attributed (and filed, with a platform), the loop table
        # written, and the build failed on a pipelined loop at II > 1.
        dag.add(InspectSynthStep(
            name=f"inspect_synth_w{w}", comp_class=FirAccel, top_name=TOPS[w],
            elaborate_params=("in_bw", "out_bw"), params={"in_bw": w, "out_bw": w},
            report_artifact=f"report_dir_w{w}", seconds_artifact=None,
            output=Path(f"results/resources_w{w}.json"), output_artifact=f"resources_w{w}",
            require_ii1=True, loop_csv=Path(f"results/loop_df_w{w}.csv"),
            loop_artifact=f"loop_df_w{w}"))
    dag.add(CheckStep(name="check_cosim", stage="cosim",
                      done_artifacts=tuple(f"cosim_done_w{w}" for w in WIDTHS)))
    dag.add(SummaryStep(name="summary"))

    return dag


def main() -> None:
    run_dag_cli(
        build_fir_dag,
        description="Build the streaming polynomial accelerator.",
        default_through="check_pysim",
        root_dir=_SOURCE_DIR,
        extra_args=[
            (("--clk-freq",), {"type": float, "default": 100e6, "metavar": "HZ"}),
            (("--unroll-factor",), {"type": int, "default": 1}),
            (("--live-output",), {"action": "store_true"}),
        ],
        params_from_args=lambda a: {"clk_freq": a.clk_freq, "unroll_factor": a.unroll_factor,
                                    "live_output": a.live_output},
    )


if __name__ == "__main__":
    main()
