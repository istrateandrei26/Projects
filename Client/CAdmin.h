#pragma once
#include "Client.h"
class CAdmin :
    public Client
{
public:
    CAdmin() { ; }
    CAdmin(std::unique_ptr<IClient>& other) {

        m_username = other->GetUsername();
    }

    ~CAdmin() { ; }

    void Run() override;

private:
    void WelcomePrint() override;

    /**/int getUsers(std::list<std::string>* list_users);
    void ViewUsers();

    void ViewFiles();
    void AskViewFilesDetails();

    /**/int deleteUser(std::string username);
    void AskDeleteUserDetails();

    int promoteUser(std::string username, int mod);
    void AskPromoteUserDetails();
};

