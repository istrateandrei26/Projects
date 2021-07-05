#include "SQLDatabase_Manager.h"

void SQLDatabase_Manager::Close_Connection_to_SQLServerDatabase()
{
	SQLFreeHandle(SQL_HANDLE_STMT, sqlStmtHandle);
	SQLDisconnect(sqlConnHandle);
	SQLFreeHandle(SQL_HANDLE_DBC, sqlConnHandle);
	SQLFreeHandle(SQL_HANDLE_ENV, sqlEnvHandle);
	//pause the console window - exit when key is pressed
	cout << "\nPress any key to exit...";
	getchar();
}

void SQLDatabase_Manager::Register_Client(const string& FirstName, const string& LastName, const string& username, const string& password)
{
	string query = "INSERT INTO Customers VALUES ('" + FirstName + "','" + LastName + "','" + username + "','" + password + "')";
	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_STMT, sqlConnHandle, &sqlStmtHandle))
		this->Close_Connection_to_SQLServerDatabase();
	std::cout << "Success" << std::endl;
	if (SQL_SUCCESS != SQLExecDirect(sqlStmtHandle, (SQLCHAR*)(query.c_str()), SQL_NTS))    // SQLExecDirect always failed to excute
	{
		cout << "[SQL][-] Query falied." << endl;
		return;
	}
}

SQLDatabase_Manager::SQLDatabase_Manager()
{
	this->sqlConnHandle = NULL;
	this->sqlEnvHandle = NULL;
	this->sqlStmtHandle = NULL;
}

void SQLDatabase_Manager::Connect_to_SQLServerDatabase()
{
	//allocations
	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &sqlEnvHandle))
		this->Close_Connection_to_SQLServerDatabase();
	if (SQL_SUCCESS != SQLSetEnvAttr(sqlEnvHandle, SQL_ATTR_ODBC_VERSION, (SQLPOINTER)SQL_OV_ODBC3, 0))
		this->Close_Connection_to_SQLServerDatabase();
	if (SQL_SUCCESS != SQLAllocHandle(SQL_HANDLE_DBC, sqlEnvHandle, &sqlConnHandle))
		this->Close_Connection_to_SQLServerDatabase();
	//output
	cout << "[SQL] Attempting connection to SQL Server...";
	cout << "\n";
	//connect to SQL Server  
	//I am using a trusted connection and port 14808
	//it does not matter if you are using default or named instance
	//just make sure you define the server name and the port
	//You have the option to use a username/password instead of a trusted     connection
	//but is more secure to use a trusted connection
	switch (SQLDriverConnectW(sqlConnHandle,
		NULL,
		//(SQLWCHAR*)L"DRIVER={SQL Server};SERVER=ServerAddress,     1433;DATABASE=DataBaseName;UID=DataBaseUserName;PWD=PassWord;",
		(SQLWCHAR*)L"DRIVER={SQL Server};SERVER=localhost, 1434;DATABASE=Clients;Trusted=true;",
		SQL_NTS,
		retconstring,
		1024,
		NULL,
		SQL_DRIVER_NOPROMPT)) {
	case SQL_SUCCESS:
		cout << "[SQL][+] Successfully connected to SQL Server";
		cout << "\n";
		break;
	case SQL_SUCCESS_WITH_INFO:
		cout << "[SQL][+] Successfully connected to SQL Server";
		cout << "\n";
		break;
	case SQL_INVALID_HANDLE:
		cout << "[SQL][-] Could not connect to SQL Server";
		cout << "\n";
		this->Close_Connection_to_SQLServerDatabase();
	case SQL_ERROR:
		cout << "[SQL][-] Could not connect to SQL Server";
		cout << "\n";
		this->Close_Connection_to_SQLServerDatabase();
	default:
		break;
	}
}
