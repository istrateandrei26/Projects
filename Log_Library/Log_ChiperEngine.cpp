#include "pch.h"
#include "Log_ChiperEngine.h"

#include <iostream>
#include <fstream>


//Log* Log::mpInstance = NULL;
//Log::Levels Log::m_level = Log_INFO;

void Log_ChiperEngine::Info(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app );
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}

	if (m_level <= Log_INFO)
		file << "[CHIPER ENGINE][INFO]..............." << message << std::endl;

	file.close();
	
}
void Log_ChiperEngine::Warn(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_WARNING)
		file << "[CHIPER ENGINE][WARNING]..............." << message << std::endl;

	file.close();
}
void Log_ChiperEngine::Error(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if (m_level <= Log_ERROR)
		file << "[CHIPER ENGINE][ERROR]..............." << message << std::endl;

	file.close();
}

