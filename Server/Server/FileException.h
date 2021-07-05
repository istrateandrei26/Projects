#pragma once
#include "CException.h"

class File_Exception :
    public CException
{
public:
    File_Exception(const std::string message = "[-] File error") :CException(message) {}
};