#define _CRT_SECURE_NO_WARNINGS

#include "CFilesManager.h"
#include "IMessage.h"
#include "MACRO_Protocol.h"
#include "Exception_File.h"
#include "MACRO_Server.h"


#include <ctime>
#include <fstream>
#include <filesystem>
namespace fs = std::filesystem;


//pentru preluarea ultimei date cand s-a modificat un fisier
#include <sys/types.h>
#include <sys/stat.h>
#ifndef WIN32
#include <unistd.h>
#endif
#ifdef WIN32
#define stat _stat
#endif


CFilesManager::CFilesManager() {

	m_keysPath = "D:/ANUL 2 sem II/PROIECT POO/Server/Keys/";
	m_storagePath = "D:/ANUL 2 sem II/PROIECT POO/Server/Storage/";
	m_filesFolderName = "Files";
	m_fileDetailsFolderName = "Files Details";

	m_privateKeyFilename = "private_key.txt";
	m_publicKeyFilename = "public_key.txt";
}

std::string CFilesManager::GetClientFilePath(std::string username) {

	return m_storagePath + username + "/" + m_filesFolderName + "/";
}

std::string CFilesManager::GetPivateKeyFilePath()
{
	return m_keysPath + m_privateKeyFilename;
}

std::string CFilesManager::GetPublicKeyFilePath()
{
	return m_keysPath + m_publicKeyFilename;
}



int CFilesManager::Proceseaza_NewFile(IMessage* mess, std::string username, bool binary) {

	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;	//trecem de type
	it++;	//trecem de mod


	std::string filename = *it;
	std::string path = GetClientFilePath(username);
	path += filename;

	if (fs::exists(path)) {

		//returnam valoarea ce indica ca deja exista un asa fisier
		return PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST;
	}
	else {
		//creem fisier
		//punem date
		//returnam succes
		it++;
		std::string text = *it;

		std::string detailsFile = GetClientFileDetailsPath(username);
		detailsFile += filename;
		WriteInFile(path, detailsFile, text, std::ios::out,binary);
		return PROT_FILE_UPLOAD_RESPONSE_SUCCEDED;
	}

	return 0;
}
int CFilesManager::Proceseaza_ReplaceFile(IMessage* mess, std::string username, bool binary) {

	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;	//trecem de type
	it++;	//trecem de mod

	std::string filename = *it;
	std::string path = GetClientFilePath(username);
	path += filename;


	it++;
	std::string text = *it;
	std::string detailsFile = GetClientFileDetailsPath(username);
	detailsFile += filename;
	WriteInFile(path, detailsFile, text, std::ios::out,binary);
	return PROT_FILE_UPLOAD_RESPONSE_SUCCEDED;


}
int CFilesManager::Proceseaza_AppendFile(IMessage* mess, std::string username, bool binary) {

	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;	//trecem de type
	it++;	//trecem de mod

	std::string filename = *it;
	std::string path = GetClientFilePath(username);
	path += filename;

	if (!fs::exists(path)) {
		//aici intra doar dupa ce trece prin creearea fisierului
		//ca in aplicatia client configuratie asa e facuta
		//daca ajunge aiic, baiul e la aplciatia client 
		//ca timite in modul append inainte de a creea
		throw new Exception_File("Nu ar trebui sa se intample asta. AppendFile nu exista");
	}
	else {

		it++;
		std::string text = *it;
		std::string detailsFile = GetClientFileDetailsPath(username);
		detailsFile += filename;
		WriteInFile(path, detailsFile, text, std::ios::app,binary);
		return PROT_FILE_UPLOAD_RESPONSE_SUCCEDED;
	}
	return 0;
}


std::string CFilesManager::ReadFromFile(std::string filename, std::string detailsPath, int chunk, int* fileEnded) {

	std::ifstream file(filename.c_str());
	char* chunk_ofFile = new char[MESS_ENCRYPTED_MAX_LENGHT];
	std::string string_chunk;
	*fileEnded = false;

	int lenght, number_ofEndOfLine;
	long long int pozitie_cursor = GetChunkPositions(detailsPath, chunk, lenght, number_ofEndOfLine);


	file.seekg(pozitie_cursor, file.beg);

	file.read(chunk_ofFile, lenght);
	chunk_ofFile[lenght] = '\0';

	lenght -= number_ofEndOfLine;
	chunk_ofFile[lenght] = '\0';

	string_chunk = chunk_ofFile;

	if (file.eof()) {

		*fileEnded = true;

	}

	delete chunk_ofFile;

	return string_chunk;
}

int CFilesManager::ShowAllFiles(std::string username, std::list<std::string>* lista_numeFisiere) {

	std::string data_lastTime;
	std::string path = GetClientFilePath(username);
	for (const auto& fisier : fs::directory_iterator(path)) {

		lista_numeFisiere->push_back(fisier.path().filename().string());
	}

	return SUCCEEDED;
}
int  CFilesManager::ShowFilesFromMonth(std::string username, std::list<std::string>* lista_numeFisiere, std::string data) {

	std::string filepath;
	struct tm lastTime;
	std::string data_lastTime;
	data = data.substr(2, 8);
	std::string path = GetClientFilePath(username);
	for (const auto& fisier : fs::directory_iterator(path)) {

		//formam numele fisierului + calea completa
		filepath = path + fisier.path().filename().string();
		//luam sub forma de struct tm, ultima data cand a fost modificat
		lastTime = GetFileLastTimeModified(filepath);
		//facem un sir de forma DD/MM/YYYY din acea structura
		data_lastTime = TimeStructureToString(lastTime);

		data_lastTime = data_lastTime.substr(2, 8); //  /MM/YYYY	

		if (data == data_lastTime)
			lista_numeFisiere->push_back(fisier.path().filename().string());
	}

	return SUCCEEDED;
}
int  CFilesManager::ShowFilesFromDay(std::string username, std::list<std::string>* lista_numeFisiere, std::string data) {

	std::string filepath;
	struct tm lastTime;
	std::string data_lastTime;
	std::string path = GetClientFilePath(username);
	for (const auto& fisier : fs::directory_iterator(path)) {

		//formam numele fisierului + calea completa
		filepath = path + fisier.path().filename().string();
		//luam sub forma de struct tm, ultima data cand a fost modificat
		lastTime = GetFileLastTimeModified(filepath);
		//facem un sir de forma DD/MM/YYYY din acea structura
		data_lastTime = TimeStructureToString(lastTime);

		if (data == data_lastTime)
			lista_numeFisiere->push_back(fisier.path().filename().string());
	}

	return SUCCEEDED;
}
int  CFilesManager::ShowFilesFromDayToPresent(std::string username, std::list<std::string>* lista_numeFisiere, std::string data) {

	std::string filepath;
	struct tm lastTime;
	std::string data_lastTime;
	std::string path = GetClientFilePath(username);

	std::string anul = data.substr(6, 4);
	std::string luna = data.substr(3, 2);
	std::string ziua = data.substr(0, 2);

	std::string anul_lastTime, luna_lastTime, ziua_lastTime;
	for (const auto& fisier : fs::directory_iterator(path)) {

		//formam numele fisierului + calea completa
		filepath = path + fisier.path().filename().string();
		//luam sub forma de struct tm, ultima data cand a fost modificat
		lastTime = GetFileLastTimeModified(filepath);
		//facem un sir de forma DD/MM/YYYY din acea structura
		data_lastTime = TimeStructureToString(lastTime);
		std::string anul_lastTime = data_lastTime.substr(6, 4);
		std::string luna_lastTime = data_lastTime.substr(3, 2);
		std::string ziua_lastTime = data_lastTime.substr(0, 2);

		if (anul < anul_lastTime) {
			lista_numeFisiere->push_back(fisier.path().filename().string());
		}
		else if (anul == anul_lastTime && luna < luna_lastTime) {
			lista_numeFisiere->push_back(fisier.path().filename().string());
		}
		else if (anul == anul_lastTime && luna == luna_lastTime && ziua <= ziua_lastTime) {
			lista_numeFisiere->push_back(fisier.path().filename().string());
		}
	}

	return SUCCEEDED;
}

void CFilesManager::CreateUserFolders(std::string username) {

	std::string path = m_storagePath + username + "/";
	fs::create_directories(path + m_fileDetailsFolderName);
	fs::create_directories(path + m_filesFolderName);
}
bool CFilesManager::checkFileExists(std::string filename, std::string username) {

	std::string path = GetClientFilePath(username);
	path += filename;

	return fs::exists(path.c_str());
}
int CFilesManager::DeleteUserFolders(std::string username) {

	std::string path = m_storagePath + username + "/";
	return fs::remove_all(path);
}

void CFilesManager::WriteInFile(std::string filePath, std::string detailsFilePath, std::string text, std::ios_base::openmode openmode, bool binary) {

	std::ofstream file;
	if (binary)
		file.open(filePath.c_str(), openmode | std::ios::binary);
	else
		file.open(filePath.c_str(), openmode);
	if (!file.is_open())
		throw new Exception_File("WriteInFile function errors... Nu ar trebui sa se intample");

	std::ofstream detailsFile(detailsFilePath.c_str(), openmode);
	if (!detailsFile.is_open())
		throw new Exception_File("WriteInFile function errors... Nu ar trebui sa se intample");


	//retinem pozitia cursorului de start
	long long int pozitie_start, pozitie_end;
	file.seekp(0, file.end);
	pozitie_start = file.tellp();

	if (binary)
		file.write(text.c_str(), text.length());
	else
		file << text;

	//retinem pozitia cursorului de end
	pozitie_end = file.tellp();
	//retinem si nuamrul de '\n' ca sa il luam in calcul cand citim 
	int count = 0;
	for (int i = 0; i < text.length(); i++) {
		if (text[i] == '\n')
			count++;
	}

	detailsFile << pozitie_start << " " << pozitie_end << " " << count << std::endl;

	file.close();
}
std::string CFilesManager::GetFilenameFromPath(std::string path) {

	int poz = path.find_last_of("/") + 1;
	std::string result = path.substr(poz, path.length() - poz);

	return result;
}
struct tm CFilesManager::GetFileLastTimeModified(std::string filename) {

	struct stat result;
	struct tm tminfo;
	time_t ltime;
	if (_stat(filename.c_str(), &result) == 0)
	{
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		auto mod_time = result.st_mtime;
		_localtime64_s(&tminfo, &mod_time);
	}

	return tminfo;
}
std::string CFilesManager::TimeStructureToString(struct tm structureTime) {

	std::string result;
	char timp[10];

	int x = structureTime.tm_mday;
	if (x < 10)
		result = "0";
	_itoa(x, timp, 10);
	result = timp;
	result += "/";

	x = structureTime.tm_mon + 1;
	if (x < 10)
		result += "0";
	_itoa(x, timp, 10);
	result += timp;
	result += "/";

	x = structureTime.tm_year + 1900;
	_itoa(x, timp, 10);
	result += timp;

	return result;
}


std::string CFilesManager::GetClientFileDetailsPath(std::string username) {

	return m_storagePath + username + "/" + m_fileDetailsFolderName + "/";
}


long long int CFilesManager::GetChunkPositions(std::string detailsPath, int chunk, int& lenght, int& number_ofEndOfLine) {

	std::fstream file(detailsPath.c_str(), std::ios::in);
	if (!file.is_open()) {

		return FAILED;
	}

	std::string chunk_details;

	//citim rand pe rand pana ajungem la randul chunkului ce ne intereseaza
	for (int i = 0; i < chunk; i++)
	{
		file >> chunk_details;
		file >> chunk_details;
		file >> chunk_details;
	}

	long long int poz_start;
	file >> chunk_details;
	poz_start = atoi(chunk_details.c_str());
	file >> chunk_details;
	lenght = atoi(chunk_details.c_str()) - poz_start;
	file >> chunk_details;
	number_ofEndOfLine = atoi(chunk_details.c_str());

	return poz_start;
}