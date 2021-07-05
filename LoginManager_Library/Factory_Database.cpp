#include "pch.h"
#include "iDatabase.h"
#include "CDatabase.h"

iDatabase* Factory_Database::Create_DatabaseInstance() {

	return new CDatabase();
}