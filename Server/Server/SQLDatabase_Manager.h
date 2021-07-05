#pragma once
#include "ISQLDatabase_Manager.h"


class SQLDatabase_Manager : public ISQLDatabase_Manager
{
private:
	SQLHANDLE sqlConnHandle;
	SQLHANDLE sqlStmtHandle;
	SQLHANDLE sqlEnvHandle;
	SQLWCHAR retconstring[SQL_RETURN_CODE_LEN];


	
public:
	SQLDatabase_Manager();
	~SQLDatabase_Manager() {}
	void Connect_to_SQLServerDatabase() override;
	void Close_Connection_to_SQLServerDatabase();
	void Register_Client(const string& FirstName, const string& LastName, const string& username, const string& password) override;



};