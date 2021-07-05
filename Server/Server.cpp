#include "Server.h"
#include "MACRO_Server.h"
#include "Protocol.h"
#include "IMessage.h"
#include "iLoginManager.h"
#include "ClientData.h"
#include "IFilesManager.h"
//#include "ICipherEngine.h"
#include "Exception_Server.h"
#include "MACRO_Protocol.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qstring.h>
#include <QtCore/qalgorithms.h>

#include <fstream>
#include <filesystem>
namespace fs = std::filesystem;

std::unique_ptr<Server> Server::instance = nullptr;

Server::Server()
{
	FD_ZERO(&fr);
	FD_ZERO(&fw);
	FD_ZERO(&fe);
	max_fd = 0;
	server.sin_port = PORT;
	server_socket = 0;
	ws.iMaxSockets = 1;

	m_adminCod = "admin";
	m_FilesManager = Factory_FilesManager::Create_FilesManager();
	m_LoginManager = Factory_LoginManager::Create_LoginManager("SQL Server", "localhost", "1434", "LoginManager");

	m_AES_engine = Cipher_Headquarter::Build_AES_Engine();
	m_RSA_engine = Cipher_Headquarter::Build_RSA_Engine();

	m_private_RSA_key = m_RSA_engine->getPrivateKey(m_FilesManager->GetPivateKeyFilePath().c_str());
	m_public_RSA_key = m_RSA_engine->getPublicKey(m_FilesManager->GetPublicKeyFilePath().c_str());

}
IServer& Server::Get_Instance()
{
	if (instance == nullptr)
	{
		std::cout << "[+] Creating server instance" << std::endl;
		instance.reset(new Server);
	}

	return *instance;
}
IServer& Server_Headquarter::Build()
{
	return Server::Get_Instance();
}
void Server_Headquarter::destroyInstance()
{
	return Server::Destroy_Instance();
}
void Server::Destroy_Instance()
{
	if (instance != nullptr)
	{
		std::cout << "[+] Destroying server instance" << std::endl;
		instance.reset(nullptr);
	}

}

/********************************************************/
void Server::WSA_Startup()
{
	if (WSAStartup(MAKEWORD(2, 2), &ws) < 0)
	{
		std::cout << "[-] WSA failed" << std::endl;
		WSACleanup();
		exit(EXIT_FAILURE);
	}
	else
	{
		std::cout << "[+] WSA initialized" << std::endl;
	}
}
void Server::Socket_init()
{
	server_socket = socket(TCP_NETWORK, STREAM, TCP_PROTOCOL);
	if (server_socket < 0)
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
void Server::Sockaddr_init()
{
	server.sin_family = TCP_NETWORK;
	server.sin_port = htons(PORT);
	server.sin_addr.s_addr = inet_addr("192.168.0.101");  //192.168.0.101
	memset(&(server.sin_zero), 0, 8);


	//initializing socket specs
}
void Server::Socket_option()
{
	int option_val = 0;
	int option_length = sizeof(option_val);
	result = setsockopt(server_socket, SOCKET_OPTIONS, ALLOW_LOCAL_ADDRESS_REUSE, (const char*)&option_val, option_length);
	if (result == SUCCEEDED)
	{
		std::cout << "[+] Socket option call successful" << std::endl;

	}
	else
	{
		std::cout << "[-] Socket option call failed" << std::endl;
		WSACleanup();
		exit(EXIT_FAILURE);
	}

	//implicitly blocking socket => multi-threaded
}
void Server::Bind()
{
	result = ::bind(server_socket, (sockaddr*)&server, sizeof(sockaddr));
	if (result < 0)
	{
		std::cout << "[-] Failed to bind to local port" << std::endl;
		WSACleanup();
		exit(EXIT_FAILURE);
	}
	{
		std::cout << "[+] Successfully bind to local port" << std::endl;
	}
}
void Server::Listen()
{
	result = listen(server_socket, MAXIMUM_NUMBER_OF_QUEUED_CONNECTIONS_REQUESTS);
	if (result < 0)
	{
		std::cout << "[-] Failed to start listening to local port" << std::endl;
		WSACleanup();
		exit(EXIT_FAILURE);
	}
	else
	{
		std::cout << "[+] Started listening to local port" << std::endl;
	}
}
void Server::Prepare_ground()
{
	max_fd = server_socket;
}
char* Server::GetIPaddr(SOCKET s, int& err, bool port)
{
	sockaddr_in SockAddr;
	int addrlen = sizeof(SockAddr);

	if (getsockname(s, (LPSOCKADDR)&SockAddr, &addrlen) == SOCKET_ERROR)
	{
		err = WSAGetLastError();
		return NULL;
	}

	if (port)
	{
		char* portstr = new char[6];
		//portstr=Num2Str(SockAddr.sin_port);

		return portstr;
	}

	char* ipstr = new char[16];

	strcpy(ipstr, inet_ntoa(SockAddr.sin_addr));

	return ipstr;
}
std::string Server::GetClientUsername(int client_socket) {

	std::string result;
	for (auto it = m_clientsDetails.begin(); it != m_clientsDetails.end(); it++) {

		if (it->sock == client_socket)
		{
			result = (it->username);
			break;
		}
	}

	return result;
}


void Server::Start_Server_Working()
{
	WSA_Startup();
	Socket_init();
	Sockaddr_init();
	Socket_option();
	Bind();
	Listen();
	Prepare_ground();

	Work();// infinite loop
}
/********************************************************/


void Server::Work()
{
	struct timeval tv;
	tv.tv_sec = 1;
	tv.tv_usec = 0;



	while (true)
	{
		FD_ZERO(&fr);
		FD_ZERO(&fw);
		FD_ZERO(&fe);

		FD_SET(server_socket, &fr);
		FD_SET(server_socket, &fe);

		for (int i = 0; i < clients.size(); i++)
		{
			if (clients[i] != 0)
			{
				FD_SET(clients[i], &fr);
				FD_SET(clients[i], &fe);
			}
		}

		result = select(max_fd + 1, &fr, &fw, &fe, &tv);
		if (result > 0)
		{
			// when someone connects or communicates
			std::cout << "Data on port... Processing now..." << std::endl;


			//if (FD_ISSET(server_socket, &fr))
			Process_The_New_Request();


			/*if (FD_ISSET(server_socket, &fe))
				std::cout << "[-] There is an exception" << std::endl;

			if (FD_ISSET(server_socket, &fw))
				std::cout << " Ready to write something " << std::endl;*/
				//break;

		}
		else if (result == 0)
		{
			//no communication
			//std::cout << "Nothing on port" << std::endl;
		}
		else
		{
			std::cout << "\n\n AM INTRAT PE RAMURA ASTA ULTIMA \n\n";
			WSACleanup();
			exit(EXIT_FAILURE);
		}


	}
}
void Server::Process_The_New_Request()
{
	if (FD_ISSET(server_socket, &fr))
	{
		int cl_length = sizeof(struct sockaddr);
		int new_client_socket = accept(server_socket, NULL, &cl_length);
		if (new_client_socket > 0)
		{
			//put it into the clients pool 
			clients.push_back(new_client_socket);
			std::string buffer = "Got the connection done";
			send(new_client_socket, buffer.c_str(), buffer.size(), 0);
		}
	}
	else
	{
		for (int i = 0; i < clients.size(); i++)
		{
			if (FD_ISSET(clients[i], &fr))
			{
				//got new message from the client
				ProcessNewMessageFromClient(clients[i]);
			}
		}
	}
}
void Server::ProcessNewMessageFromClient(int client_socket)
{
	std::cout << "[+] Processing the new message from client" << std::endl;
	char buffer_to_be_received[MESS_BUFF];
	int status = recv(client_socket, buffer_to_be_received, strlen(buffer_to_be_received) + 1, 0);
	if (status <= 0)
	{
		// close connection 
		std::cout << "[-] A client closed connection..." << std::endl;
		closesocket(client_socket);
		DeleteFrom_ClientDetails(client_socket);
		for (int i = 0; i < clients.size(); i++)
		{
			if (clients[i] == client_socket)
			{
				clients[i] = 0;
				break;
			}
		}
	}
	else
	{
		IMessage* mess = DecapsulateMessage(buffer_to_be_received);
		if (!server_on && mess->GetType() != PROT_START_SERVER_REQUEST && mess->GetType() != PROT_SHUTDOWN_SERVER_REQUEST)
		{
			sendResponse(FAILED, client_socket);
			goto Jumped_Switch_Function;
		}
		
		SwitchFunction(mess, client_socket);

		Jumped_Switch_Function:
		delete mess;
	}

}

int Server::Login(IMessage* mess, int client_socket) {

	if (PROT_SUCCEDED != Protocol::checkLoginRequest(mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}

	//preia datele de logare din mesaj
	std::string username;
	std::string password;
	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;
	username = *it;
	it++;
	password = *it;

	//trimite mesaj in functie de caz
	IMessage* response_mess = nullptr;

	//encrypt password
	/*QByteArray info;
	info.append(password);
	QByteArray encrypted_password = m_AES_engine->encryptAES(HASH, info);
	encrypted_password = encrypted_password.toBase64();*/
	QByteArray info;
	info.append(password);
	QByteArray encrypted_password = m_RSA_engine->encryptRSA(m_public_RSA_key, info);
	encrypted_password = encrypted_password.toBase64();


	int option = m_LoginManager->Login(username, encrypted_password.data());
	switch (option)
	{
	case LoginManager_SUCCES_Admin:
		response_mess = CreateMessage(PROT_LOGIN_RESPONSE_ADMIN);
		break;
	case LoginManager_SUCCES_Utilizator:
		response_mess = CreateMessage(PROT_LOGIN_RESPONSE_UTILIZATOR);
		break;
	case LoginManager_Login_UsernameOrPassword_Wrong:
		response_mess = CreateMessage(PROT_LOGIN_RESPONSE_FAILED);
		break;
	default:
		//aruncam eroare
		break;
	}
	response_mess->Add_EndOfMessage();

	if (PROT_SUCCEDED != Protocol::checkLoginRespone(response_mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}
	sendMessage(response_mess, client_socket);

	return SUCCEEDED;
}
int Server::Register(IMessage* mess, int client_socket) {

	if (PROT_SUCCEDED != Protocol::checkRegisterRequest(mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}

	//preia datele de logare din mesaj
	std::string username;
	std::string password;
	std::string email;
	bool admin_cod = false;

	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;
	username = *it;
	it++;
	password = *it;
	it++;
	email = *it;
	it++;
	if (*it == m_adminCod)
		admin_cod = true;

	/*QByteArray info;
	info.append(password);
	QByteArray encrypted_password = m_AES_engine->encryptAES(HASH, info);
	encrypted_password = encrypted_password.toBase64();*/

	QByteArray info;
	info.append(password);
	QByteArray encrypted_password = m_RSA_engine->encryptRSA(m_public_RSA_key, info);
	encrypted_password = encrypted_password.toBase64();

	if (LoginManager_SUCCES != m_LoginManager->Register(username, encrypted_password.data(), email, admin_cod)) {

		sendResponse(PROT_REGISTER_RESPONSE_FAILED, client_socket);
	}
	else {
		sendResponse(PROT_REGISTER_RESPONSE_SUCCEDED, client_socket);
		m_FilesManager->CreateUserFolders(username);
	}

	return SUCCEEDED;
}
void Server::SaveClientData(IMessage* mess, int client_socket) {

	if (PROT_SUCCEDED != Protocol::checkSendClientDataMessage(mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return;
	}
	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;
	std::string username = *it;
	AddTo_ClientDetails(client_socket, username);

	sendResponse(PROT_SUCCEDED, client_socket);

}
int Server::UploadFileToServer(IMessage* mess, int client_socket, bool binary) {

	if (PROT_SUCCEDED != Protocol::chekUploadFileMessage(mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}

	std::string username = GetClientUsername(client_socket);
	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;
	int option = atoi(it->c_str());


	// ULPOAD_FILE + REPLACE/NU REPLACE + continut
	int type;
	switch (option)
	{
	case PROT_FILE_NEW:
		//verific existenta fisier cu acelasi nume
		//daca nu exista -> creem si stocam acolo si trimitem mesaj sa zicem ca e ok
		//daca exista deja -> trimitem mesaj sa anuntam ca exista
		type = m_FilesManager->Proceseaza_NewFile(mess, username, binary);
		sendResponse(type, client_socket);
		return SUCCEEDED;

	case PROT_FILE_REPLACE:
		//nu ne mai apsa daca exista
		//creem/rescriem fisier
		type = m_FilesManager->Proceseaza_ReplaceFile(mess, username, binary);
		sendResponse(type, client_socket);
		return SUCCEEDED;

	case PROT_FILE_APPEND:
		//veriricam daca exista fisier
		//daca exista -> append
		//daca nu exista -> anuntam ca nu exista ? sau creem? inca nu stiu sigur
		//teoretic nu ar trebui niciodata sa se intample sa nu existe!!
		//pentru ca aici se ajunge doar daca n se trece de partea de creere
		type = m_FilesManager->Proceseaza_AppendFile(mess, username, binary);
		sendResponse(type, client_socket);
		return SUCCEEDED;
	default:
		break;
	}


	//sendResponse(PROT_FILE_UPLOAD_RESPONSE_SUCCEDED, client_socket);

	return SUCCEEDED;
}
int Server::DownloandFileFromServer(IMessage* mess, int client_socket) {


	//Prima data verificam ca fisierul dorit sa existe pe server
	std::string username = GetClientUsername(client_socket);


	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;
	std::string filename = *it;
	if (m_FilesManager->checkFileExists(filename, username) != true) {


		sendResponse(PROT_FILE_DOWNLOAND_RESPONE_NoEXIST, client_socket);
		return SUCCEEDED;
	}
	std::string filePath = m_FilesManager->GetClientFilePath(username) + filename;
	std::string detailsPath = m_FilesManager->GetClientFileDetailsPath(username) + filename;



	it++; //trecem la numarul chunkului
	int chunk = atoi(it->c_str());
	int fileEnded;
	std::string string_chunk = m_FilesManager->ReadFromFile(filePath, detailsPath, chunk, &fileEnded);
	fileEnded = (fileEnded == true) ? PROT_FILE_END : PROT_FILE_NO_END;



	//creeaza mesaj
	//ai deja si continutul
	//si trimite-l
	IMessage* mess_response = Factory_Message::Create_Message(PROT_FILE_DOWNLOAND_RESPONSE_SUCCEDED);
	mess_response->Add(std::to_string(fileEnded));
	mess_response->Add(std::to_string(chunk));
	mess_response->Add(string_chunk);
	mess_response->Add_EndOfMessage();



	if (PROT_SUCCEDED != Protocol::checkDownloandFileResponse(mess_response)) {



		sendResponse(PROT_FILE_DOWNLOAND_RESPONE_NoEXIST, client_socket);
		return FAILED;
	}
	sendMessage(mess_response, client_socket);



	return SUCCEEDED;
}

int Server::LogOut(IMessage* mess, int client_socket)
{
	if (PROT_SUCCEDED != Protocol::checkLogoutRequest(mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}

	DeleteFrom_ClientDetails(client_socket); // delete from logged in users
	sendResponse(PROT_LOGOUT_RESPONSE_SUCCEDED, client_socket);

	return SUCCEEDED;

}

int Server::StartServer(IMessage* mess, int client_socket)
{
	if (PROT_SUCCEDED != Protocol::checkStartServerRequest(mess))
	{
		sendResponse(PROT_START_SERVER_RESPONSE_FAILED, client_socket);
		return FAILED;
	}

	if (server_on)
	{
		sendResponse(PROT_START_SERVER_RESPONSE_FAILED, client_socket);
		return SUCCEEDED;
	}

	server_on = true;   // switch server on !
	sendResponse(PROT_START_SERVER_RESPONSE_SUCCEDED, client_socket);

	return SUCCEEDED;
}

int Server::ShutdownServer(IMessage* mess, int client_socket)
{
	if (PROT_SUCCEDED != Protocol::checkShutdownServerRequest(mess))
	{
		sendResponse(PROT_SHUTDOWN_SERVER_RESPONSE_FAILED, client_socket);
		return FAILED;
	}

	if (!server_on)
	{
		sendResponse(PROT_SHUTDOWN_SERVER_RESPONSE_FAILED, client_socket);
		return SUCCEEDED;
	}

	server_on = false;   // switch server off!
	sendResponse(PROT_SHUTDOWN_SERVER_RESPONSE_SUCCEDED, client_socket);

	return SUCCEEDED;
}

int Server::ShowFilesFromServer(IMessage* mess, int client_socket) {

	if (PROT_SUCCEDED != Protocol::checkViewFilesRequest(mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}

	std::list<std::string> elements = mess->GetElementsOfMessage();

	auto it = elements.end();
	it--;
	it--; //aujungem la username
	std::string username = (*it == "this") ? GetClientUsername(client_socket) : *it;

	//verificam dca exista acel username
	if (checkUsername(username) == false) {

		sendResponse(PROT_VIEW_FILE_RESPONSE_USERNAME_NoEXIST, client_socket);
		return FAILED;
	}

	it--;
	std::string data = *it;
	it--;
	int mod = atoi(it->c_str());

	std::list<std::string> list_numeFisieere;

	//in functie de ce fisiere doreste sa vada, se preiau anumite fisisere din storage
	switch (mod)
	{
	case PROT_VIEW_FILE_ALL:
		if (SUCCEEDED != m_FilesManager->ShowAllFiles(username, &list_numeFisieere)) {

			sendResponse(PROT_FAILED, client_socket);
			return FAILED;
		}
		break;
	case PROT_VIEW_FILE_MONTH:
		if (SUCCEEDED != m_FilesManager->ShowFilesFromMonth(username, &list_numeFisieere, data)) {

			sendResponse(PROT_FAILED, client_socket);
			return FAILED;
		}
		break;
	case PROT_VIEW_FILE_DAY:
		if (SUCCEEDED != m_FilesManager->ShowFilesFromDay(username, &list_numeFisieere, data)) {

			sendResponse(PROT_FAILED, client_socket);
			return FAILED;
		}
		break;
	case PROT_VIEW_FILE_FROM_DAY_ToPRESENT:
		if (SUCCEEDED != m_FilesManager->ShowFilesFromDayToPresent(username, &list_numeFisieere, data)) {

			sendResponse(PROT_FAILED, client_socket);
			return FAILED;
		}
		break;
	default:
		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
		break;
	}


	IMessage* mess_response = Factory_Message::Create_Message(PROT_VIEW_FILE_RESPONSE_SUCCEDED);
	for (auto it = list_numeFisieere.begin(); it != list_numeFisieere.end(); it++) {

		mess_response->Add(*it);
	}
	mess_response->Add_EndOfMessage();
	if (Protocol::checkViewFilesResponse(mess_response) != PROT_SUCCEDED) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}

	sendMessage(mess_response, client_socket);

	return SUCCEEDED;
}
int Server::ChangePassword(IMessage* mess, int client_socket) {

	std::string username, newPass, oldPass;
	//std::string username = GetClientUsername(client_socket);
	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;			// username
	username = *it; 
	it++;			// newPass
	newPass = *it;
	it++;			//oldPass
	oldPass = *it;

	//la aplicatia client, functia ce trimite mesajul de schimabre aprola are psoibilitatea sa nu includa o parola veche
	//daca nu este inclusa, se va trimtie automat "none"
	//deci nu mai facem verificarea
	/*QByteArray info;
	info.append(oldPass);
	QByteArray encrypted_password = m_AES_engine->encryptAES(HASH, info);
	encrypted_password = encrypted_password.toBase64();*/

	QByteArray info;
	info.append(oldPass);
	QByteArray encrypted_password = m_RSA_engine->encryptRSA(m_public_RSA_key, info);
	encrypted_password = encrypted_password.toBase64();


	if (oldPass != "none") {
		int checkOldPass = m_LoginManager->Login(username, encrypted_password.data());
		if (checkOldPass != LoginManager_SUCCES_Admin && checkOldPass != LoginManager_SUCCES_Utilizator) {

			sendResponse(PROT_CHANGE_PASSWORD_RESPONSE_OLD_PASS_WRONG, client_socket);
			return FAILED;
		}
	}
	/*QByteArray info2;
	info2.append(newPass);
	QByteArray encrypted_new_password = m_AES_engine->encryptAES(HASH, info2);
	encrypted_new_password = encrypted_new_password.toBase64();*/
	QByteArray info2;
	info2.append(newPass);
	QByteArray encrypted_new_password = m_RSA_engine->encryptRSA(m_public_RSA_key, info2);
	encrypted_new_password = encrypted_new_password.toBase64();



	if (LoginManager_SUCCES != m_LoginManager->ChangePassword(username, encrypted_new_password.data())) {

		sendResponse(PROT_CHANGE_PASSWORD_RESPONSE_FAILED, client_socket);
		return FAILED;
	}

	sendResponse(PROT_CHANGE_PASSWORD_RESPONSE_SUCCEDED, client_socket);
	return SUCCEEDED;
}
int Server::ChangeEmail(IMessage* mess, int client_socket) {

	std::string newEmail;
	std::string username;
	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++;
	username = *it;
	it++; 
	newEmail = *it;

	if (LoginManager_SUCCES != m_LoginManager->ChangeEmail(username, newEmail)) {

		sendResponse(PROT_CHANGE_EMAIL_RESPONSE_FAILED, client_socket);
		return FAILED;
	}

	sendResponse(PROT_CHANGE_EMAIL_RESPONSE_SUCCEDED, client_socket);
	return SUCCEEDED;
}
int Server::ShowUserList(IMessage* mess, int client_socket) {

	if (PROT_SUCCEDED != Protocol::checkViewUsersRequest(mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}

	std::list<LoginManager_ClientsDetails> clients = m_LoginManager->GetAllData();
	IMessage* response_mess = Factory_Message::Create_Message(PROT_VIEW_USERS_RESPONSE_SUCCEDED);
	for (auto it = clients.begin(); it != clients.end(); it++) {

		response_mess->Add(it->username);
	}
	response_mess->Add_EndOfMessage();
	if (PROT_SUCCEDED != Protocol::checkViewUsersResponse(response_mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}

	sendMessage(response_mess, client_socket);

	return SUCCEEDED;
}
int Server::DeleteUser(IMessage* mess, int client_socket) {

	if (PROT_SUCCEDED != Protocol::checkDeleteUserRequest(mess)) {

		sendResponse(PROT_DELETE_USER_RESPONSE_FAILED, client_socket);
		return FAILED;
	}
	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++; //username
	std::string username = *it;

	if (checkUsername(username) == false) {

		sendResponse(PROT_DELETE_USER_RESPONSE_USER_NoEXIST, client_socket);
		return SUCCEEDED;
	}

	if (LoginManager_SUCCES != m_LoginManager->Delete(username)) {

		sendResponse(PROT_DELETE_USER_RESPONSE_FAILED, client_socket);
		return FAILED;
	}
	m_FilesManager->DeleteUserFolders(username);
	DeleteFrom_ClientDetails(username);
	sendResponse(PROT_DELETE_USER_RESPONSE_SUCCEDED, client_socket);
	// everything fine -> delete user from logged users
	

	return SUCCEEDED;
}
int Server::PromoteUser(IMessage* mess, int client_socket) {

	if (PROT_SUCCEDED != Protocol::checkPromoteUserRequest(mess)) {

		sendResponse(PROT_PROMOTE_USER_RESPONSE_FAILED, client_socket);
		return FAILED;
	}
	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++; //username
	std::string username = *it;
	it++; //promote mod
	bool promote_mod = (*it == std::to_string(PROT_PROMOTE_ADMIN)) ? 1 : 0;

	if (checkUsername(username) == false) {

		sendResponse(PROT_PROMOTE_USER_RESPONSE_USER_NoEXIST, client_socket);
		return SUCCEEDED;
	}

	if (LoginManager_SUCCES != m_LoginManager->ChangeAdminStatus(username, promote_mod)) {

		sendResponse(PROT_PROMOTE_USER_RESPONSE_FAILED, client_socket);
		return FAILED;
	}

	sendResponse(PROT_PROMOTE_USER_RESPONSE_SUCCEDED, client_socket);

	return SUCCEEDED;
}



int Server::sendMessage(IMessage* mess, int client_socket) {

	int char_trimise;
	std::string message = mess->GetTheMessage();

	QByteArray info;
	info.append(message);
	QByteArray encrypted = m_AES_engine->encryptAES(HASH, info);
	encrypted = encrypted.toBase64();

	char_trimise = send(client_socket, encrypted.data(), MESS_BUFF, 0);
	delete mess;

	if (char_trimise != MESS_BUFF)
		return char_trimise;
	return SUCCEEDED;
}
void Server::sendResponse(int type, int client_socket) {

	//va fi sters pointerul al trimitere
	IMessage* response_mess = Factory_Message::Create_Message(type);
	response_mess->Add_EndOfMessage();
	if (PROT_SUCCEDED != Protocol::checkBasicResponse(response_mess))
		throw new Exception_Server("BasicResponse creat gresit! Asta nu ar trebui sa se intample");
	sendMessage(response_mess, client_socket);
}


IMessage* Server::CreateMessage(int type) {

	return Factory_Message::Create_Message(type);
}
IMessage* Server::DecapsulateMessage(char buffer[MESS_BUFF]) {

	QByteArray message;
	message.append(buffer);
	message = message.fromBase64(message);
	QByteArray decrypted_message = m_AES_engine->decryptAES(HASH, message);
	if (decrypted_message.isEmpty())
		return Factory_Message::Create_Message(NO_ACTION);

	return Factory_Message::Create_Message(decrypted_message.data());
}
void Server::SwitchFunction(IMessage* mess, int client_socket) {

	
	int type = mess->GetType();
	switch (type)
	{
	case PROT_LOGIN_REQUEST: //
		Login(mess, client_socket);
		break;
	case PROT_REGISTER_REQUEST: // 
		Register(mess, client_socket);
		break;
	case PROT_SEND_CLIENT_DATA:
		SaveClientData(mess, client_socket);
		break;
	case PROT_FILE_UPLOAD_REQUEST:
		UploadFileToServer(mess, client_socket,false);
		break;
	case PROT_VIEW_FILES_REQUEST:
		ShowFilesFromServer(mess, client_socket);
		break;
	case PROT_FILE_DOWNLOAND_REQUEST:
		DownloandFileFromServer(mess, client_socket);
		break;
	case PROT_CHANGE_PASSWORD_REQUEST: 
		ChangePassword(mess, client_socket);
		break;
	case PROT_CHANGE_EMAIL_REQUEST: 
		ChangeEmail(mess, client_socket);
		break;
	case PROT_VIEW_USERS_REQUEST:
		ShowUserList(mess, client_socket);
		break;
	case PROT_DELETE_USER_REQUEST:
		DeleteUser(mess, client_socket);
		break;
	case PROT_PROMOTE_USER_REQUEST:
		PromoteUser(mess, client_socket);
		break;
	case PROT_START_SERVER_REQUEST:
		StartServer(mess, client_socket);
		break;
	case PROT_SHUTDOWN_SERVER_REQUEST:
		ShutdownServer(mess, client_socket);
		break;
	case PROT_LOGOUT_REQUEST:
		LogOut(mess, client_socket);
		break;
	case PROT_CHECK_ADMIN_REQUEST:
		checkIfAdmin(mess, client_socket);
		break;
	case PROT_BINARY_FILE_UPLOAD_REQUEST:
		UploadFileToServer(mess, client_socket, true);
		break;
	//case NO_ACTION:
	//	//nothing to do here
	//	// close connection 
	//	std::cout << "[-] A client closed connection..." << std::endl;
	//	closesocket(client_socket);
	//	DeleteFrom_ClientDetails(client_socket);
	//	for (int i = 0; i < clients.size(); i++)
	//	{
	//		if (clients[i] == client_socket)
	//		{
	//			clients[i] = 0;
	//			break;
	//		}
	//	}
	//	break;
		
	default:
		throw new Exception_Server("INVALID TYPE OF MESSAGE! in cadrul selectiei functiei");
		break;
	}

}

void Server::AddTo_ClientDetails(int socket, std::string username) {

	ClientData temp;
	temp.Set(socket, username);
	m_clientsDetails.push_back(temp);
}

void Server::DeleteFrom_ClientDetails(int socket) {

	for (auto it = m_clientsDetails.begin(); it != m_clientsDetails.end(); it++) {

		if (it->sock == socket)
		{
			m_clientsDetails.erase(it);
			break;
		}
	}
}

void Server::DeleteFrom_ClientDetails(std::string username) {

	for (auto it = m_clientsDetails.begin(); it != m_clientsDetails.end(); it++) {

		if (it->username == username)
		{
			m_clientsDetails.erase(it);
			break;
		}
	}
}

bool Server::checkUsername(std::string username) {

	std::list<LoginManager_ClientsDetails> clients = m_LoginManager->GetAllData();
	for (auto it = clients.begin(); it != clients.end(); it++) {

		if (it->username == username)
			return true;
	}
	return false;
}

bool Server::checkIfAdmin(IMessage* mess, int client_socket)
{
	if (PROT_SUCCEDED != Protocol::checkAdminRequest(mess)) {

		sendResponse(PROT_FAILED, client_socket);
		return FAILED;
	}
	std::string username;
	std::list<std::string> elements = mess->GetElementsOfMessage();
	auto it = elements.begin();
	it++; //username;
	username = *it;
	std::list<LoginManager_ClientsDetails> clients = m_LoginManager->GetAllData();

	for (auto it = clients.begin(); it != clients.end(); it++)
	{
		if (it->username == username)
		{
			if (it->admin)
			{
				sendResponse(TRUE, client_socket);
				break;
			}
			else
			{
				sendResponse(FALSE, client_socket);
				break;
			}
		}
	}

	return SUCCEEDED;
}
