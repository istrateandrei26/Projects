#pragma once
#include "IFilesManager.h"

#include <fstream>

class CFilesManager :
    public IFilesManager
{
public:
    CFilesManager();
    ~CFilesManager() { ; }

    std::string GetClientFilePath(std::string username) override;
    std::string GetPivateKeyFilePath() override;
    std::string GetPublicKeyFilePath() override;

    int Proceseaza_NewFile(IMessage* mess, std::string username, bool binary) override;
    int Proceseaza_ReplaceFile(IMessage* mess, std::string username, bool binary) override;
    int Proceseaza_AppendFile(IMessage* mess, std::string username, bool binary) override;

    //citeste din fisierul filename un numar de caractere egal cu number_of_char
    //daca se precizeaza un poztie de start prin pozitie_cursor, se va citi de acolo
    //si se va retine in pozitie_cursor si pana la ce pozitie s-a citit mai exact
    // in fileEnded se returneaza: 
            // 1  -- daca fisierul a ajuns la sfarsit in urma citirii
            // 0 -- daca inca nu s-a ajuns la sfarsit
    std::string ReadFromFile(std::string filename, std::string detailsPath, int chunk, int* fileEnded) override;

    //in lista_numaFisiere se va returna i lista cu numele tuturor fisierelor ce respecta conditia
    int ShowAllFiles(std::string username, std::list<std::string>* lista_numeFisiere) override;
    int ShowFilesFromMonth(std::string username, std::list<std::string>* lista_numeFisiere, std::string data = "00/00/0000") override;
    int ShowFilesFromDay(std::string username, std::list<std::string>* lista_numeFisiere, std::string data = "00/00/0000") override;
    int ShowFilesFromDayToPresent(std::string username, std::list<std::string>* lista_numeFisiere, std::string data = "00/00/0000") override;

    void CreateUserFolders(std::string username) override;
    bool checkFileExists(std::string filename, std::string username)  override;
    int DeleteUserFolders(std::string username) override;

    std::string GetClientFileDetailsPath(std::string username) override;

private:
    std::string m_privateKeyFilename;
    std::string m_publicKeyFilename;
    std::string m_keysPath;
    std::string m_storagePath;
    std::string m_filesFolderName;
    std::string m_fileDetailsFolderName;   // 

    void WriteInFile(std::string filePath, std::string detailsFilePath, std::string text, std::ios_base::openmode openmode, bool binary);

    std::string GetFilenameFromPath(std::string path);

    //cu tot cu path complet
    struct tm GetFileLastTimeModified(std::string filename);

    //resultat de forma: DD/MM/YYYY
    //ca sa putem compara linstiti cu data din care vrea clinetul sa vada fisierele
    std::string TimeStructureToString(struct tm structureTime);

    long long int GetChunkPositions(std::string detailsPath, int chunk, int& lenght, int& number_ofEndOfLine);

};

