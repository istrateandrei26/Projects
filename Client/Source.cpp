#include <iostream>
#include <memory>

#include "IClient.h"
#include "MACRO_Protocol.h"

#include "CAdmin.h"

void main()
{
	std::unique_ptr<IClient> tester_client = Client_Builder::Get();
	tester_client->Connect();
	int client_type = tester_client->Autentificare();

	//dupa autentificare cu succes, oprim conexiunea trecuta.
	//si repornim alta de data asta dintr-o clasa de tip Admin/Utilizator
	
	std::unique_ptr<IClient> client = tester_client->Reconnect(client_type, tester_client);
	//client->test();
	client->Run();
	
	
}

