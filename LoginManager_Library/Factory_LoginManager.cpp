#include "pch.h"
#include "iLoginManager.h"
#include "CLoginManager.h"

#include <string>

std::unique_ptr<iLoginManager> Factory_LoginManager::Create_LoginManager(std::string driver, std::string server, std::string port, std::string databaseName) {

	return std::make_unique<CLoginManager>(driver, server, port, databaseName);
}