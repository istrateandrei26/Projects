#pragma once
#include "Log.h"

class Log_Client :
    public Log
{
public:
	Log_Client(const char* filename = "Log.txt") : Log(filename) { ; }
	~Log_Client() { ; }

	void Info(const char* message) override;
	void Warn(const char* message) override;
	void Error(const char* message) override;

	
};

