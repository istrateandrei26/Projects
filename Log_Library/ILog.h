#pragma once

#pragma once

#include "MACROS_LogClasses.h"


#ifdef LOGLIBRARY_EXPORTS
#define LOGLIBRARY_API __declspec(dllexport)
#else
#define LOGLIBRARY_API __declspec(dllimport)
#endif


extern "C" LOGLIBRARY_API class  ILog {

public:
	ILog() { ;  }
	virtual ~ILog() { ; }

	LOGLIBRARY_API enum Levels {
		Log_INFO = 0,
		Log_WARNING,
		Log_ERROR
	};

	LOGLIBRARY_API virtual void SetLevel(Levels level) = 0;

	LOGLIBRARY_API virtual void Info(const char* message) = 0;
	LOGLIBRARY_API virtual void Warn(const char* message) = 0;
	LOGLIBRARY_API virtual void Error(const char* message) = 0;

};

extern "C" LOGLIBRARY_API class Log_Factory {

public:
	LOGLIBRARY_API static ILog* Create_Logger(int type, const char* filename = "Log.txt");
};


