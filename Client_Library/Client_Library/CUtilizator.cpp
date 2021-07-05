#include "pch.h"
#include "CUtilizator.h"
#include "IMessage.h"
#include "MACRO_Protocol.h"
#include "MACRO_Client.h"
#include "Protocol.h"
#include "Exception_Client.h"
#include "IFilesManager.h"


#include <conio.h>
#include <stdlib.h>
#include <fstream>
#include <filesystem>



namespace fs = std::filesystem;

void CUtilizator::Run() {

	do {
		system("cls");
		WelcomePrint();

		char option;
		option = _getch();
		switch (option)
		{
		case '1':
			//incarca fisier
			AskForFileDetails();
			UploadFile();
			break;
		case '2':
			//descarca fisier
			break;
		case '3':
			//vizualizeaza fisiere
			break;
		case '4':
			//setari cont
			break;
		default:
			break;
		}

	} while (true);

}

void CUtilizator::UpdateUploadFileDetails()
{
	system("cls");
	std::string temp;
	std::cout << "Exista deja un fisier cu acelasi nume. Doriti sa il inlocuim?\n";
	std::cout << "1). Inlocuieste\n";
	std::cout << "2). Schimba numele fisierului\n";
	std::cout << "3). Renunta la operatie\n";
	char option;
	option = _getch();
	do {
		switch (option)
		{
		case '1':
			UploadFile(true);
			break;
		case '2':
			std::cout << "Nume nou: ";
			//m_currentFilename.erase();
			std::cin >> temp;
			m_FilesManager->Set_CurrentFilename(temp);
			UploadFile(false);
			break;
		case '3':
			return;
			break;
		default:
			break;
		}

	} while (option < '1' || option > '3');

}
void CUtilizator::AskForUploadFileDetails()
{
	system("cls");
	std::string temp;
	std::cout << "Cale fisier: ";
	std::cin >> temp;
	m_FilesManager->Set_CurrentFilepath(temp);
	std::cout << "Nume fisier pentru salvare: ";
	std::cin >> temp;
	m_FilesManager->Set_CurrentFilename(temp);
}


void CUtilizator::WelcomePrint() {

	std::cout << "Bine ati venit pe platforma DataSentinel!" << std::endl;
	std::cout << "\nApasati:";
	std::cout << "\n\t1. Incarcare fisier";
	std::cout << "\n\t2. Descarcare fisier";
	std::cout << "\n\t3. Vizualizare fisiere";
	std::cout << "\n\t4. Setari cont" << std::endl;
}
void CUtilizator::UploadFile(bool replace) {

	int type = sendFile(m_currentFilepath, m_currentFilename, replace);

	if (type == PROT_FILE_UPLOAD_RESPONSE_SUCCEDED)
		return;
	if (type == PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST) {

		UpdateFileDetails();
		return;
	}
	if (type == PROT_FILE_UPLOAD_RESPONSE_FAILED) {

		system("cls");
		std::cout << "Ceva nu a mers bine... Reincercati!";
		Sleep(3000);
		UploadFile();
	}

	throw new Exception_Client("Aici nu ar trebui sa ajunga. Finalul lui UploadFile");
}
void CUtilizator::AskForFileDetails() {

	system("cls");
	std::cout << "Cale fisier: ";
	std::cin >> m_currentFilepath;
	std::cout << "Nume fisier pentru salvare: ";
	std::cin >> m_currentFilename;
}
void CUtilizator::UpdateFileDetails() {

	system("cls");
	std::cout << "Exista deja un fisier cu acelasi nume. Doriti sa il inlocuim?\n";
	std::cout << "1). Inlocuieste\n";
	std::cout << "2). Schimba numele fisierului\n";
	std::cout << "3). Renunta la operatie\n";
	char option;
	option = _getch();
	do {
		switch (option)
		{
		case '1':
			UploadFile(true);
			break;
		case '2':
			std::cout << "Nume nou: ";
			m_currentFilename.erase();
			std::cin >> m_currentFilename;
			UploadFile(false);
			break;
		case '3':
			return;
			break;
		default:
			break;
		}

	} while (option < '1' || option > '3');

}

int CUtilizator::sendFile(std::string filePath, std::string destinationName, bool replace) {

	if (!fs::exists(filePath)) {

		return FAILED;
	}

	std::ifstream file(filePath.c_str());

	file.seekg(0, file.end);
	long long int lenght = file.tellg();
	file.seekg(0, file.beg);

	std::string string_chunk;
	char chunk_ofFile[CHUNK_OF_FILE];

	int index_chunks = 0;
	int number_ofChunks = lenght / CHUNK_OF_FILE + 1;


	if (number_ofChunks == 1) {

		//e un singur chunk
		//deci tre sa punem terminatorul de sir bine
		file.read(chunk_ofFile, lenght);
		chunk_ofFile[lenght] = '\0';
		string_chunk = chunk_ofFile;
	}
	else if (number_ofChunks > 1) {

		//terminator de sir doar la final de tot
		file.read(chunk_ofFile, CHUNK_OF_FILE - 1);
		chunk_ofFile[CHUNK_OF_FILE - 1] = '\0';
		string_chunk = chunk_ofFile;
	}
	index_chunks++;
	//compunem mesaj cu tipul SendFile_New/Replace_nume_continut_END
	int mod = (replace == true) ? PROT_FILE_REPLACE : PROT_FILE_NEW;
	IMessage* mess = Factory_Message::Create_Message(PROT_FILE_UPLOAD_REQUEST);
	mess->Add(std::to_string(mod));
	mess->Add(destinationName);
	mess->Add(string_chunk);
	mess->Add_EndOfMessage();
	//trimitem 
	if (Protocol::chekUploadFileMessage(mess) != PROT_SUCCEDED)
	{
		file.close();
		return PROT_FAILED;
	}
	sendRequest(mess);

	mess = receiveResponse();
	int option = mess->GetType();
	switch (option)
	{
	case PROT_FILE_UPLOAD_RESPONSE_SUCCEDED:
		//continuam sa trimitem restul fisierului
		break;
	case PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST:
		// nu se creeaza niciun fisier la destinatie;
		// trebuie sa schimbi numele fisierului si sa reincerci
		file.close();
		return PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST;
	case PROT_FILE_UPLOAD_RESPONSE_FAILED:
		//poate putem aici sa mai reincercam de vreo 3 ori ianinte sa dam return
		//ceva nu a mers bine -> reincearca
		file.close();
		return PROT_FILE_UPLOAD_RESPONSE_FAILED;
	default:
		break;
	}

	//trimitem restul chunkurilor de fisier
	//pe ultimul il tratam diferit ca trebuie sa fim atenti al terminatorul de sir 
	delete mess;
	for (int i = index_chunks; i < number_ofChunks; i++) {

		string_chunk.erase();
		if (index_chunks == number_ofChunks - 1) {

			//file.seekg(i * CHUNK_OF_FILE, file.beg);
			int current_poz = file.tellg();
			file.seekg(0, file.end);
			lenght = file.tellg();
			lenght = lenght - current_poz;
			file.seekg(current_poz, file.beg);


			char last_chunk_of_file[CHUNK_OF_FILE];
			file.read(last_chunk_of_file, lenght);
			last_chunk_of_file[lenght] = '\0';
			string_chunk = last_chunk_of_file;

			int count = 0;
			for (int i = 0; i < string_chunk.length(); i++)
				if (string_chunk[i] == '\n')
					count++;

			lenght -= count;
			last_chunk_of_file[lenght] = '\0';
			string_chunk = last_chunk_of_file;
		}
		else {

			//file.seekg(i * CHUNK_OF_FILE, file.beg);
			file.read(chunk_ofFile, CHUNK_OF_FILE - 1);
			chunk_ofFile[CHUNK_OF_FILE - 1] = '\0';
			string_chunk = chunk_ofFile;
		}

		//compunem mesaj cu tipul SendFile_New_nume_continut_END
		mess = Factory_Message::Create_Message(PROT_FILE_UPLOAD_REQUEST);
		mess->Add(std::to_string(PROT_FILE_APPEND));
		mess->Add(destinationName);
		mess->Add(string_chunk);
		mess->Add_EndOfMessage();
		//trimitem 
		if (Protocol::chekUploadFileMessage(mess) != PROT_SUCCEDED)
		{
			file.close();
			return PROT_FAILED;
		}
		int ret = sendRequest(mess);
		if (ret != SUCCEEDED) {
			//aici ar trebui sa vad cate s-au trimis si sa le trimit pe restu
			//momentan sa vedem daca intram vreodata aici
			file.close();
			throw new Exception_Client("Nu s-a trimis tot continutul din chunkul fisierului");
		}

		mess = receiveResponse();
		if (mess->GetType() != PROT_FILE_UPLOAD_RESPONSE_SUCCEDED) {
			//aici ar trebui sa retrimitem partea de mesaj
			//momentan sa vedem daca intram vreodata aici
			file.close();
			throw new Exception_Client("FISIERUL nu a fost bine procesat de server. (in sendFile)");
		}
		delete mess;

		index_chunks++;
	}

	file.close();
	return PROT_FILE_UPLOAD_RESPONSE_SUCCEDED;
}



void CUtilizator::AskForDownloandFileDetails()
{
	system("cls");
	std::string temp;
	std::cout << "Descarcare fisier\n\n";
	std::cout << "Introduceti numele fisierului dorit: ";
	std::cin >> temp;
	m_FilesManager->Set_CurrentFilename(temp);
	std::cout << "Unde doriti sa il salvati ? (cale completa): ";
	std::cin >> temp;
	m_FilesManager->Set_CurrentFilepath(temp);
}

int CUtilizator::DownloadFile(std::string filepath, std::string filename) {


	//se verifica daca filepath e valabil
		//! se creeaa directoare si subdirectoare
		//! daca e vlabil se creeaza si fisierul
		//! daca fisierul exista se va adauag (1) - ca la copii

	if (m_FilesManager->PreparePath(filepath) != true) {

		return FAILED;
	}
	std::string fullname = m_FilesManager->PrepareFilename(filepath, filename);

	int max_errors = 5;
	int index_errors = 0;
	IMessage* mess = nullptr;

	int chunk = 0;
	bool fileEnded = false;
	do {

		mess = Factory_Message::Create_Message(PROT_FILE_DOWNLOAND_REQUEST);
		mess->Add(filename);
		mess->Add(std::to_string(chunk)); //asta e pozitia de la care sa citeasca
		mess->Add_EndOfMessage();
		if (PROT_SUCCEDED != Protocol::checkDownloandFileRequest(mess)) {

			return FAILED;
		}
		sendRequest(mess);

		mess = receiveResponse();
		if (PROT_SUCCEDED != Protocol::checkDownloandFileResponse(mess)) {

			index_errors++;
			if (index_errors == max_errors) {

				return FAILED;
			}
			continue;
		}

		int ret = mess->GetType();
		if (ret != PROT_FILE_DOWNLOAND_RESPONSE_SUCCEDED) {

			if (ret == PROT_FILE_DOWNLOAND_RESPONE_NoEXIST) {

				return ret;
			}

			index_errors++;
			if (index_errors == max_errors) {

				return FAILED;
			}
			continue;
		}
		std::list<std::string> elements = mess->GetElementsOfMessage();
		delete mess; //a facut ce am vrut cu el. Ii dam delete sa il refolosim mai jos
		auto it = elements.begin();
		it++; // END/ NO END
		fileEnded = (*it == std::to_string(PROT_FILE_END)) ? true : false;
		it++;// chunkul pe care l-a citit
		it++; //continut mesaj

		if (true != m_FilesManager->WriteInFile(fullname, *it, std::ios::app)) {

			index_errors++;
			if (index_errors == max_errors) {

				return FAILED;
			}
			continue;
		}

		chunk++;
		index_errors = 0;

	} while (!fileEnded);
	//se primeste pe bucati fisierul si se tot salveaza cu append in fisierul inainte creat
	//asta daca nu apar erori


	//gata
}

IMessage* CUtilizator::ComposeMessageToSendBinaryFile(int mod, std::string destinationName, std::string text) {

	IMessage* mess = Factory_Message::Create_Message(PROT_BINARY_FILE_UPLOAD_REQUEST);
	mess->Add(std::to_string(mod));
	mess->Add(destinationName);
	mess->Add(text);
	mess->Add_EndOfMessage();

	return mess;
}


int CUtilizator::sendBinaryFile(std::string filePath, std::string destinationName, bool replace) {

	if (!fs::exists(filePath)) {

		return FAILED;
	}

	std::ifstream file(filePath.c_str(), std::ios::in | std::ios_base::binary);
	char chunk_ofFile[CHUNK_OF_FILE + 1];

	file.read(chunk_ofFile, sizeof(chunk_ofFile) - 1);
	//if (file.eof()) {



	int y = file.gcount();
	chunk_ofFile[y] = '\0';
	//}
	//chunk_ofFile[CHUNK_OF_FILE] = '\0';
	//compunem mesaj cu tipul SendFile_New/Replace_nume_continut_END
	int mod = (replace == true) ? PROT_FILE_REPLACE : PROT_FILE_NEW;
	IMessage* mess = ComposeMessageToSendBinaryFile(mod, destinationName, chunk_ofFile);
	if (Protocol::chekUploadFileMessage(mess) != PROT_SUCCEDED)
	{
		file.close();
		return PROT_FAILED;
	}
	sendRequest(mess);


	mess = receiveResponse();
	int option = mess->GetType();
	delete mess;
	switch (option)
	{
	case PROT_FILE_UPLOAD_RESPONSE_SUCCEDED:
		//continuam sa trimitem restul fisierului
		break;
	case PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST:
		// nu se creeaza niciun fisier la destinatie;
		// trebuie sa schimbi numele fisierului si sa reincerci
		file.close();
		return PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST;
	case PROT_FILE_UPLOAD_RESPONSE_FAILED:
		//poate putem aici sa mai reincercam de vreo 3 ori ianinte sa dam return
		//ceva nu a mers bine -> reincearca
		file.close();
		return PROT_FILE_UPLOAD_RESPONSE_FAILED;
	default:
		break;
	}

	if (file.eof())
	{
		file.close();
		return PROT_FILE_UPLOAD_RESPONSE_SUCCEDED;
	}

	while (file.read(chunk_ofFile, sizeof(chunk_ofFile) - 1)) {

		chunk_ofFile[CHUNK_OF_FILE] = '\0';
		mess = ComposeMessageToSendBinaryFile(PROT_FILE_APPEND, destinationName, chunk_ofFile);
		if (Protocol::chekUploadFileMessage(mess) != PROT_SUCCEDED)
		{
			file.close();
			return PROT_FAILED;
		}
		int ret = sendRequest(mess);
		if (ret != SUCCEEDED) {
			//aici ar trebui sa vad cate s-au trimis si sa le trimit pe restu
			//momentan sa vedem daca intram vreodata aici
			file.close();
			throw new Exception_Client("Nu s-a trimis tot continutul din chunkul fisierului");
		}

		mess = receiveResponse();
		if (mess->GetType() != PROT_FILE_UPLOAD_RESPONSE_SUCCEDED) {
			//aici ar trebui sa retrimitem partea de mesaj
			//momentan sa vedem daca intram vreodata aici
			file.close();
			throw new Exception_Client("FISIERUL nu a fost bine procesat de server. (in sendFile)");
		}
		delete mess;
	}

	//pentru ultimul chunk
	int x = file.gcount();
	if (x == 0)
	{
		file.close();
		return PROT_FILE_UPLOAD_RESPONSE_SUCCEDED;
	}
	chunk_ofFile[x] = '\0';
	mess = ComposeMessageToSendBinaryFile(PROT_FILE_APPEND, destinationName, chunk_ofFile);
	if (Protocol::chekUploadFileMessage(mess) != PROT_SUCCEDED)
	{
		file.close();
		return PROT_FAILED;
	}
	sendRequest(mess);
	mess = receiveResponse();
	if (mess->GetType() != PROT_FILE_UPLOAD_RESPONSE_SUCCEDED) {
		//aici ar trebui sa retrimitem partea de mesaj
		//momentan sa vedem daca intram vreodata aici
		file.close();
		throw new Exception_Client("FISIERUL nu a fost bine procesat de server. (in sendFile)");
	}
	delete mess;

	file.close();
	return PROT_FILE_UPLOAD_RESPONSE_SUCCEDED;
}
