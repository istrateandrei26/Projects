#include "pch.h"
#include "Log_Exceptions.h"

#include <iostream>
#include <fstream>


//Log* Log::mpInstance = NULL;
//Log::Levels Log::m_level = Log_INFO;

void Log_Exceptions::Info(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}

	if (m_level <= Log_INFO)
		file << "[EXCEPTIONS][INFO]..............." << message << std::endl;

	file.close();
}
void Log_Exceptions::Warn(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_WARNING)
		file << "[EXCEPTIONS][WARNING]..............." << message << std::endl;

	file.close();
}
void Log_Exceptions::Error(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_ERROR)
		file << "[EXCEPTIONS][ERROR]..............." << message << std::endl;

	file.close();
}