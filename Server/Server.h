#define _CRT_SECURE_NO_WARNINGS

#pragma once
#include "IServer.h"
#include "MACRO_Protocol.h"
#include <iostream>
#include <winsock.h>
#include <Windows.h>
#include <sqlext.h>
#include <sqltypes.h>
#include <sql.h>
#include <string>
#include <vector>
#include <memory>
#include "ICipherEngine.h"

//#include "ICipherEngine.h"

class IMessage;
class iLoginManager;
class IFilesManager;
struct ClientData;
class ICipherEngine;

class Server : public IServer {

public:
	static IServer& Get_Instance();
	static void Destroy_Instance();
	~Server() {}

protected:



private:
	Server();
	Server(const Server& other) = delete;
	static std::unique_ptr<Server> instance;


	void WSA_Startup();
	void Socket_init();
	void Sockaddr_init();
	void Socket_option();
	void Bind();
	void Listen();
	void Prepare_ground();
	void Work();

	void Start_Server_Working() override; // this will call those 8 private methods :)
	void Process_The_New_Request();
	void ProcessNewMessageFromClient(int client_socket);

	//
	WSADATA ws;
	struct sockaddr_in server;
	fd_set fr, fw, fe;
	int max_fd;
	int result = 0;
	int server_socket;
	std::string m_adminCod;
	std::vector<int> clients;
	std::vector<ClientData> m_clientsDetails;
	bool server_on = true;
	RSA* m_private_RSA_key;
	RSA* m_public_RSA_key;

	//CRYPTO Oriented
	std::unique_ptr<ICipherEngine> m_AES_engine;
	std::unique_ptr<ICipherEngine> m_RSA_engine;

	std::unique_ptr<iLoginManager> m_LoginManager;
	std::unique_ptr<IFilesManager> m_FilesManager;

	//
	char* GetIPaddr(SOCKET s, int& err, bool port);
	std::string GetClientUsername(int client_socket);


	int sendMessage(IMessage* mess, int client_socket);
	void sendResponse(int type, int client_socket);

	int Login(IMessage* mess, int client_socket);
	int Register(IMessage* mess, int client_socket);
	void SaveClientData(IMessage* mess, int client_socket);
	int UploadFileToServer(IMessage* mess, int client_socket, bool binary); //(client -> server)
	int DownloandFileFromServer(IMessage* mess, int client_socket);//	(server -> client)
	int ShowFilesFromServer(IMessage* mess, int client_socket);
	int ChangePassword(IMessage* mess, int client_socket);
	int ChangeEmail(IMessage* mess, int client_socket);
	int ShowUserList(IMessage* mess, int client_socket);
	int DeleteUser(IMessage* mess, int client_socket);
	int PromoteUser(IMessage* mess, int client_socket);
	int LogOut(IMessage* mess, int client_socket);

	int StartServer(IMessage* mess, int client_socket);
	int ShutdownServer(IMessage* mess, int client_socket);

	IMessage* CreateMessage(int type);
	IMessage* DecapsulateMessage(char buffer[MESS_BUFF]);
	void SwitchFunction(IMessage* mess, int client_socket);

	void AddTo_ClientDetails(int socket, std::string username);
	void DeleteFrom_ClientDetails(int socket);
	void DeleteFrom_ClientDetails(std::string username);

	//verifica daca exista suername
	bool checkUsername(std::string username);
	bool checkIfAdmin(IMessage* mess, int client_socket);
};
