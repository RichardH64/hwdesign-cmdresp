#ifndef INCLUDE_FIR_ERROR_H
#define INCLUDE_FIR_ERROR_H

#include <ap_int.h>
#include <hls_stream.h>
#if __has_include(<hls_axi_stream.h>)
#include <hls_axi_stream.h>
#else
#include <ap_axi_sdata.h>
#endif
#include "streamutils_hls.h"

enum class FirError {
    NO_ERROR = 0,
    UNKNOWN_CMD = 1,
    NO_CONFIG = 2,
    BAD_COUNT = 3,
    TLAST_EARLY = 4,
    NO_TLAST = 5,
};

#endif // INCLUDE_FIR_ERROR_H