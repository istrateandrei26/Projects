#pragma once

#include "MACRO_Database.h"

#include <string>
#include <list>

//structura cprespunde unui tabel din baza de date (tabelul cu datele de inregistrare)
typedef struct DB_loginData {

    int ID;
    std::string username;
    std::string password;
    std::string email;
    int admin;

    void Set(int id, std::string name, std::string pass, std::string mail, int status) {

        ID = id;
        username = name;
        password = pass;
        email = mail;
        admin = status;
    }
};

class iDatabase {

public:
	iDatabase() { ; }
	virtual ~iDatabase() { ; }

	virtual int Connect(std::string driver, std::string server, std::string port, std::string databaseName) = 0;
	virtual int Register(std::string username, std::string passwrod, std::string email, bool admin) = 0;
	virtual int GetLoginData(std::list<DB_loginData>* resultList) = 0;
    virtual int Delete(std::string username) = 0;
    virtual int ChangePassword(std::string username, std::string password) = 0;
    virtual int ChangeEmail(std::string username, std::string email) = 0;
    virtual int ChangeAdminStatus(std::string username, bool admin) = 0;
};

class Factory_Database {

public:
	static iDatabase* Create_DatabaseInstance();
};