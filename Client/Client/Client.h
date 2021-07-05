#pragma once
#include "IClient.h"


#include <iostream>
#include <winsock.h>
#include <string>
#include <vector>
using namespace std;



class Client : public IClient
{
protected:
	int m_ClientSocket;
	struct sockaddr_in server;
	int result = 0;	
	WSADATA ws;


	void WSA_Startup() override;
	void Socket_init() override;
	void Sockaddr_init() override;
	
public:
	Client();
	virtual ~Client() {}

	void Connect() override;
};