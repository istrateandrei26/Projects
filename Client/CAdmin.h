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
};

