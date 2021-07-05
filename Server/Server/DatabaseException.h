#pragma once
#include "CException.h"


class Database_Exception :
    public CException
{
public:
    Database_Exception(const std::string message = "[-] Database encountered an error") :CException(message) {}
};