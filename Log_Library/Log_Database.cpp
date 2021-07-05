#include "pch.h"
#include "Log_Database.h"

#include <iostream>
#include <fstream>




void Log_Database::Info(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}

	if (m_level <= Log_INFO)
	{
		file << "[DATABASE][INFO]..............." << message << std::endl;
	}

	file.close();
}
void Log_Database::Warn(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if(m_level <= Log_WARNING)
		file << "[DATABASE][WARNING]..............." << message << std::endl;

	file.close();
}
void Log_Database::Error(const char* message) {

	std::ofstream file(m_filename.c_str(), std::ios::app);
	if (!file.is_open()) {

		//o valoare de return specifica
		exit(1);
	}
	if(m_level <= Log_ERROR)
		file << "[DATABASE][ERROR]..............." << message << std::endl;

	file.close();
}

