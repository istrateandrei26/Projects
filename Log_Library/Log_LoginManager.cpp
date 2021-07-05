#include "pch.h"
#include "Log_LoginManager.h"

#include <iostream>
#include <fstream>


//Log* Log::mpInstance = NULL;
//Log::Levels Log::m_level = Log_INFO;

void Log_LoginManager::Info(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}

	if (m_level <= Log_INFO)
		file << "[LOGIN MANAGER][INFO]..............." << message << std::endl;

	file.close();
}
void Log_LoginManager::Warn(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_WARNING)
		file << "[LOGIN MANAGER][WARNING]..............." << message << std::endl;

	file.close();
}
void Log_LoginManager::Error(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_ERROR)
		file << "[LOGIN MANAGER][ERROR]..............." << message << std::endl;

	file.close();
}

