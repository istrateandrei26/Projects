#pragma once
#include <iostream>
#include <winsock.h>
#include <Windows.h>
#include <sqlext.h>
#include <sqltypes.h>
#include <sql.h>
#include <string>
#include <vector>
#include "IServer.h"
#include "ICipherEngine.h"
#include "ISQLDatabase_Manager.h"

using namespace std;


class Server : public IServer
{
	
private:
	Server();
	Server(const Server& other) = delete;
	static unique_ptr<Server> instance;
	
	//
	struct sockaddr_in server;
	fd_set fr, fw, fe;
	int max_fd;
	int result = 0;
	int server_socket;
	vector<int> clients;
	WSADATA ws;

	//
	unique_ptr<ICipherEngine> RSA_engine;
	unique_ptr<ICipherEngine> AES_engine;
	unique_ptr<ISQLDatabase_Manager> dbManager;

	void WSA_Startup();
	void Socket_init();
	void Sockaddr_init();
	void Socket_option();
	void Bind();
	void Listen();
	void Prepare_ground();
	void Work();

	void Process_The_New_Request();
	void ProcessNewMessageFromClient(int client_socket);
	
	

public:
	static IServer& Get_Instance();
	static void Destroy_Instance();
	~Server() {}

	void Start_Server_Working() override; // this will call those 8 private methods :)





};
