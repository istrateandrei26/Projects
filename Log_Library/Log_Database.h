#pragma once

#include "Log.h"

class Log_Database : public Log {

public:
	Log_Database(const char* filename = "Log.txt") : Log(filename) { ; }
	~Log_Database() { ; }

	void Info(const char* message) override;
	void Warn(const char* message) override;
	void Error(const char* message) override;

};