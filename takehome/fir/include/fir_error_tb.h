#ifndef INCLUDE_FIR_ERROR_TB_H
#define INCLUDE_FIR_ERROR_TB_H

#include <cctype>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <iterator>
#include <stdexcept>
#include <string>
#include "streamutils_tb.h"

#define WAVEFLOW_ENABLE_FIR_ERROR_TB_H_MEMBERS
#include "fir_error.h"
#undef WAVEFLOW_ENABLE_FIR_ERROR_TB_H_MEMBERS

inline const char* enum_to_string(FirError value) {
    switch (value) {
    case FirError::NO_ERROR:
        return "NO_ERROR";
    case FirError::UNKNOWN_CMD:
        return "UNKNOWN_CMD";
    case FirError::NO_CONFIG:
        return "NO_CONFIG";
    case FirError::BAD_COUNT:
        return "BAD_COUNT";
    case FirError::TLAST_EARLY:
        return "TLAST_EARLY";
    case FirError::NO_TLAST:
        return "NO_TLAST";
    default:
        return "UNKNOWN";
    }
}

#endif // INCLUDE_FIR_ERROR_TB_H