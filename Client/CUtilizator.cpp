#include "CUtilizator.h"
#include "IMessage.h"
#include "MACRO_Protocol.h"
#include "MACRO_Client.h"
#include "Exception_Client.h"

#include <conio.h>

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

void CUtilizator::WelcomePrint() {

	std::cout << "Bine ati venit pe platforma DataSentinel!" << std::endl;
	std::cout << "\nApasati:";
	std::cout << "\n\t1. Incarcare fisier";
	std::cout << "\n\t2. Descarcare fisier";
	std::cout << "\n\t3. Vizualizare fisiere";
	std::cout << "\n\t4. Setari cont" << std::endl;
}
void CUtilizator::UploadFile(bool replace) {

	int type = sendFile(m_currentFilepath,m_currentFilename,replace);

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