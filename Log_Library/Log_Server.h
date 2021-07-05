#pragma once
#include "Log.h"
class Log_Server :
    public Log
{
public:
	Log_Server(const char* filename = "Log.txt") : Log(filename) { ; }
	~Log_Server() { ; }

	void Info(const char* message) override;
	void Warn(const char* message) override;
	void Error(const char* message) override;
};

