#pragma once
#include "pch.h"
#include "Client.h"
#include "Exception_Method.h"
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
    //common user oriented methods
    int sendFile(std::string filePath, std::string destinationName, bool replace = false) override { throw Exception_Method(); }
    void UploadFile(bool replace = false) override { throw Exception_Method(); }
    void AskForUploadFileDetails() override { throw Exception_Method(); }
    void UpdateUploadFileDetails() override { throw Exception_Method(); }
    int DownloadFile(std::string filepath, std::string filename) override { throw Exception_Method(); }
    void AskForDownloandFileDetails() override { throw Exception_Method(); }
    int sendBinaryFile(std::string filePath, std::string destinationName, bool replace) override { throw Exception_Method(); }

    //admin oriented methods
    int AdminGetUsers(std::list<std::string>* list_users) override;
    void AdminViewUsers() override;

    void AdminViewFiles() override;
    void AdminAskViewFilesDetails() override;

    int AdminDeleteUser(std::string username) override;
    void AdminAskDeleteUserDetails() override;

    int AdminPromoteUser(std::string username, int mod) override;
    void AdminAskPromoteUserDetails() override;

    int AdminShutdownServer() override;
    int AdminStartServer() override;

    int AdminCheckIfAdmin(std::string username) override;

    


private:
    void WelcomePrint() override;
};

