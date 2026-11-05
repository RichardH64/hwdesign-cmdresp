// fir_body_impl.tpp -- the WHOLE kernel body, hand-written.
//
// Included from gen/fir.hpp.  The generated top (gen/fir.cpp) holds every interface pragma and
// calls body() with every kernel argument; the status registers are references, so this code
// writes halted / error / tx_id itself.  The Python twin, bit for bit, is fir_stream_model()
// in fir.py.
//
// Commands (cmd_type): CONFIG 0, PROCESS 1, END 2; anything else is UNKNOWN_CMD.
//   CONFIG   header{ntaps}, then ntaps float32 taps (TLAST on the last); response header after.
//   PROCESS  header{nsamp}, response header, then nsamp samples in / nsamp results out.
//   END      response header, return.
// Header errors write nothing for the command and read nothing more.  On a TLAST error the
// output burst in progress is closed, and the kernel returns without reading more input.
//
// The filter is a 32-term chain: term k multiplies tap k by the sample k places back (a shift
// register of 32 floats), and the products are added to a running sum that starts at +0.0f, in
// order k = 0, 1, ...  Terms with k >= ntaps are skipped.  The sample loop is pipelined at
// II = 1, so the unrolled multiplier / adder chain is filled with a new sample every clock.

#include "include/float32_array_utils.h"
#include "include/fir_cmd_hdr.h"
#include "include/fir_resp_hdr.h"
#include "include/fir_error.h"

namespace fir_impl {

static const int MAX_TAPS = 32;
static const int MAX_SAMPLES = 1024;

static inline ap_uint<8> code(FirError e) {
#pragma HLS INLINE
    return (ap_uint<8>)static_cast<unsigned int>(e);
}

static inline void halt(FirError e, const ap_uint<16>& tx, ap_uint<1>& halted, ap_uint<8>& error,
                        ap_uint<16>& tx_id) {
#pragma HLS INLINE
    error = code(e);
    tx_id = tx;
    halted = 1;
}

template <int in_bw, int out_bw>
static void respond(const ap_uint<16>& tx, const ap_uint<16>& nsamp,
                    hls::stream<streamutils::axi4s_word<out_bw>>& m_out) {
#pragma HLS INLINE
    FirRespHdr resp_hdr;
    resp_hdr.tx_id = tx;
    resp_hdr.nsamp = nsamp;
    resp_hdr.write_axi4_stream<out_bw>(m_out, true);
}

// The kernel: one activation, a loop over in-band commands until END or an error.
template <int in_bw, int out_bw>
void body(hls::stream<streamutils::axi4s_word<in_bw>>& s_in,
          hls::stream<streamutils::axi4s_word<out_bw>>& m_out,
          ap_uint<1>& halted, ap_uint<8>& error, ap_uint<16>& tx_id) {
#pragma HLS INLINE
    halted = 0;
    error = code(FirError::NO_ERROR);
    tx_id = 0;

    float taps[MAX_TAPS];
    float win[MAX_TAPS];      // win[k] = x[n-k] once x[n] has been shifted in
#pragma HLS ARRAY_PARTITION variable=taps complete dim=1
#pragma HLS ARRAY_PARTITION variable=win complete dim=1
    for (int k = 0; k < MAX_TAPS; ++k) {
#pragma HLS UNROLL
        taps[k] = 0.0f;
        win[k] = 0.0f;
    }
    bool configured = false;
    int ntaps = MAX_TAPS;

    while (true) {
        FirCmdHdr cmd_hdr;
        cmd_hdr.read_axi4_stream<in_bw>(s_in);
        const ap_uint<16> tx = cmd_hdr.tx_id;

        // Header checks, in order: unknown command, PROCESS before CONFIG, invalid count.
        if (cmd_hdr.cmd_type > 2) {
            halt(FirError::UNKNOWN_CMD, tx, halted, error, tx_id);
            return;
        }
        if (cmd_hdr.cmd_type == 2) {          // END
            respond<in_bw, out_bw>(tx, 0, m_out);
            return;
        }
        const bool is_config = (cmd_hdr.cmd_type == 0);
        if (!is_config && !configured) {
            halt(FirError::NO_CONFIG, tx, halted, error, tx_id);
            return;
        }
        const int count = is_config ? (int)cmd_hdr.ntaps : (int)cmd_hdr.nsamp;
        const int limit = is_config ? MAX_TAPS : MAX_SAMPLES;
        if (count < 1 || count > limit) {
            halt(FirError::BAD_COUNT, tx, halted, error, tx_id);
            return;
        }

        if (is_config) {
            // The taps: nothing is sent for this command if the burst is malformed.
            ap_uint<8> err = code(FirError::NO_ERROR);
            for (int j = 0; j < count; ++j) {
                float t[1];
                streamutils::tlast_status tl = streamutils::tlast_status::no_tlast;
                float32_array_utils::read_axi4_stream_lane<in_bw>(s_in, t, 1, tl);
                taps[j] = t[0];
                const bool last_tap = (j == count - 1);
                const bool in_tlast = (tl == streamutils::tlast_status::tlast_at_end);
                if (in_tlast && !last_tap) {
                    err = code(FirError::TLAST_EARLY);
                    break;
                }
                if (last_tap && !in_tlast) {
                    err = code(FirError::NO_TLAST);
                }
            }
            if (err != code(FirError::NO_ERROR)) {
                error = err;
                tx_id = tx;
                halted = 1;
                return;
            }
            for (int k = 0; k < MAX_TAPS; ++k) {      // new taps: forget the old samples
#pragma HLS UNROLL
                win[k] = 0.0f;
            }
            configured = true;
            ntaps = count;
            respond<in_bw, out_bw>(tx, 0, m_out);
            continue;
        }

        // PROCESS: the response header first, then one result per sample.
        respond<in_bw, out_bw>(tx, cmd_hdr.nsamp, m_out);
        ap_uint<8> err = code(FirError::NO_ERROR);
        bool stop = false;
        for (int i = 0; i < count; ++i) {
#pragma HLS PIPELINE II=1
            if (!stop) {
                float x[1];
                streamutils::tlast_status tl = streamutils::tlast_status::no_tlast;
                float32_array_utils::read_axi4_stream_lane<in_bw>(s_in, x, 1, tl);
                const bool in_tlast = (tl == streamutils::tlast_status::tlast_at_end);
                const bool final_word = (i == count - 1);

                for (int k = MAX_TAPS - 1; k > 0; --k) {
#pragma HLS UNROLL
                    win[k] = win[k - 1];
                }
                win[0] = x[0];

                // h[0]*x[n] + h[1]*x[n-1] + ..., each multiply and add its own statement.
                float acc = 0.0f;
                for (int k = 0; k < MAX_TAPS; ++k) {
#pragma HLS UNROLL
                    float prod = taps[k] * win[k];
                    float sum = acc + prod;
                    if (k < ntaps) {                  // terms k >= ntaps are skipped
                        acc = sum;
                    }
                }
                float y[1];
                y[0] = acc;
                float32_array_utils::write_axi4_stream_lane<out_bw>(y, m_out,
                                                                    final_word || in_tlast, 1);
                if (in_tlast && !final_word) {
                    err = code(FirError::TLAST_EARLY);
                    stop = true;
                } else if (final_word && !in_tlast) {
                    err = code(FirError::NO_TLAST);
                }
            }
        }
        if (err != code(FirError::NO_ERROR)) {
            error = err;
            tx_id = tx;
            halted = 1;
            return;
        }
    }
}

}  // namespace fir_impl
