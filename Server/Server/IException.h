#pragma once

#include <iostream>

class IException
{
public:
	IException() {}
	virtual ~IException() {}

	virtual std::string get_error_message()const = 0;

};