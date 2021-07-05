#include "CUtilizator.h"
#include "IMessage.h"
#include "MACRO_Protocol.h"
#include "MACRO_Client.h"
#include "Exception_Client.h"
#include "IFilesManager.h"
#include "Protocol.h"

#include <conio.h>
#include <fstream>

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
			AskForUploadFileDetails();
			UploadFile();
			break;
		case '2':
			//descarca fisier
			AskForDownloandFileDetails();
			DownloadFile(m_FilesManager->Get_CurrentFilepath(), m_FilesManager->Get_CurrentFilename());
			break;
		case '3':
			//vizualizeaza fisiere
			AskViewFilesDetails();
			ViewFiles();
			break;
		case '4':
			//setari cont
			SwitchSetariCont();
			break;
		default:
			break;
		}

	} while (true);

}

void CUtilizator::WelcomePrint() {

	std::cout << "Bine ati venit pe platforma DataSentinel!" << std::endl;
	std::cout << "\nApasati:";
	std::cout << "\n\t1. Incarcare fisier";
	std::cout << "\n\t2. Descarcarer fisier";
	std::cout << "\n\t3. Vizualizare fisiere";
	std::cout << "\n\t4. Setari cont" << std::endl;
}
void CUtilizator::UploadFile(bool replace) {

	int type = sendFile(m_FilesManager->Get_CurrentFilepath(), m_FilesManager->Get_CurrentFilename(), replace);

	if (type == PROT_FILE_UPLOAD_RESPONSE_SUCCEDED)
		return;
	if (type == PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST) {

		UpdateUploadFileDetails();
		return;
	}
	if (type == PROT_FILE_UPLOAD_RESPONSE_FAILED || type == PROT_FAILED) {

		system("cls");
		std::cout << "Ceva nu a mers bine... Reincercati!";
		Sleep(3000);
		UploadFile();
	}


	throw new Exception_Client("Aici chair nu ar trebui sa ajunga. Finalul lui UploadFile");
}
void CUtilizator::AskForUploadFileDetails() {

	system("cls");
	std::string temp;
	std::cout << "Cale fisier: ";
	std::cin >> temp;
	m_FilesManager->Set_CurrentFilepath(temp);
	std::cout << "Nume fisier pentru salvare: ";
	std::cin >> temp;
	m_FilesManager->Set_CurrentFilename(temp);
}
void CUtilizator::UpdateUploadFileDetails() {

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

int CUtilizator::DownloadFile(std::string filepath, std::string filename) {

	//!!!!!!! NU UITA SA TRATEZI CAZUL CAND ITI ZICE CA FISIERUL NU EXISTA

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

	std::string pozitie = "0";
	bool fileEnded = false;
	do {

		mess = Factory_Message::Create_Message(PROT_FILE_DOWNLOAND_REQUEST);
		mess->Add(filename);
		mess->Add(pozitie); //asta e pozitia de la care sa citeasca
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
		if (mess->GetType() != PROT_FILE_DOWNLOAND_RESPONSE_SUCCEDED) {

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
		it++;// pozitia la care a ramas
		pozitie = *it;
		it++; //continut mesaj

		if (true != m_FilesManager->WriteInFile(fullname, *it, std::ios::app)) {

			index_errors++;
			if (index_errors == max_errors) {

				return FAILED;
			}
			continue;
		}

	} while (!fileEnded);
	//se primeste pe bucati fisierul si se tot salveaza cu append in fisierul inainte creat
	//asta daca nu apar erori


	//gata
}
void CUtilizator::AskForDownloandFileDetails() {

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

void CUtilizator::ViewFiles() {

	std::list<std::string> list_nameFiles;
	std::string data;
	int ret;

	char option;
	option = _getch();
	switch (option)
	{
	case '1':
		ret = getFiles(PROT_VIEW_FILE_ALL, &list_nameFiles);
		break;
	case '2':
		AskData(&data);
		ret = getFiles(PROT_VIEW_FILE_DAY, &list_nameFiles, data);
		break;
	case '3':
		AskData(&data);
		ret = getFiles(PROT_VIEW_FILE_FROM_DAY_ToPRESENT, &list_nameFiles, data);
		break;
	case '4':
		AskData(&data);
		ret = getFiles(PROT_VIEW_FILE_MONTH, &list_nameFiles, data);
		break;
	default:
		break;
	}

	if (ret == PROT_FAILED) {

		std::cout << "\n Ceva nu a mers bine";
		Sleep(3000);
		return;
	}
	if (ret == PROT_VIEW_FILE_RESPONSE_USERNAME_NoEXIST) {

		std::cout << "\nUsername nu exsita. Dar sunt in suer. De ce se intampla asta ?";
		Sleep(3000);
		return;
	}
	DisplayFilesOnScreen(list_nameFiles);
}
void  CUtilizator::AskViewFilesDetails() {

	system("cls");
	std::cout << "Doriti sa vedeti: \n";
	std::cout << "\t1). Toate fisierele dumneavoastra\n";
	std::cout << "\t2). Fisierele dintr-o anumita zi\n";
	std::cout << "\t3). Fisierele dintr-o anumita zi si pana azi\n";
	std::cout << "\t4). Fisierele dintr-o anumita luna\n";
	std::cout << "\t5). Renunta la operatiune";
}




