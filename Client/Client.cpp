#define _CRT_SECURE_NO_WARNINGS

#include "Client.h"
#include "MACRO_Client.h"
#include "IMessage.h"
#include "Protocol.h"
#include "MACRO_Protocol.h"
#include "Exception_Client.h"
#include "Exception_File.h"

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
}
Client::~Client() {

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
	m_server.sin_addr.s_addr = inet_addr("192.168.1.7");
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


	client->test();

	
	return client;
}
void Client::test() {

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

int Client::Autentificare() {

	do {
		system("cls");
		std::cout << "Tastati:\n";
		std::cout << "\t1. Logare\n";
		std::cout << "\t2. Inregistrare\n";

		char option;
		do {

			option = _getch();
		} while (option != '1' && option != '2');

		int ret;
		switch (option)
		{
			//logare
		case '1':
			return Logare();
			break;

			//inregistrare
		case '2':
			Register();
			break;
		default:
			std::cout << "[-][ERROR] Asta nu ar trebui sa se intample" << std::endl;
			break;
		}
	} while (true);
}

int Client::sendRequest(IMessage* mess) {

	int char_trimise = send(m_ClientSocket, mess->GetTheMessage().c_str(), MESS_BUFF, 0);
	delete mess;
	if (char_trimise != MESS_BUFF)
		return char_trimise;
	return SUCCEEDED;
}
IMessage* Client::receiveResponse() {

	char message[MESS_BUFF];
	recv(m_ClientSocket, message, strlen(message) + 1, 0);

	IMessage* response_mess = Factory_Message::Create_Message(message);
	return response_mess;
}

int Client::Logare() {

	bool logat_cu_succes = true;
	do {
		system("cls");
		if (logat_cu_succes == false) {

			//la prima incercare nu afiseaza asta
			std::cout << "Username sau parola gresite... Reincercati.\n\n";
		}
		logat_cu_succes = false;

		//cerem datele
		std::string username;
		std::string password;
		std::cout << "Introduceti username: ";
		std::cin >> username;
		std::cout << "Introduceti parola: ";
		std::cin >> password;

		int ret = GetLoginResponse(username, password);
		if (PROT_LOGIN_RESPONSE_FAILED != ret) {
			return ret;
		}

	} while (!logat_cu_succes);

	return FAILED;
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

int Client::Register() {

	bool inregsitrat_cu_succes = true;
	do {

		system("cls");
		if (inregsitrat_cu_succes == false) {

			//la prima incercare nu afiseaza asta
			std::cout << "Username sau email deja folosit... Reincercati.\n\n";
		}
		inregsitrat_cu_succes = false;

		//cerem datele
		std::string username;
		std::string password;
		std::string repeat_password;
		std::string email;
		std::string cod_admin;
		char skip;
		std::cout << "Introduceti username: ";
		std::cin >> username;
		std::cout << "Introduceti parola: ";
		std::cin >> password;
		std::cout << "Repetati parola: ";
		std::cin >> repeat_password;
		std::cout << "Introduceti email: ";
		std::cin >> email;
		std::cout << "(Optional) Introduceti cod admin: ";
		std::cin >> cod_admin;


		int ret = GetRegisterResponse(username, password, email, cod_admin);
		if (PROT_REGISTER_RESPONSE_SUCCEDED == ret)
			return ret;

	} while (!inregsitrat_cu_succes);

	return FAILED;
}
int Client::GetRegisterResponse(std::string username, std::string password, std::string email, std::string admin_cod) {

	//mesajul asta e distrus la trimitere
	IMessage* mess = Factory_Message::Create_Message(PROT_REGISTER_REQUEST);
	mess->Add(username);
	mess->Add(password);
	mess->Add(email);
	mess->Add(admin_cod);
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


int Client::sendFile(std::string filePath, std::string destinationName, bool replace) {

	if (!fs::exists(filePath)) {

		return FAILED;
	}
	
	std::ifstream file(filePath.c_str());

	file.seekg(0, file.end);
	int lenght = file.tellg();
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
	for (int i = index_chunks; i < number_ofChunks; i++) {

		string_chunk.erase();
		if (index_chunks == number_ofChunks - 1) {

			//file.seekg(i * CHUNK_OF_FILE, file.beg);
			int current_poz = file.tellg();
			file.seekg(0, file.end);
			lenght = file.tellg();
			lenght = lenght - current_poz;
			file.seekg(current_poz, file.beg);

			file.read(chunk_ofFile, lenght);
			chunk_ofFile[lenght] = '\0';
			string_chunk = chunk_ofFile;
 		}
		else {

			//file.seekg(i * CHUNK_OF_FILE, file.beg);
			file.read(chunk_ofFile, CHUNK_OF_FILE - 1); 
			chunk_ofFile[CHUNK_OF_FILE - 1] = '\0';
			string_chunk = chunk_ofFile;
		}
		 
		//compunem mesaj cu tipul SendFile_New_nume_continut_END
		IMessage* mess = Factory_Message::Create_Message(PROT_FILE_UPLOAD_REQUEST);
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

