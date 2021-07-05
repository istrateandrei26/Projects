#pragma once
#include "MACRO_Protocol.h"

#include <memory>
#include <string>

class IMessage;

class IClient
{

public:
	IClient() {}
	virtual ~IClient() {}

	//realizeaza conexiunea cu serverul
	virtual void Connect() = 0;
	//reface conexiunea, de data asta ca Admin/utilizator
	virtual std::unique_ptr<IClient> Reconnect(int client_type, std::unique_ptr<IClient>& other) = 0;
	virtual void TellYourUsernameToServer() = 0;
	//Alege intre LOGARE si INREGISTRARE si relizeaza operatiunea selectata de client
	//Logare nereusita -> se ramane continuu in ferestra de logare
	//Inregistrare reusita -> se revine la fereastra de login/regitser
	//Logare cu succes -> se inainteaza in program
	virtual int Autentificare() = 0;
	
	//infinite cycle
	virtual void Run() = 0;

	virtual std::string GetUsername() = 0;
};



/* helper / client builder in order to give user/programmer no access
	to implementation header */
class Client_Builder
{
public:
	static std::unique_ptr<IClient> Get();
	static std::unique_ptr<IClient> GetAdmin(std::unique_ptr<IClient>& other);
	static std::unique_ptr<IClient> GetUtilizator(std::unique_ptr<IClient>& other);
};

