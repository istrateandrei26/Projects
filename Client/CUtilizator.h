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

    std::string m_currentFilepath;
    std::string m_currentFilename;

    void WelcomePrint() override;
    void UploadFile(bool replace = false);
    void AskForFileDetails();
    void UpdateFileDetails();
};

