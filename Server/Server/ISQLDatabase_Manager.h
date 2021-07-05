#pragma once
#include "Macros.h"
#include <Windows.h>
#include <sqlext.h>
#include <sqltypes.h>
#include <sql.h>
#include <iostream>

using namespace std;

class ISQLDatabase_Manager
{
public:

	ISQLDatabase_Manager() {}
	virtual ~ISQLDatabase_Manager() {}
	virtual void Connect_to_SQLServerDatabase() = 0;
	virtual void Close_Connection_to_SQLServerDatabase() = 0;
	virtual void Register_Client(const string& FirstName, const string& LastName, const string& username, const string& password) = 0;
};



class Database_Headquarter
{
public:
	Database_Headquarter() = delete;
	Database_Headquarter(const Database_Headquarter&) = delete;

	static unique_ptr<ISQLDatabase_Manager> Deploy();
};

