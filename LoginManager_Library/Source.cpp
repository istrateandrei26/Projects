#include "pch.h"
#include "iLoginManager.h"
#include "IException.h"
#include <iostream>

int main() {

	std::unique_ptr<iLoginManager> LM = Factory_LoginManager::Create_LoginManager("SQL Server", "localhost", "1433", "LoginManager");
	
	//int ret = LM->Register("username23", "parolaaaaaaaaA1", "parolaaaaaaaaA1", "email1@yahoo.com");
	//if (LoginManager_SUCCES != ret) {

	//	std::cout << ret << std::endl;
	//}
	//ret = LM->Register("eu", "Humax.1234", "Humax.1234", "email12@yahoo.com");
	//if (LoginManager_SUCCES != ret) {

	//	std::cout << ret << std::endl;
	//}
	//ret = LM->Register("username2323", "parolaaaaaaaaA1", "parolaaaaaaaaA1", "email132@yahoo.com");
	//if (LoginManager_SUCCES != ret) {

	//	std::cout << ret << std::endl;
	//}
	//ret = LM->Register("username23233213", "parolaaaaaaaaA132", "parolaaaaaaaaA132", "email1323@yahoo.com",1);
	//if (LoginManager_SUCCES != ret) {

	//	std::cout << ret << std::endl;
	//}

	//try {
	//	int ret = LM->Login("username23233213", "parolaaaaaaaaA132");
	//	if (ret == LoginManager_SUCCES_Admin)
	//		std::cout << "Admin" << std::endl;
	//	else if (ret == LoginManager_SUCCES_Utilizator)
	//		std::cout << "Utilizator" << std::endl;
	//	else
	//		std::cout << "fail" << std::endl;

	//}
	//catch (IException* e) {

	//	e->Print();
	//}
}
 
