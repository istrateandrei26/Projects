#pragma once
#include "Log.h"
class Log_Exceptions :
    public Log
{
public:
	Log_Exceptions(const char* filename = "Log.txt") : Log(filename) { ; }
	~Log_Exceptions() { ; }

	void Info(const char* message) override;
	void Warn(const char* message) override;
	void Error(const char* message) override;
};

