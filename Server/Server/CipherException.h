#pragma once
#include "CException.h"

class Cipher_Exception :
    public CException
{
public:
    Cipher_Exception(const std::string message = "[-] Cipher engine encountered an error") :CException(message) {}
};