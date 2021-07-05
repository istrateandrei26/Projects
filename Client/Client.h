#pragma once
#include "IClient.h"


#include <iostream>
#include <winsock.h>
#include <string>
#include <vector>


class Client : public IClient
{
	
public:
	Client();
	virtual ~Client();

	void Connect() override; //inainte de autentificare
	std::unique_ptr<IClient> Reconnect(int client_type, std::unique_ptr<IClient>& other) override; //imediat dupa autentificare
	void Run() override { ; }
	int Autentificare() override;

	void test() override;

protected:

	std::string m_username;
	std::string GetUsername() override { return m_username; }

	//comunciare
	int sendRequest(IMessage* mess); //se face delete la mesaj, e okay
	IMessage* receiveResponse(); //ATENTIE, tre sa faci dupa delete la mesaj

	
	//nu uita sa adaugi criptare
	//PARAMETRII: Numele pe PC-ul sursa(si calea), numele dorit la destiantie,
	//				replace == true => Nu tine cont ca un fisier cu acelasi nume exista la PC-ul destiantie si il rescrie
	//				replace == false => Daca exsiat un fiser cu acelasi nume la destinatie va returna PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST (macro_protocol)
	//RETURN: PROT_FILE_UPLOAD_RESPONSE_SUCCEDED (daca fisierul e trimis tot cu succes)
	//		  PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST (cazul discutat mai sus)
	//		  PROT_FILE_UPLOAD_RESPONSE_FAILED  (daca trimiterea a esuat)
	int sendFile(std::string filePath, std::string destinationName, bool replace = false);

private:
	int m_ClientSocket;
	struct sockaddr_in m_server;
	int m_result = 0;	
	WSADATA m_ws;

	//functiile folosite la initilizarea apolicatiei si conectarea la server
	//sunt apelate in Connect();
	void WSA_Startup();
	void Socket_init();
	void Sockaddr_init();


	//preia datele de la tastatura si verifica corectitudinea pentru conectare
	int Logare();
	//functia asat reprezinta legatura cu serverul si baza de date
	//returneaza 1 din celke 3: PROT_LOGIN_RESPONSE_ aferente (vezi Macro_protocol)
	/**/int GetLoginResponse(std::string username, std::string password);
	int ChooseAccountType(IMessage* mess);

	//preia datele de la tastatura
	//le trimite spre server
	//inregsitrare nereusita -> ramane in fereastra de inregsitrare
	//inregsitarre reusita -> revenire la fereastra de login/register 
	int Register();
	/**/int GetRegisterResponse(std::string username, std::string password, std::string email,std::string admin_cod);


	virtual void WelcomePrint() { ; }


	//***********************
	//functions for sending files
	
};