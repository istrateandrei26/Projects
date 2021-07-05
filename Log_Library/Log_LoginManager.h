#pragma once
#include "Log.h"
class Log_LoginManager :
    public Log
{

public:
	Log_LoginManager(const char* filename = "Log.txt") : Log(filename) { ; }
	~Log_LoginManager() { ; }

	 void Info(const char* message) override;
	 void Warn(const char* message) override;
	 void Error(const char* message) override;

};

