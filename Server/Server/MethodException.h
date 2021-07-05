#pragma once
#include "CException.h"



class Method_Exception :
    public CException
{
public:
    Method_Exception(const std::string message = "[-] Called invalid method") :CException(message) {}
};