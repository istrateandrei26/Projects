#pragma once
#include "Log.h"
class Log_Protocol :
    public Log
{
public:
	Log_Protocol(const char* filename = "Log.txt") : Log(filename) { ; }
	~Log_Protocol() { ; }

	void Info(const char* message) override;
	void Warn(const char* message) override;
	void Error(const char* message) override;
};

