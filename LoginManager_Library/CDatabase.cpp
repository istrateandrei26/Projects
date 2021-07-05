#include "pch.h"
#include "CDatabase.h"
#include "ILog.h"

CDatabase::CDatabase() {

	m_log = Log_Factory::Create_Logger(L_Database);
	m_log->Info("clasa Database construita cu succes");

	m_SQLEnvHandle = NULL;
	m_SQLConnectionHandle = NULL;
	m_SQLStatemntHandle = NULL;
}
CDatabase::~CDatabase() {

	CloseConnection();

	m_log->Info("clasa Database distrusa cu succes");
	delete m_log;
}

int CDatabase::Connect(std::string driver, std::string server, std::string port, std::string databaseName) {

	m_log->Info("Initiere conexiune cu baza de date");

	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &m_SQLEnvHandle)) {
		return DB_ERROR;
	}
	if (SQL_SUCCESS != SQLSetEnvAttr(m_SQLEnvHandle, SQL_ATTR_ODBC_VERSION, (SQLPOINTER)SQL_OV_ODBC3, 0)) {
		return DB_ERROR;
	}
	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_DBC, m_SQLEnvHandle, &m_SQLConnectionHandle)) {
		return DB_ERROR;
	}
	if (SQL_SUCCESS != SQLSetConnectAttr(m_SQLConnectionHandle, SQL_LOGIN_TIMEOUT, (SQLPOINTER)5, 0)) {
		return DB_ERROR;
	}

	std::string connection_data = ConstructConexionData(driver, server, port, databaseName);
	SQLCHAR retConString[1024];
	switch (SQLDriverConnect(m_SQLConnectionHandle, NULL, (SQLCHAR*)connection_data.c_str(), SQL_NTS, retConString, 1024, NULL, SQL_DRIVER_NOPROMPT)) {

	case SQL_SUCCESS:
		break;
	case SQL_SUCCESS_WITH_INFO:
		break;
	case SQL_NO_DATA_FOUND:
		return DB_ERROR;
		break;
	case SQL_INVALID_HANDLE:
		return DB_ERROR;
		break;
	case SQL_ERROR:
		return DB_ERROR;
		break;
	default:
		break;
	}

	return DB_SUCCES;
}
int CDatabase::Register(std::string username, std::string password, std::string email, bool admin) {

	m_log->Info("Inserare date utilizator nou");

	char status = (admin == true) ? '1' : '0';

	std::string query = "INSERT INTO LoginData VALUES ('" + username + "','" + password + "','" + email + "','" + status + "')";
	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_STMT, m_SQLConnectionHandle, &m_SQLStatemntHandle))
	{
		m_log->Error("inserarea date utilizator nou a esuat: SQLAllocHandle error");
		return DB_ERROR_REGISTER;
	}
	if (SQL_SUCCESS != SQLExecDirect(m_SQLStatemntHandle, (SQLCHAR*)(query.c_str()), SQL_NTS))    // SQLExecDirect always failed to excute
	{
		m_log->Error("Inserarea date utilizator nou a esuat: executie querry");
		return DB_ERROR_REGISTER;
	}

	m_log->Info("Inserare date utilizator nou realizata cu succes");
	return DB_SUCCES;
}

int CDatabase::GetLoginData(std::list<DB_loginData>* resultList) {

	m_log->Info("Initiere operatie de interogare baza de date: date de inregsitrare");

	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_STMT, m_SQLConnectionHandle, &m_SQLStatemntHandle)) {

		m_log->Error("Interogarea a esuat: SQLAllocHandle error");
		return DB_ERROR_QUERY;
	}

	if (SQL_SUCCESS != SQLExecDirect(m_SQLStatemntHandle, (SQLCHAR*)"SELECT * FROM LoginData;", SQL_NTS)) {

		m_log->Error("Interogarea a esuat: executie query");
		return DB_ERROR_QUERY;
	}
	else {

		resultList->clear();

		int id;
		char username[4000];
		char password[4000];
		char email[4000];
		int admin;

		while (SQLFetch(m_SQLStatemntHandle) == SQL_SUCCESS) {

			SQLGetData(m_SQLStatemntHandle, 1, SQL_C_DEFAULT, &id, sizeof(id), NULL);
			SQLGetData(m_SQLStatemntHandle, 2, SQL_C_DEFAULT, username, sizeof(username), NULL);
			SQLGetData(m_SQLStatemntHandle, 3, SQL_C_DEFAULT, password, sizeof(password), NULL);
			SQLGetData(m_SQLStatemntHandle, 4, SQL_C_DEFAULT, email, sizeof(email), NULL);
			SQLGetData(m_SQLStatemntHandle, 5, SQL_C_DEFAULT, &admin, sizeof(admin), NULL);

			DB_loginData temp;
			temp.Set(id, username, password, email, admin);
			resultList->push_back(temp);
		}
	}

	m_log->Info("Interogare realizata cu succes");
	return DB_SUCCES;
}
int CDatabase::Delete(std::string username) {

	std::string query = "DELETE FROM LoginData WHERE username = '" + username + "';";
	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_STMT, m_SQLConnectionHandle, &m_SQLStatemntHandle))
	{
		m_log->Error("stergere date utilizator nou a esuat: SQLAllocHandle error");
		return DB_ERROR_DELETE;
	}
	if (SQL_SUCCESS != SQLExecDirect(m_SQLStatemntHandle, (SQLCHAR*)(query.c_str()), SQL_NTS))    // SQLExecDirect always failed to excute
	{
		m_log->Error("stergere date utilizator nou a esuat: executie querry");
		return DB_ERROR_DELETE;
	}

	m_log->Info("stergere date utilizator nou realizata cu succes");
	return DB_SUCCES;
}
int CDatabase::ChangePassword(std::string username, std::string password) {

	std::string query = "UPDATE LoginData SET password = '" + password + "' where username = '" + username + "';";
	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_STMT, m_SQLConnectionHandle, &m_SQLStatemntHandle))
	{
		m_log->Error("updatare date utilizator nou a esuat: SQLAllocHandle error");
		return DB_ERROR_UPDATE;
	}
	if (SQL_SUCCESS != SQLExecDirect(m_SQLStatemntHandle, (SQLCHAR*)(query.c_str()), SQL_NTS))    // SQLExecDirect always failed to excute
	{
		m_log->Error("updatare date utilizator nou a esuat: executie querry");
		return DB_ERROR_UPDATE;
	}

	m_log->Info("updatare date utilizator nou realizata cu succes");
	return DB_SUCCES;
}
int CDatabase::ChangeEmail(std::string username, std::string email) {

	std::string query = "UPDATE LoginData SET email = '" + email + "' where(username = '" + username + "'); ";
	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_STMT, m_SQLConnectionHandle, &m_SQLStatemntHandle))
	{
		m_log->Error("updatare date utilizator nou a esuat: SQLAllocHandle error");
		return DB_ERROR_UPDATE;
	}
	if (SQL_SUCCESS != SQLExecDirect(m_SQLStatemntHandle, (SQLCHAR*)(query.c_str()), SQL_NTS))    // SQLExecDirect always failed to excute
	{
		m_log->Error("updatare date utilizator nou a esuat: executie querry");
		return DB_ERROR_UPDATE;
	}

	m_log->Info("updatare date utilizator nou realizata cu succes");
	return DB_SUCCES;
}
int CDatabase::ChangeAdminStatus(std::string username, bool admin) {

	std::string status = (admin == true) ? "1" : "0";

	std::string query = "UPDATE LoginData SET admin = '" + status + "' where(username = '" + username + "'); ";
	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_STMT, m_SQLConnectionHandle, &m_SQLStatemntHandle))
	{
		m_log->Error("updatare date utilizator nou a esuat: SQLAllocHandle error");
		return DB_ERROR_UPDATE;
	}
	if (SQL_SUCCESS != SQLExecDirect(m_SQLStatemntHandle, (SQLCHAR*)(query.c_str()), SQL_NTS))    // SQLExecDirect always failed to excute
	{
		m_log->Error("updatare date utilizator nou a esuat: executie querry");
		return DB_ERROR_UPDATE;
	}

	m_log->Info("updatare date utilizator nou realizata cu succes");
	return DB_SUCCES;

}

std::string CDatabase::ConstructConexionData(std::string driver, std::string server, std::string port, std::string databaseName) {

	std::string result = "DRIVER={";
	result += driver + "};";
	result += "SERVER=";
	result += server + ", ";
	result += port + ";";
	result += "DATABASE=";
	result += databaseName + ";";
	result += "Trusted=true;";

	return result;
}


void CDatabase::CloseConnection() {

	SQLFreeHandle(SQL_HANDLE_STMT, m_SQLStatemntHandle);
	SQLDisconnect(m_SQLConnectionHandle);
	SQLFreeHandle(SQL_HANDLE_DBC, m_SQLConnectionHandle);
	SQLFreeHandle(SQL_HANDLE_ENV, m_SQLEnvHandle);
}
