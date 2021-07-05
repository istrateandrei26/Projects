#include "pch.h"
#include "Log_Protocol.h"

#include <iostream>
#include <fstream>


//Log* Log::mpInstance = NULL;
//Log::Levels Log::m_level = Log_INFO;

void Log_Protocol::Info(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}

	if (m_level <= Log_INFO)
		file << "[PROTOCOL][INFO]..............." << message << std::endl;

	file.close();
}
void Log_Protocol::Warn(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_WARNING)
		file << "[PROTOCOL][WARNING]..............." << message << std::endl;

	file.close();
}
void Log_Protocol::Error(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_ERROR)
		file << "[PROTOCOL][ERROR]..............." << message << std::endl;

	file.close();
}