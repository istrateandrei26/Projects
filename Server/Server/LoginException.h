#pragma once
#include "CException.h"

class Login_Exception :
    public CException
{
public:
    Login_Exception(const std::string message = "[-] Login Manager encountered an error") :CException(message) {}
};