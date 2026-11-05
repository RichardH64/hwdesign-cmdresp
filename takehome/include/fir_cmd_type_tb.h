#ifndef INCLUDE_FIR_CMD_TYPE_TB_H
#define INCLUDE_FIR_CMD_TYPE_TB_H

#include <cctype>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <iterator>
#include <stdexcept>
#include <string>
#include "streamutils_tb.h"

#define WAVEFLOW_ENABLE_FIR_CMD_TYPE_TB_H_MEMBERS
#include "fir_cmd_type.h"
#undef WAVEFLOW_ENABLE_FIR_CMD_TYPE_TB_H_MEMBERS

inline const char* enum_to_string(FirCmdType value) {
    switch (value) {
    case FirCmdType::DATA:
        return "DATA";
    case FirCmdType::END:
        return "END";
    default:
        return "UNKNOWN";
    }
}

#endif // INCLUDE_FIR_CMD_TYPE_TB_H