#pragma once
#include "CException.h"

class Exception_Method :
    public CException
{
public:
    Exception_Method(const std::string message = "[-] Called invalid method", int code = 3001 ) :CException(message, code) { ; }
    int Print()const override {

        std::cout << "[-] METHOD error: " << m_code << " | Error message: " << m_message << std::endl << std::endl;
        return m_code;
    }
};