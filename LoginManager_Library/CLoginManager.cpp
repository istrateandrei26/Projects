#include "pch.h"
#include "CLoginManager.h"
#include "iDatabase.h"
#include "ILog.h"
#include "Exception_LoginManager.h"

#include <iostream>

CLoginManager::CLoginManager(std::string driver, std::string server, std::string port, std::string databaseName) {

	m_log = Log_Factory::Create_Logger(L_LoginManager);
	m_log->Info("clasa LoginManager construita cu succes");

	m_DB = Factory_Database::Create_DatabaseInstance();
	if (DB_SUCCES != m_DB->Connect(driver, server, port, databaseName)) {

		m_log->Error("Conexiunea cu baza de date a esuat");
		throw new Exception_LoginManager("Conexiunea cu baza de date a esuat");
	}

	m_minLenghtPassword = 8;

	m_log->Info("Conexiunea cu baza de data a fost realizata cu succes");
}
CLoginManager::~CLoginManager() {

	m_log->Info("clasa LoginManager distrusa cu succes");

	delete m_DB;
	delete m_log;
}

int CLoginManager::Register(std::string username, std::string password, std::string email, bool admin) {

	m_log->Info("Initiere inregistrare utilizator nou");

	int ret;

	//ret = CheckPasswordStrenght(password);
	//if (ret != LoginManager_SUCCES) {

	//	m_log->Info("Parola introdusa la inregistrare e prea slaba");
	//	return ret;
	//}

	ret = CheckRegisterData(username, email);
	if (ret != LoginManager_SUCCES)
	{
		m_log->Info("Username sau Email deja folosit");
		return ret;
	}

	if (DB_SUCCES != m_DB->Register(username, password, email, admin)) {

		m_log->Error("Inregistrarea a esuat: nu s-a putut scrie in baza de date");
		return LoginManager_Register_ERROR;
	}

	m_log->Info("Inregistrarea noului utilizator a fost realizata cu succes");
	return LoginManager_SUCCES;
}
int CLoginManager::Login(std::string username, std::string password) {

	m_log->Info("Initiere logare utilizator");

	std::list<DB_loginData> logindata_list;
	m_DB->GetLoginData(&logindata_list);

	for (auto it = logindata_list.begin(); it != logindata_list.end(); it++) {

		if (username == it->username && password == it->password) {

			if (it->admin == true) {
				m_log->Info("Logare reusita: admin");
				return LoginManager_SUCCES_Admin;
			}
			else if (it->admin == false) {
				m_log->Info("Logare reusita: utilizator");
				return LoginManager_SUCCES_Utilizator;
			}
			else
				throw new Exception_LoginManager("Imposibil de determinat tipul clientului (admin/utilizator)");
		}
	}

	m_log->Info("Logare nereusita: username sau parola gresita");
	return LoginManager_Login_UsernameOrPassword_Wrong;
}
int CLoginManager::Delete(std::string username) {

	if (DB_SUCCES != m_DB->Delete(username))
		return LoginManager_Delete_ERROR;
	return LoginManager_SUCCES;
}
int CLoginManager::ChangePassword(std::string username, std::string new_password) {

	if (m_DB->ChangePassword(username, new_password) != DB_SUCCES)
		return LoginManager_Update_ERROR;
	return LoginManager_SUCCES;
}
int CLoginManager::ChangeEmail(std::string username, std::string new_email) {

	if (m_DB->ChangeEmail(username, new_email) != DB_SUCCES)
		return LoginManager_Update_ERROR;
	return LoginManager_SUCCES;
}
int CLoginManager::ChangeAdminStatus(std::string username, bool admin) {

	if (m_DB->ChangeAdminStatus(username, admin) != DB_SUCCES)
		return LoginManager_Update_ERROR;
	return LoginManager_SUCCES;
}

std::list<LoginManager_ClientsDetails> CLoginManager::GetAllData() {

	std::list<DB_loginData> logindata_list;
	m_DB->GetLoginData(&logindata_list);

	std::list<LoginManager_ClientsDetails> result;
	for (auto it = logindata_list.begin(); it != logindata_list.end(); it++) {

		LoginManager_ClientsDetails temp;
		temp.Set(it->username, it->email, it->admin);
		result.push_back(temp);
	}

	return result;
}

int CLoginManager::CheckRegisterData(std::string username, std::string email) {

	std::list<DB_loginData> logindata_list;
	m_DB->GetLoginData(&logindata_list);


	for (auto it = logindata_list.begin(); it != logindata_list.end(); it++) {

		if ((username == it->username))
			return LoginManager_Register_UsernameOrEmail_AlreadyUsed;
		if ((email == it->email))
			return LoginManager_Register_UsernameOrEmail_AlreadyUsed;
	}

	return LoginManager_SUCCES;
}
//int CLoginManager::CheckPasswordStrenght(std::string password) {
//
//	if (password.length() < m_minLenghtPassword)
//		return Login_Error_PasswordTooWeak_TooShort;
//
//	for (int i = 0; i < password.length(); i++) {
//
//		if (password.find_first_of("ABCDEFGHIJKLMNOPQRSTUVWXYZ") == std::string::npos) {
//			return Login_Error_PasswordTooWeak_NoUpperCase;
//		}
//		if (password.find_first_of("1234567890") == std::string::npos) {
//			return Login_Error_PasswordTooWeak_NoDigit;
//		}
//	}
//
//	return LoginManager_SUCCES;
//}