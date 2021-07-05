#pragma once
#include <winsock.h>
#include <string>

typedef struct ClientData {

	SOCKET sock;
	std::string username;
	//vedem ce mai adaugam

	void Set(SOCKET socket, std::string user) {

		sock = socket;
		username = user;
	}
};