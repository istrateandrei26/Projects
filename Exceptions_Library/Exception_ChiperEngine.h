#pragma once
#include "CException.h"

class Exception_ChiperEngine :
    public CException
{
public:
    Exception_ChiperEngine( const std::string message = "[-] CHIPER ENGINE error", int code = 3004) : CException(message, code) { ; }

    int Print()const override {

        std::cout << "[-] CHIPER ENGINE error: " << m_code << " | Error message: " << m_message << std::endl << std::endl;
        return m_code;
    }
};