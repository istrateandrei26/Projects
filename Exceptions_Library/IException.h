#pragma once


#include <iostream>

#ifdef EXCEPTIONLIBRARY_EXOPORT
#define EXCEPTION_API __declspec(dllexport)
#else
#define EXCEPTION_API __declspec(dllimport)
#endif

class IException
{
public:
	IException() {}
	virtual ~IException() {}

	EXCEPTION_API virtual int get_error_code()const = 0;
	EXCEPTION_API virtual std::string get_error_message()const = 0;
	EXCEPTION_API virtual int Print()const = 0;
};