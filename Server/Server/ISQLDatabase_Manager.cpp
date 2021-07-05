#include "SQLDatabase_Manager.h"

unique_ptr<ISQLDatabase_Manager> Database_Headquarter::Deploy()
{
    return make_unique<SQLDatabase_Manager>();
}
