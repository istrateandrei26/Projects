#include "pch.h"
#include "CAdmin.h"
#include "Protocol.h"
#include "IMessage.h"

#include <conio.h>

void CAdmin::Run() {

	do {
		system("cls");
		WelcomePrint();

		char option;
		option = _getch();
		switch (option)
		{
		case '1':
			//vizualizeaza lista utilizatori
			break;
		case '2':
			//ceva
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

void CAdmin::WelcomePrint() {

	std::cout << "Bine ati venit pe platforma DataSentinel!" << std::endl;
	std::cout << "\nApasati:";
	std::cout << "\n\t1. Ceva";
	std::cout << "\n\t2. Altceva";
	std::cout << "\n\t3. Vizualizare fisiere";
	std::cout << "\n\t4. Setari cont" << std::endl;
}

int CAdmin::AdminGetUsers(std::list<std::string>* list_users)
{
	IMessage* mess = Factory_Message::Create_Message(PROT_VIEW_USERS_REQUEST);
	mess->Add_EndOfMessage();
	//if (PROT_SUCCEDED != Protocol::checkViewUsersRequest(mess)) {

	//	return PROT_VIEW_USERS_RESPONSE_FAILED;
	//}
	sendRequest(mess);
	mess = receiveResponse();
	*list_users = mess->GetElementsOfMessage();
	list_users->erase(list_users->begin());
	auto it = list_users->end();
	it--;
	list_users->erase(it);
	return PROT_SUCCEDED;
}

void CAdmin::AdminViewUsers()
{
	std::list<std::string> list_users;
	AdminGetUsers(&list_users);

	system("cls");
	std::cout << "Lista cu utilizatori: ";
	for (auto it = list_users.begin(); it != list_users.end(); it++) {

		std::cout << "\n\t" << *it;
	}
	Sleep(3000);
}


void CAdmin::AdminViewFiles()
{
	std::list<std::string> list_nameFiles;
	std::string data;
	std::string username;
	int ret;

	char option;
	option = _getch();

	system("cls");
	std::cout << "Username-ul clientului: ";
	std::cin >> username;

	switch (option)
	{
	case '1':
		ret = getFiles(PROT_VIEW_FILE_ALL, &list_nameFiles, "00/00/0000", &username);
		break;
	case '2':
		AskData(&data);
		ret = getFiles(PROT_VIEW_FILE_DAY, &list_nameFiles, data, &username);
		break;
	case '3':
		AskData(&data);
		ret = getFiles(PROT_VIEW_FILE_FROM_DAY_ToPRESENT, &list_nameFiles, data, &username);
		break;
	case '4':
		AskData(&data);
		ret = getFiles(PROT_VIEW_FILE_MONTH, &list_nameFiles, data, &username);
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

		std::cout << "\nUsername nu exsita";
		Sleep(3000);
		return;
	}
	DisplayFilesOnScreen(list_nameFiles);
}

void CAdmin::AdminAskViewFilesDetails()
{
	system("cls");
	std::cout << "Doriti sa vedeti: \n";
	std::cout << "\t1). Toate fisierele unui client\n";
	std::cout << "\t2). Fisierele dintr-o anumita zi a unui client\n";
	std::cout << "\t3). Fisierele dintr-o anumita zi si pana azi a unui client\n";
	std::cout << "\t4). Fisierele dintr-o anumita luna a unui client\n";
	std::cout << "\t5). Renunta la operatiune";
}

int CAdmin::AdminDeleteUser(std::string username)
{
	IMessage* mess = Factory_Message::Create_Message(PROT_DELETE_USER_REQUEST);
	if (username == "")   // check if admin called this, or a common user wants to delete his own account...
	{
		mess->Add(m_username);
	}
	else
	{
		mess->Add(username);
	}
	mess->Add_EndOfMessage();
	if (PROT_SUCCEDED != Protocol::checkDeleteUserRequest(mess)) {

		return PROT_DELETE_USER_RESPONSE_FAILED;
	}
	sendRequest(mess);
	mess = receiveResponse();
	return mess->GetType();
}

void CAdmin::AdminAskDeleteUserDetails()
{
	std::string username;
	system("cls");
	std::cout << "Sterge utilizator\n\n";
	std::cout << "Username-ul utilizatorului: ";
	std::cin >> username;

	int ret = AdminDeleteUser(username);

	switch (ret)
	{
	case PROT_DELETE_USER_RESPONSE_SUCCEDED:
		std::cout << "\nUtilizator sters cu succes";
		break;
	case PROT_DELETE_USER_RESPONSE_USER_NoEXIST:
		std::cout << "\nUtilizatorul cu acest nume nu exista";
		break;
	case PROT_DELETE_USER_RESPONSE_FAILED:
		std::cout << "\nUtilizatorul nu a putut fi sters";
		break;
	default:
		break;
	}
	char option;
	option = _getch();
}

int CAdmin::AdminPromoteUser(std::string username, int mod)
{
	IMessage* mess = Factory_Message::Create_Message(PROT_PROMOTE_USER_REQUEST);
	mess->Add(username);
	mess->Add(std::to_string(mod));
	mess->Add_EndOfMessage();
	if (PROT_SUCCEDED != Protocol::checkPromoteUserRequest(mess)) {

		return PROT_DELETE_USER_RESPONSE_FAILED;
	}
	sendRequest(mess);
	mess = receiveResponse();
	return mess->GetType();
}

void CAdmin::AdminAskPromoteUserDetails()
{
	std::string username;
	system("cls");
	std::cout << "Sterge utilizator\n\n";
	std::cout << "Username-ul utilizatorului: ";
	std::cin >> username;
	std::cout << "\nTastati:\n\t1).Admin\n\t2).User";

	char option;
	option = _getch();
	int mod = (option == '1') ? PROT_PROMOTE_ADMIN : PROT_PROMOTE_USER;
	int ret = AdminPromoteUser(username, mod);

	switch (ret)
	{
	case PROT_PROMOTE_USER_RESPONSE_SUCCEDED:
		std::cout << "\nUtilizator promovat cu succes";
		break;
	case PROT_PROMOTE_USER_RESPONSE_USER_NoEXIST:
		std::cout << "\nUtilizatorul cu acest nume nu exista";
		break;
	case PROT_PROMOTE_USER_RESPONSE_FAILED:
		std::cout << "\nUtilizatorul nu a putut fi promovat";
		break;
	default:
		break;
	}
	option = _getch();
}

int CAdmin::AdminShutdownServer()
{
	IMessage* mess = Factory_Message::Create_Message(PROT_SHUTDOWN_SERVER_REQUEST);
	mess->Add_EndOfMessage();
	if (PROT_SUCCEDED != Protocol::checkShutdownServerRequest(mess)) {

		return PROT_SHUTDOWN_SERVER_RESPONSE_FAILED;
	}

	sendRequest(mess);
	mess = receiveResponse();
	if (PROT_SUCCEDED != Protocol::checkShutdownServerResponse(mess)) {

		return PROT_SHUTDOWN_SERVER_RESPONSE_FAILED;
	}

	return mess->GetType();   //failed or succeeded;
}

int CAdmin::AdminStartServer()
{
	IMessage* mess = Factory_Message::Create_Message(PROT_START_SERVER_REQUEST);
	mess->Add_EndOfMessage();
	if (PROT_SUCCEDED != Protocol::checkStartServerRequest(mess)) {

		return PROT_START_SERVER_RESPONSE_FAILED;
	}

	sendRequest(mess);
	mess = receiveResponse();
	if (PROT_SUCCEDED != Protocol::checkStartServerResponse(mess)) {

		return PROT_START_SERVER_RESPONSE_FAILED;
	}

	return mess->GetType();   //failed or succeeded;
}

int CAdmin::AdminCheckIfAdmin(std::string username)
{
	IMessage* mess = Factory_Message::Create_Message(PROT_CHECK_ADMIN_REQUEST);
	mess->Add(username);
	mess->Add_EndOfMessage();

	if (PROT_SUCCEDED != Protocol::checkAdminRequest(mess)) {

		return PROT_FAILED;
	}

	sendRequest(mess);
	mess = receiveResponse();

	//response has 2 elements -> TRUE/FALSE+END

	return mess->GetType();   //true/false;

}