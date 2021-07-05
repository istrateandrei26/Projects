#pragma once
#include "Log.h"
class Log_ChiperEngine :
    public Log
{
public:
	Log_ChiperEngine(const char* filename = "Log.txt") : Log(filename) { ; }
	~Log_ChiperEngine() { ; }

	void Info(const char* message) override;
	void Warn(const char* message) override;
	void Error(const char* message) override;
};

