#include "Client.h"

std::unique_ptr<IClient> Client_Builder::Get()
{
	return std::make_unique<Client>();
}
