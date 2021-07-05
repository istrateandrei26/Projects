#pragma once
#include "pch.h"
#include "Client.h"
#include "Exception_Method.h"

class CUtilizator :
    public Client
{
public:
    CUtilizator() { ; }
    CUtilizator(std::unique_ptr<IClient>& other) {

        m_username = other->GetUsername();
    }
    ~CUtilizator() { ; }

    void Run() override;
    //COMMON USER oriented methods
    // 
    //nu uita sa adaugi criptare
    //PARAMETRII: Numele pe PC-ul sursa(si calea), numele dorit la destiantie,
    //				replace == true => Nu tine cont ca un fisier cu acelasi nume exista la PC-ul destiantie si il rescrie
    //				replace == false => Daca exsiat un fiser cu acelasi nume la destinatie va returna PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST (macro_protocol)
    //RETURN: PROT_FILE_UPLOAD_RESPONSE_SUCCEDED (daca fisierul e trimis tot cu succes)
    //		  PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST (cazul discutat mai sus)
    //		  PROT_FILE_UPLOAD_RESPONSE_FAILED  (daca trimiterea a esuat)
    int sendFile(std::string filePath, std::string destinationName, bool replace = false) override;
    int sendBinaryFile(std::string filePath, std::string destinationName, bool replace) override;
    //COMMON USER oriented methods
    void AskForUploadFileDetails() override;
    void UpdateUploadFileDetails() override;
    //locul unde doriti sa fie salvat pe pc-ul client, numele fisierului pe server
    /**/int DownloadFile(std::string filepath, std::string filename) override;
    void AskForDownloandFileDetails() override;



    //admin oriented methods
    int AdminGetUsers(std::list<std::string>* list_users) override { throw Exception_Method(); }
    void AdminViewUsers() override { throw Exception_Method(); }

    void AdminViewFiles() override { throw Exception_Method(); }
    void AdminAskViewFilesDetails() override { throw Exception_Method(); }

    int AdminDeleteUser(std::string username) override { throw Exception_Method(); }
    void AdminAskDeleteUserDetails() override { throw Exception_Method(); }

    int AdminPromoteUser(std::string username, int mod) override { throw Exception_Method(); }
    void AdminAskPromoteUserDetails() override { throw Exception_Method(); }

    int AdminShutdownServer() override { throw Exception_Method(); }
    int AdminStartServer() override { throw Exception_Method(); }

    int AdminCheckIfAdmin(std::string username) override { throw Exception_Method(); }
private:

    std::string m_currentFilepath;
    std::string m_currentFilename;

    void WelcomePrint() override;
    void UploadFile(bool replace = false) override;
    void AskForFileDetails();
    void UpdateFileDetails();
    IMessage* ComposeMessageToSendBinaryFile(int mod, std::string destinationName, std::string text);
};

