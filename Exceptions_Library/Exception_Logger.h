#pragma once
#include "CException.h"

class Exception_Logger :
    public CException
{
public:
    Exception_Logger(const std::string message = "[-] LOGGER error", int code = 3006) : CException(message, code) { ; }

    int Print()const override {

        std::cout << "[-] LOGGER error: " << m_code << " | Error message: " << m_message << std::endl << std::endl;
        return m_code;
    }
};