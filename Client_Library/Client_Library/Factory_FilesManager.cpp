#include "pch.h"
#include "IFilesManager.h"
#include  "CFilesManager.h"

std::unique_ptr<IFilesManager> Factory_FilesManager::Create_FilesManager() {

	return std::make_unique<CFilesManager>();
}