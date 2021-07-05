#pragma once

#include "MACRO_LoginManager.h"

#include <string>
#include <list>
#include <memory>

#ifdef LOGINMANAGER_LIBRARY_EXPORTS
#define LOGINMANAGER_LIBRARY_API __declspec(dllexport)
#else
#define LOGINMANAGER_LIBRARY_API __declspec(dllimport)
#endif


extern "C" LOGINMANAGER_LIBRARY_API typedef struct LoginManager_ClientsDetails {

	std::string username;
	std::string email;
	int admin;

	void Set(std::string name, std::string mail, int status) {

		username = name;
		email = mail;
		admin = status;
	}
};

extern "C" LOGINMANAGER_LIBRARY_API class iLoginManager {

public:
	iLoginManager() { ; }
	virtual ~iLoginManager() { ; }

	LOGINMANAGER_LIBRARY_API virtual int Login(std::string username, std::string password) = 0;
	LOGINMANAGER_LIBRARY_API virtual int Register(std::string username, std::string passwrod, std::string email, bool admin = false) = 0;
	LOGINMANAGER_LIBRARY_API virtual int Delete(std::string username) = 0;
	LOGINMANAGER_LIBRARY_API virtual int ChangePassword(std::string username, std::string new_password) = 0;
	LOGINMANAGER_LIBRARY_API virtual int ChangeEmail(std::string username, std::string new_email) = 0;
	LOGINMANAGER_LIBRARY_API virtual int ChangeAdminStatus(std::string username, bool admin) = 0;
	LOGINMANAGER_LIBRARY_API virtual std::list<LoginManager_ClientsDetails> GetAllData() = 0;
	//virtual void Delete(std::string username) = 0;
};

extern "C" LOGINMANAGER_LIBRARY_API class Factory_LoginManager {

public:
	LOGINMANAGER_LIBRARY_API static std::unique_ptr<iLoginManager> Create_LoginManager(std::string driver, std::string server, std::string port, std::string databaseName);
};