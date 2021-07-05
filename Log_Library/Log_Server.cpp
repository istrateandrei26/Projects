#include "pch.h"
#include "Log_Server.h"

#include <iostream>
#include <fstream>


//Log* Log::mpInstance = NULL;
//Log::Levels Log::m_level = Log_INFO;

void Log_Server::Info(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}

	if (m_level <= Log_INFO)
		file << "[LOG SERVER][INFO]..............." << message << std::endl;

	file.close();
}
void Log_Server::Warn(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_WARNING)
		file << "[LOG SERVER][WARNING]..............." << message << std::endl;

	file.close();
}
void Log_Server::Error(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_ERROR)
		file << "[LOG SERVER][ERROR]..............." << message << std::endl;

	file.close();
}