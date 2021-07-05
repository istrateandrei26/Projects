#pragma once
#include "CException.h"

class Exception_File :
    public CException
{
public:
    Exception_File(const std::string message = "[-] FILE error", int code = 3000) : CException(message, code) { ; }

    int Print()const override {

        std::cout << "[-] FILE error: " << m_code << " | Error message: " << m_message << std::endl << std::endl;
        return m_code;
    }
};