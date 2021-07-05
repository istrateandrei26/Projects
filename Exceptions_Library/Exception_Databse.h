#pragma once
#include "CException.h"

class Exception_Databse :
    public CException
{
public:
    Exception_Databse(const std::string message = "[-] DATABASE error", int code = 3003) : CException(message, code) { ; }

    int Print()const override {

        std::cout << "[-] DATABASE error: " << m_code << " | Error message: " << m_message << std::endl << std::endl;
        return m_code;
    }
};