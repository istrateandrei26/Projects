#include "pch.h"
#include "Log.h"


#include <iostream>


Log::Log(const char* filename) {

	m_level = Levels::Log_INFO;
	m_filename = filename;

}
void Log::SetLevel(Levels level) {

	m_level = level;
}