#pragma once
#include "pch.h"
#include "IException.h"

class CException : public IException
{

public:
	CException( const std::string message, int code) : m_message(message), m_code(code) {}
	virtual ~CException() {}

	int get_error_code()const override { return m_code; }
	std::string get_error_message()const override { return m_message; }

protected:
	int m_code;
	std::string m_message;
};