#pragma once

#include "MACRO_Protocol.h"

#include <string>
#include <memory>
#include <list>
#include <fstream>

class IMessage;

class IFilesManager {

public:
    IFilesManager() { ; }
    virtual ~IFilesManager() { ; }

    virtual void Set_CurrentFilepath(std::string currentFilepath) = 0;
    virtual void Set_CurrentFilename(std::string currentFilename) = 0;
    virtual std::string Get_CurrentFilepath() = 0;
    virtual std::string Get_CurrentFilename() = 0;

    //verifica daca path-ul introdus e valabil pe pc-ul client
    //daca e nevoie creeaza foldere si subfoldere
    //returneaza: true - totul a mers bine; false - nu e valida calea
    virtual bool PreparePath(std::string path) = 0;
    virtual std::string PrepareFilename(std::string path, std::string filename) = 0;

    virtual int WriteInFile(std::string filePath, std::string text, std::ios_base::openmode openmode) = 0;
    //virtual int Proceseaza_NewFile(IMessage* mess, std::string username) = 0;
    //virtual int Proceseaza_ReplaceFile(IMessage* mess, std::string username) = 0;
    //virtual  int Proceseaza_AppendFile(IMessage* mess, std::string username) = 0;

};

class Factory_FilesManager {

public:
    static std::unique_ptr<IFilesManager> Create_FilesManager();
};
