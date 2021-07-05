#pragma once
#include "CException.h"

class Exception_LoginManager :
    public CException
{
public:
    Exception_LoginManager(const std::string message = "[-] LOGIN MANAGER error", int code = 3002) : CException(message, code) { ; }

    int Print()const override {

        std::cout << "[-] LOGIN MANAGER error: " << m_code << " | Error message: " << m_message << std::endl << std::endl;
        return m_code;
    }
};