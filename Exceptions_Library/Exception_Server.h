#pragma once
#include "CException.h"

class Exception_Server :
    public CException
{
public:
    Exception_Server(const std::string message = "[-] SERVER error", int code = 3006) : CException(message, code) { ; }

    int Print()const override {

        std::cout << "[-] SERVER error: " << m_code << " | Error message: " << m_message << std::endl << std::endl;
        return m_code;
    }
};