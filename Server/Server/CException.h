#pragma once
#include "IException.h"

class CException : public IException
{
protected:
	std::string message;
public:
	CException(const std::string message) :message(message) {}
	virtual ~CException() {}

	std::string get_error_message()const override { return message; }

};