#pragma once

#include "MACRO_Protocol.h"

#include <string>
#include <memory>
#include <list>

class IMessage;

class IFilesManager {

public:
    IFilesManager() { ; }
    virtual ~IFilesManager() { ; }


    virtual std::string GetClientFilePath(std::string username) = 0;
    virtual std::string GetPivateKeyFilePath() = 0;
    virtual std::string GetPublicKeyFilePath() = 0;

    virtual int Proceseaza_NewFile(IMessage* mess, std::string username, bool binary) = 0;
    virtual int Proceseaza_ReplaceFile(IMessage* mess, std::string username, bool binary) = 0;
    virtual  int Proceseaza_AppendFile(IMessage* mess, std::string username, bool binary) = 0;

    virtual std::string ReadFromFile(std::string filename, std::string detailsPath, int chunk, int* fileEnded) = 0;
    virtual int ShowAllFiles(std::string username, std::list<std::string>* lista_numeFisiere) = 0;
    virtual int ShowFilesFromMonth(std::string username, std::list<std::string>* lista_numeFisiere, std::string data = "00/00/0000") = 0;
    virtual int ShowFilesFromDay(std::string username, std::list<std::string>* lista_numeFisiere, std::string data = "00/00/0000") = 0;
    virtual int ShowFilesFromDayToPresent(std::string username, std::list<std::string>* lista_numeFisiere, std::string data = "00/00/0000") = 0;

    virtual void CreateUserFolders(std::string username) = 0;
    virtual bool checkFileExists(std::string filename, std::string username) = 0;
    virtual int DeleteUserFolders(std::string username) = 0;

    virtual std::string GetClientFileDetailsPath(std::string username) = 0;
    

};

class Factory_FilesManager {

public:
    static std::unique_ptr<IFilesManager> Create_FilesManager();
};