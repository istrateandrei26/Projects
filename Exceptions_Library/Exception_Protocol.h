#pragma once
#include "CException.h"

class Exception_Protocol :
    public CException
{
public:
    Exception_Protocol(const std::string message = "[-] PROTOCOL error", int code = 3007) : CException(message, code) { ; }

    int Print()const override {

        std::cout << "[-] PROTOCOL error: " << m_code << " | Error message: " << m_message << std::endl << std::endl;
        return m_code;
    }
};