#pragma once
#include "pch.h"
#include "MACRO_Protocol.h"

#include <memory>
#include <string>
#include <list>

#ifdef CLIENTLIBRARY_EXPORTS
#define CLIENTLIBRARY_API __declspec(dllexport)
#else
#define CLIENTLIBRARY_API __declspec(dllimport)
#endif

extern "C" CLIENTLIBRARY_API class IMessage;

extern "C" CLIENTLIBRARY_API class IClient
{

public:
	IClient() {}
	virtual ~IClient() {}

	//realizeaza conexiunea cu serverul
	CLIENTLIBRARY_API virtual void Connect() = 0;
	//reface conexiunea, de data asta ca Admin/utilizator
	CLIENTLIBRARY_API virtual std::unique_ptr<IClient> Reconnect(int client_type, std::unique_ptr<IClient>& other) = 0;
	CLIENTLIBRARY_API virtual void TellYourUsernameToServer() = 0;
	//Alege intre LOGARE si INREGISTRARE si relizeaza operatiunea selectata de client
	//Logare nereusita -> se ramane continuu in ferestra de logare
	//Inregistrare reusita -> se revine la fereastra de login/regitser
	//Logare cu succes -> se inainteaza in program
    CLIENTLIBRARY_API virtual int Autentificare(char option) = 0;

	CLIENTLIBRARY_API virtual int Logare(std::string username, std::string password) = 0;
	CLIENTLIBRARY_API virtual int Register(std::string username, std::string password, std::string email, std::string cod_admin) = 0;
	CLIENTLIBRARY_API virtual int changePassword(std::string newPassword, std::string oldPassword = "none") = 0;
	CLIENTLIBRARY_API virtual int changeEmail(std::string newEmail) = 0;
	CLIENTLIBRARY_API virtual int LogOut() = 0;

	CLIENTLIBRARY_API virtual int sendFile(std::string filePath, std::string destinationName, bool replace = false) = 0;
	CLIENTLIBRARY_API virtual int getFiles(int mod, std::list<std::string>* listaFisiere, std::string data = "00/00/0000", std::string* username = NULL) = 0;
	

	// common user oriented methods
	CLIENTLIBRARY_API virtual void UploadFile(bool replace = false) = 0;
	CLIENTLIBRARY_API virtual void AskForUploadFileDetails() = 0;
	CLIENTLIBRARY_API virtual void UpdateUploadFileDetails() = 0;

	// admin oriented methods
	CLIENTLIBRARY_API virtual int AdminGetUsers(std::list<std::string>* list_users) = 0;
	CLIENTLIBRARY_API virtual void AdminViewUsers() = 0;

	CLIENTLIBRARY_API virtual void AdminViewFiles() = 0;
	CLIENTLIBRARY_API virtual void AdminAskViewFilesDetails() = 0;

	CLIENTLIBRARY_API virtual int AdminDeleteUser(std::string username = "") = 0;
	CLIENTLIBRARY_API virtual void AdminAskDeleteUserDetails() = 0;

	CLIENTLIBRARY_API virtual int AdminPromoteUser(std::string username, int mod) = 0;
	CLIENTLIBRARY_API virtual void AdminAskPromoteUserDetails() = 0;

	CLIENTLIBRARY_API virtual int AdminShutdownServer() = 0;
	CLIENTLIBRARY_API virtual int AdminStartServer() = 0;

	CLIENTLIBRARY_API virtual int AdminCheckIfAdmin(std::string username) = 0;

	//locul unde doriti sa fie salvat pe pc-ul client, numele fisierului pe server
	CLIENTLIBRARY_API virtual int DownloadFile(std::string filepath, std::string filename) = 0;
	CLIENTLIBRARY_API virtual void AskForDownloandFileDetails() = 0;

	CLIENTLIBRARY_API virtual void ViewFiles() = 0;
	CLIENTLIBRARY_API virtual void AskViewFilesDetails() = 0;


	//infinite cycle
	CLIENTLIBRARY_API virtual void Run() = 0;

	CLIENTLIBRARY_API virtual std::string GetUsername() = 0;

	CLIENTLIBRARY_API virtual int sendBinaryFile(std::string filePath, std::string destinationName, bool replace) = 0;


};



/* helper / client builder in order to give user/programmer no access
	to implementation header */
extern "C" CLIENTLIBRARY_API class Client_Builder
{
public:
	CLIENTLIBRARY_API static std::unique_ptr<IClient> Get();
	CLIENTLIBRARY_API static std::unique_ptr<IClient> GetAdmin(std::unique_ptr<IClient>& other);
	CLIENTLIBRARY_API static std::unique_ptr<IClient> GetUtilizator(std::unique_ptr<IClient>& other);
};

