#include "Client.h"
#include "Macros.h"




void Client::WSA_Startup()
{
	if (WSAStartup(MAKEWORD(2, 2), &ws) < 0)
	{
		std::cout << "[-] WSA failed" << std::endl;
		WSACleanup();
		exit(EXIT_FAILURE);
	}
}

void Client::Socket_init()
{
	m_ClientSocket = socket(TCP_NETWORK, STREAM, TCP_PROTOCOL);

	if(m_ClientSocket == FAILED)
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
	string ip_address = "192.168.0.101";
	server.sin_family = TCP_NETWORK;
	server.sin_port = htons(PORT);
	server.sin_addr.s_addr = inet_addr(ip_address.c_str());
	memset(&server.sin_zero, 0, 8);
}

void Client::Connect()
{
	result = connect(m_ClientSocket, (struct sockaddr*)&server, sizeof(server));

	if (result < 0)
	{
		std::cout << "[-] Failed to connect to the server" << std::endl;
		WSACleanup();
		exit(EXIT_FAILURE);
	}
	else
	{
		std::cout << "[+] Connected to the server" << std::endl;
		char message[BUFF] = { 0, };
		recv(m_ClientSocket, message, BUFF, 0);
		std::cout << "Just press any key on keyboard to see the message received from the server" << std::endl;
		getchar();
		std::cout << message << std::endl;

		while (true)
		{
			fgets(message, 256, stdin);
			send(m_ClientSocket, message, 256, 0);
			std::cout << "Press any key to get the response from server..." << std::endl;
			getchar();
			recv(m_ClientSocket, message, 256, 0);
			std::cout << message << std::endl << "Now send your next message" << std::endl;
		}
	}
}

Client::Client()
{
	// initializing socket and getting ready , in order to connect to the server
	WSA_Startup();
	Socket_init();
	Sockaddr_init();
}
