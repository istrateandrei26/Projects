#include "Server.h"
#include "Macros.h"

#include <memory>

unique_ptr<Server> Server::instance = nullptr;

Server::Server()
{
	FD_ZERO(&fr);
	FD_ZERO(&fw);
	FD_ZERO(&fe);
	max_fd = 0;
	server.sin_port = PORT;
	server_socket = 0;
	ws.iMaxSockets = 1;
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
	server.sin_addr.s_addr = inet_addr("192.168.0.101");
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

		result = select(max_fd + 1 , &fr, &fw, &fe, &tv);
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
			string buffer = "Got the connection done";
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
	char buffer_to_be_received[1024] ;
	int status = recv(client_socket, buffer_to_be_received, strlen(buffer_to_be_received) + 1, 0);
	if (status < 0)
	{
		// close connection 
		std::cout << "[-] Something wrong happened...closing connection" << std::endl;
		closesocket(client_socket);
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
		std::cout << "The message from client is: " << buffer_to_be_received << std::endl;
		
		//send response to client
		send(client_socket, "Processed your request", 23, 0);
		std::cout << "*********************************" << std::endl;
	}
}



void Server::Start_Server_Working()
{
	//fill(clients.begin(), clients.end(), 0);

	WSA_Startup();
	Socket_init();
	Sockaddr_init();
	Socket_option();
	Bind();
	Listen();
	Prepare_ground();
	Work();




}
