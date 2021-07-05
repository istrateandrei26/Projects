#pragma once
#include "Client.h"
class CUtilizator :
    public Client
{
public:
    CUtilizator() { ; }
    CUtilizator(std::unique_ptr<IClient> &other) { 
    
        m_username = other->GetUsername();
    }
    ~CUtilizator() { ; }

    void Run() override;

private:

    void WelcomePrint() override;
    void UploadFile(bool replace = false);
    void AskForUploadFileDetails();
    void UpdateUploadFileDetails();

    //locul unde doriti sa fie salvat pe pc-ul client, numele fisierului pe server
    /**/int DownloadFile(std::string filepath, std::string filename);
    void AskForDownloandFileDetails();

    void ViewFiles();
    void AskViewFilesDetails();


    //void SwitchSetariCont() override;
    //int SchimbaParola() override;
    //int SchimbaEmail() override;

};

