#pragma once
#include "iDatabase.h"

#include <iostream>
#include <Windows.h>
#include <sqlext.h>
#include <sqltypes.h>
#include <sql.h>

class ILog;

class CDatabase :
    public iDatabase
{
public:
    CDatabase();
    ~CDatabase();
    CDatabase(const CDatabase* other) = delete;

    int Connect(std::string driver, std::string server, std::string port, std::string databaseName) override;
    int Register(std::string username, std::string passwrod, std::string email, bool admin) override;
    int GetLoginData(std::list<DB_loginData>* resultList) override;
    int Delete(std::string username) override;
    int ChangePassword(std::string username, std::string password) override;
    int ChangeEmail(std::string username, std::string email) override;
    int ChangeAdminStatus(std::string username, bool admin) override;

private:
    SQLHANDLE m_SQLEnvHandle;
    SQLHANDLE m_SQLConnectionHandle;
    SQLHANDLE m_SQLStatemntHandle;

    std::string ConstructConexionData(std::string driver, std::string server, std::string port, std::string databaseName);
 
    ILog* m_log;

    void CloseConnection();
};

