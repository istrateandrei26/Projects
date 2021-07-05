#pragma once
#include "pch.h"
#include "CException.h"

class Exception_Client :
    public CException
{
public:
    Exception_Client(const std::string message = "[-] CLIENT error", int code = 3005) : CException(message, code) { ; }

    int Print()const override {

        std::cout << "[-] CLIENT error: " << m_code << " | Error message: " << m_message << std::endl << std::endl;
        return m_code;
    }
};