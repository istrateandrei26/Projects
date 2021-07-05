#pragma once
#include "IFilesManager.h"
class CFilesManager :
    public IFilesManager
{

public:
    CFilesManager() { ; }
    ~CFilesManager() { ; }

    void Set_CurrentFilepath(std::string currentFilepath) override;
    void Set_CurrentFilename(std::string currentFilename) override;
    std::string Get_CurrentFilepath() override { return m_currentFilepath; }
    std::string Get_CurrentFilename() override { return m_currentFilename; }

    bool PreparePath(std::string path) override;
    std::string PrepareFilename(std::string path, std::string filename) override;

    int WriteInFile(std::string filePath, std::string text, std::ios_base::openmode openmode) override;
private:
    std::string m_currentFilepath;
    std::string m_currentFilename;

    void LastCharOfPath(std::string* path);
};

