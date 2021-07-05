#pragma once
#include "IMessage.h"


class CMessage :
    public IMessage
{
public:
    //initializeaza un mesaj gol pe baza tipului (login/register/send file/etc)
    CMessage(int type);
    //initilizeaza un mesaj pe baza unui sir de caractere care respecta tiparul unui mesaj
    //folosit pentru reconstruirea mesajului dupa transmiterea in retea
    CMessage(char* message); 
    ~CMessage();

    int GetType() override { return m_type; }
    std::string GetTheMessage() override { return m_message; }
    std::list<std::string> GetElementsOfMessage();
    bool isEnded() override { return m_ended; }

    void Add(std::string message) override;
    void Add(std::list<std::string> messages_list) override;
    void Add_EndOfMessage() override;

protected:
    std::string m_message;
    bool m_ended;
    int m_type;
    

};



