#include "pch.h"
#define _CRT_SECURE_NO_WARNINGS
//-----------------------------------
//-------------------------------------
#include "Client.h"
#include "MACRO_Client.h"
#include "IMessage.h"
#include "Protocol.h"
#include "MACRO_Protocol.h"
#include "Exception_Client.h"
#include "Exception_File.h"
#include "ICipherEngine.h"
#include "IFilesManager.h"

#include <conio.h>
#include <stdlib.h>
#include <fstream>
#include <filesystem>



namespace fs = std::filesystem;

Client::Client()
{
	// initializing socket and getting ready , in order to connect to the server
	WSA_Startup();
	Socket_init();
	Sockaddr_init();

	m_FilesManager = Factory_FilesManager::Create_FilesManager();
	m_AES_engine = Cipher_Headquarter::Build_AES_Engine();
	m_RSA_engine = Cipher_Headquarter::Build_RSA_Engine();
}
Client::~Client() {
	closesocket(this->m_ClientSocket);
}

void Client::WSA_Startup()
{
	if (WSAStartup(MAKEWORD(2, 2), &m_ws) < 0)
	{
		std::cout << "[-] WSA failed" << std::endl;
		WSACleanup();
		exit(EXIT_FAILURE);
	}
}
void Client::Socket_init()
{
	m_ClientSocket = socket(TCP_NETWORK, STREAM, TCP_PROTOCOL);

	if (m_ClientSocket == FAILED)
	{
		std::cout << "[-] Socket init error" << std::endl;
		WSACleanup();
		exit(EXIT_FAILURE);
	}
	else
	{
		std::cout << "[+] The socket opened successfully" << std::endl;
	}
}
void Client::Sockaddr_init()
{
	m_server.sin_family = TCP_NETWORK;
	m_server.sin_port = htons(PORT);
	m_server.sin_addr.s_addr = inet_addr("192.168.0.101");  //192.168.0.101
	memset(&m_server.sin_zero, 0, 8);
}

void Client::Connect()
{
	m_result = connect(m_ClientSocket, (struct sockaddr*)&m_server, sizeof(m_server));

	if (m_result < 0)
	{
		std::cout << "[-] Failed to connect to the server" << std::endl;
		WSACleanup();
		exit(EXIT_FAILURE);
	}
	else
	{
		char message[MESS_BUFF] = { 0, };
		recv(m_ClientSocket, message, MESS_BUFF, 0);
		std::cout << "[SERVER response]: ";
		std::cout << message << std::endl << std::endl;
	}
}
std::unique_ptr<IClient> Client::Reconnect(int client_type, std::unique_ptr<IClient>& other) {

	std::unique_ptr<IClient> client;


	switch (client_type)
	{
	case PROT_LOGIN_RESPONSE_ADMIN:
		client = Client_Builder::GetAdmin(other);
		break;
	case PROT_LOGIN_RESPONSE_UTILIZATOR:
		client = Client_Builder::GetUtilizator(other);
		break;
	default:
		break;
	}
	other.reset();
	client->Connect();
	client->TellYourUsernameToServer();





	return client;
}





void Client::TellYourUsernameToServer() {

	IMessage* mess = Factory_Message::Create_Message(PROT_SEND_CLIENT_DATA);
	mess->Add(m_username);
	mess->Add_EndOfMessage();
	if (PROT_SUCCEDED != Protocol::checkSendClientDataMessage(mess)) {
		throw new Exception_Client("Reconnect message nu a mers bine!");
	}
	sendRequest(mess);
	mess = receiveResponse();
	//if (mess->GetType() != PROT_SUCCEDED)
		//this->Reconnect(client_type, client);
}

int Client::Autentificare(char option) {

//        //do {
//
//		system("cls");
//		std::cout << "Tastati:\n";
//		std::cout << "\t1. Logare\n";
//		std::cout << "\t2. Inregistrare\n";
//
////		char option;
////		do {
////                                                                                                            /*how to check option from GUI here ?????*/
////                        option = _getch();
////                } while (option != '1' && option != '2');
//
////		int ret;


		switch (option)
		{
			//logare
		case '1':
		//	return Logare();     // aici am modificat ca sa expun metoda Logare(std::string username, std::string password) in zona publica , ma ajuta la apelul din GUI .
			return 1;
			break;

			//inregistrare
		case '2':
		//	Register();
			return 2;
			break;
		default:
			std::cout << "[-][ERROR] Asta nu ar trebui sa se intample" << std::endl;
			break;
		}



        //} while (true);
}

int Client::sendRequest(IMessage* mess) {

	
	QByteArray message;
	message.append(mess->GetTheMessage());
	QByteArray encrypted = m_AES_engine->encryptAES(HASH, message);
	encrypted= encrypted.toBase64();
	int char_trimise = send(m_ClientSocket, encrypted.data(), MESS_BUFF, 0);
	delete mess;
	if (char_trimise != MESS_BUFF)
		return char_trimise;
	return SUCCEEDED;
}
IMessage* Client::receiveResponse() {

	char message[MESS_BUFF];
	recv(m_ClientSocket, message, strlen(message) + 1, 0);
	QByteArray mess;
	mess.append(message);
	mess = mess.fromBase64(message);
	QByteArray decrypted_message = m_AES_engine->decryptAES(HASH, mess);
	IMessage* response_mess = Factory_Message::Create_Message(decrypted_message.data());
	return response_mess;
}

int Client::Logare(std::string username, std::string password) {

	//bool logat_cu_succes = true;
	//do {
	//	system("cls");
	//	if (logat_cu_succes == false) {

	//		//la prima incercare nu afiseaza asta
	//		std::cout << "Username sau parola gresite... Reincercati.\n\n";
	//	}
	//	logat_cu_succes = false;

		//cerem datele
		/*std::string username;
		std::string password;*/
		/*std::cout << "Introduceti username: ";
		std::cin >> username;
		std::cout << "Introduceti parola: ";
		std::cin >> password;*/

		int ret = GetLoginResponse(username, password);
		/*if (PROT_LOGIN_RESPONSE_FAILED != ret) {
			return ret;
		}*/


		return ret;      // return account type here , so we know if admin has logged in or common user
	/*} while (!logat_cu_succes);*/

	/*return FAILED;*/
}
int Client::GetLoginResponse(std::string username, std::string password) {

	//mesajul asta e distrus la trimitere
	IMessage* mess = Factory_Message::Create_Message(PROT_LOGIN_REQUEST);
	mess->Add(username);
	mess->Add(password);
	mess->Add_EndOfMessage();

	if (PROT_SUCCEDED != Protocol::checkLoginRequest(mess)) {
		return PROT_LOGIN_RESPONSE_FAILED;
	}
	if (sendRequest(mess) != SUCCEEDED)
		return PROT_LOGIN_RESPONSE_FAILED;

	//primeste mesaj
	//acest mesaj va fi sters odata ce este prelucrat in functia de ChooseAccountType
	mess = receiveResponse();
	if (PROT_SUCCEDED != Protocol::checkLoginRespone(mess))
		return PROT_LOGIN_RESPONSE_FAILED;

	m_username = username;
	return ChooseAccountType(mess);
}
int Client::ChooseAccountType(IMessage* mess) {

	std::list<std::string> elements = mess->GetElementsOfMessage();
	//extragem tipul contului din mesaj
	auto account_type = atoi((*elements.begin()).c_str());
	delete mess;
	return account_type;
}



int Client::Register(std::string username, std::string password,std::string email, std::string cod_admin) {

	//bool inregsitrat_cu_succes = true;
	//do {

	//	system("cls");
	//	if (inregsitrat_cu_succes == false) {

	//		//la prima incercare nu afiseaza asta
	//		std::cout << "Username sau email deja folosit... Reincercati.\n\n";
	//	}
	//	inregsitrat_cu_succes = false;

	//	//cerem datele
	//	std::string username;
	//	std::string password;
	//	std::string repeat_password;
	//	std::string email;
	//	std::string cod_admin;
	//	char skip;
	//	std::cout << "Introduceti username: ";
	//	std::cin >> username;
	//	std::cout << "Introduceti parola: ";
	//	std::cin >> password;
	//	std::cout << "Repetati parola: ";
	//	std::cin >> repeat_password;
	//	std::cout << "Introduceti email: ";
	//	std::cin >> email;
	//	std::cout << "(Optional) Introduceti cod admin: ";
	//	std::cin >> cod_admin;


		int ret = GetRegisterResponse(username, password, email, cod_admin);
		if (PROT_REGISTER_RESPONSE_SUCCEDED == ret)
		{
			return ret;
		}
		else
		{
	/*} while (!inregsitrat_cu_succes);*/
			return FAILED;
		}
}
int Client::LogOut()
{
	IMessage* mess = Factory_Message::Create_Message(PROT_LOGOUT_REQUEST);
	mess->Add_EndOfMessage();
	if (PROT_SUCCEDED != Protocol::checkLogoutRequest(mess)) {

		return PROT_LOGOUT_RESPONSE_FAILED;
	}

	sendRequest(mess);
	mess = receiveResponse();
	if (PROT_SUCCEDED != Protocol::checkLogoutResponse(mess)) {

		return PROT_LOGOUT_RESPONSE_FAILED;
	}

	return mess->GetType();   //failed or succeeded;
}
int Client::GetRegisterResponse(std::string username, std::string password, std::string email, std::string admin_cod) {

	//mesajul asta e distrus la trimitere
	IMessage* mess = Factory_Message::Create_Message(PROT_REGISTER_REQUEST);
	mess->Add(username);
	mess->Add(password);
	mess->Add(email);
	if (admin_cod == "")       // add default admin code if user doesn't enter one , in order to obey register protocol number of elements !!
	{
		mess->Add(" ");
	}
	else
	{
		mess->Add(admin_cod);
	}
	mess->Add_EndOfMessage();

	if (PROT_SUCCEDED != Protocol::checkRegisterRequest(mess)) {
		return PROT_REGISTER_RESPONSE_FAILED;
	}
	if (sendRequest(mess) != SUCCEEDED)
		return PROT_REGISTER_RESPONSE_FAILED;

	//primeste mesaj
	mess = receiveResponse();
	if (PROT_SUCCEDED != Protocol::checkRegisterResponse(mess))
		return PROT_REGISTER_RESPONSE_FAILED;

	int type = mess->GetType();
	delete mess;

	return type;
}




int Client::getFiles(int mod, std::list<std::string>* listaFisiere, std::string data, std::string* username) {

	IMessage* mess = Factory_Message::Create_Message(PROT_VIEW_FILES_REQUEST);
	mess->Add(std::to_string(mod));
	mess->Add(data);
	std::string user = (username == NULL) ? "this" : *username;
	mess->Add(user);
	mess->Add_EndOfMessage();

	if (PROT_SUCCEDED != Protocol::checkViewFilesRequest(mess)) {

		return 0; //prot_view_files_failed
	}

	sendRequest(mess);
	//acum urmeaza sa primim mesajul si sa creem lista de fisiere pe baza lui
	mess = receiveResponse();
	if (PROT_SUCCEDED != Protocol::checkViewFilesResponse(mess)) {

		return 0;//prot_view_files_failed
	}

	int type = mess->GetType();
	if (type != PROT_VIEW_FILE_RESPONSE_SUCCEDED)
		return type;

	*listaFisiere = mess->GetElementsOfMessage();

	listaFisiere->erase(listaFisiere->begin());
	auto it = listaFisiere->end();
	it--;
	listaFisiere->erase(it);

	return PROT_SUCCEDED;
}

int Client::GetChangePasswordResponse(std::string newPassword, std::string oldPassword) {

	IMessage* mess = Factory_Message::Create_Message(PROT_CHANGE_PASSWORD_REQUEST);
	mess->Add(m_username);
	mess->Add(newPassword);
	mess->Add(oldPassword);
	mess->Add_EndOfMessage();


	if (PROT_SUCCEDED != Protocol::checkChangePasswordRequest(mess)) {
		return PROT_FAILED;
	}
	

	
	sendRequest(mess);
	mess = receiveResponse();
	if (PROT_SUCCEDED != Protocol::checkChangePasswordResponse(mess)) {
		return PROT_FAILED;
	}
	return mess->GetType();
}

int Client::changePassword(std::string newPassword, std::string oldPassword)
{
	/*bool reincearca;
	std::string newPass, oldPass;

	system("cls");
	std::cout << "Setari cont. Schimbare parola\n\n";
	std::cout << "Parola noua: ";
	std::cin >> newPass;
	std::cout << "Parola veche: ";
	std::cin >> oldPass;*/

	int ret = GetChangePasswordResponse(newPassword, oldPassword);
	/*if (ret == PROT_CHANGE_PASSWORD_RESPONSE_SUCCEDED) {

		std::cout << "Parola schimbata cu succes!";
		Sleep(3000);
		return SUCCEEDED;
	}
	else if (ret == PROT_CHANGE_PASSWORD_RESPONSE_OLD_PASS_WRONG) {

		system("cls");
		std::cout << "Parola veche nu corespunde! Doriti sa reincercati?";
		std::cout << "\t\n 1). Da";
		std::cout << "\t\n 2). Nu";
		reincearca = true;
	}
	else if (ret == PROT_CHANGE_PASSWORD_RESPONSE_FAILED) {

		system("cls");
		std::cout << "Schimbarea parolei a esuat! Doriti sa reincercati?";
		std::cout << "\t\n 1). Da";
		std::cout << "\t\n 2). Nu";
		reincearca = true;
	}*/

	/*if (reincearca) {

		char option;
		option = _getch();
		if (option == '1')
			return GetChangePasswordResponse(newPassword,oldPassword);
		else if (option == '2')
			return FAILED;
	}*/

	return ret; 
}

int Client::changeEmail(std::string newEmail)
{
	//bool reincearca = false;
	////std::string newEmail;

	//system("cls");
	//std::cout << "Setari cont. Schimbare email\n\n";
	//std::cout << "Email nou: ";
	//std::cin >> newEmail;

	int ret = GetChangeEmailResponse(newEmail);
	/*if (ret == PROT_CHANGE_PASSWORD_RESPONSE_SUCCEDED) {

		std::cout << "Email schimbat cu succes!";
		Sleep(3000);
		return SUCCEEDED;
	}
	else if (ret == PROT_CHANGE_PASSWORD_RESPONSE_FAILED) {

		system("cls");
		std::cout << "Schimbarea email-ului a esuat! Doriti sa reincercati?";
		std::cout << "\t\n 1). Da";
		std::cout << "\t\n 2). Nu";
		reincearca = true;
	}

	if (reincearca) {

		char option;
		option = _getch();
		if (option == '1')
			return GetChangeEmailResponse(newEmail);
		else if (option == '2')
			return FAILED;
	}

	return FAILED;*/

	return ret;
}

int Client::GetChangeEmailResponse(std::string newEmail) {

	IMessage* mess = Factory_Message::Create_Message(PROT_CHANGE_EMAIL_REQUEST);
	mess->Add(m_username);
	mess->Add(newEmail);
	mess->Add_EndOfMessage();

	if (PROT_SUCCEDED != Protocol::checkChangeEmailRequest(mess)) {

		return PROT_FAILED;
	}
	sendRequest(mess);
	mess = receiveResponse();
	if (PROT_SUCCEDED != Protocol::checkChangeEmailResponse(mess)) {

		return PROT_FAILED;
	}

	return mess->GetType();
}


void Client::ViewFiles()
{
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




void Client::DisplayFilesOnScreen(std::list<std::string> list_nameFiles) {

	system("cls");
	if (!list_nameFiles.empty()) {
		std::cout << "Fisierele sunt: ";
		for (auto it = list_nameFiles.begin(); it != list_nameFiles.end(); it++) {

			std::cout << "\n\t" << *it;
		}
		std::cout << "\n\n";
	}
	else {

		std::cout << "Nu sunt fisiere care sa corespunda!";
	}
	char option;
	option = _getch();
}
void Client::AskData(std::string* data) {

	std::cout << "\nIntroduceti data sub forma DD/MM/YYYY: ";
	std::cin >> *data;
}








void Client::AskViewFilesDetails() {

	system("cls");
	std::cout << "Doriti sa vedeti: \n";
	std::cout << "\t1). Toate fisierele dumneavoastra\n";
	std::cout << "\t2). Fisierele dintr-o anumita zi\n";
	std::cout << "\t3). Fisierele dintr-o anumita zi si pana azi\n";
	std::cout << "\t4). Fisierele dintr-o anumita luna\n";
	std::cout << "\t5). Renunta la operatiune";
}



