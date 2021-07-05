#include "CFilesManager.h"

#include <fstream>
#include <filesystem>
namespace fs = std::filesystem;

void CFilesManager::Set_CurrentFilepath(std::string currentFilepath) {

	m_currentFilepath = currentFilepath;
	LastCharOfPath(&currentFilepath);
}
void CFilesManager::Set_CurrentFilename(std::string currentFilename) {

	m_currentFilename = currentFilename;
}

bool CFilesManager::PreparePath(std::string path) {

	LastCharOfPath(&path);
	fs::create_directories(path);
	return fs::is_directory(path);
}
std::string CFilesManager::PrepareFilename(std::string path, std::string filename) {

	LastCharOfPath(&path);
	std::string fullname = path + filename;

	int x = 1;
	std::string copy_filename = filename;

	int poz = filename.find_last_of(".");
	std::string extensie = filename.substr(poz, filename.length() - poz);
	filename = filename.substr(0, poz);

	while (fs::exists(fullname)) {

		copy_filename = filename + "(" + std::to_string(x) + ")" + extensie;
		fullname = path + copy_filename;
		x++;
	}

	return fullname;
}

int CFilesManager::WriteInFile(std::string filePath, std::string text, std::ios_base::openmode openmode) {

	std::ofstream file(filePath.c_str(), openmode);
	if (!file.is_open())
		return false;

	file << text;

	file.close(); 
	return true;
}

void CFilesManager::LastCharOfPath(std::string* path) {

	std::string separator;
	if (std::string::npos != path->find_first_of("/")) {

		separator = "/";
	}
	else {
		separator = "\\";
	}

	auto it = path->end();
	it--;
	if (*it != separator[0]) {

		*path += separator;
	}
}