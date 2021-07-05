#include "Client.h"
#include "CAdmin.h"
#include "CUtilizator.h"

std::unique_ptr<IClient> Client_Builder::Get()
{
	return std::make_unique<Client>();
}
std::unique_ptr<IClient> Client_Builder::GetAdmin(std::unique_ptr<IClient>& other) {

	std::unique_ptr<CAdmin> temp = std::make_unique<CAdmin>(other);
	other.release();
	return temp;
	//return std::make_unique<CAdmin>();
}
std::unique_ptr<IClient> Client_Builder::GetUtilizator(std::unique_ptr<IClient>& other) {

	std::unique_ptr<CUtilizator> temp = std::make_unique<CUtilizator>(other);
	other.release();
	return temp;
	//return std::make_unique<CUtilizator>();
}