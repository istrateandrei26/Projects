#include <iostream>
#include <memory>
#include "IClient.h"





void main()
{
	std::unique_ptr<IClient> tester_client = Client_Builder::Get();
	tester_client->Connect();	
}