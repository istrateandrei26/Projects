#include "pch.h"
#include "Log.h"
#include "Log_Database.h"
#include "Log_LoginManager.h"
#include "Log_ChiperEngine.h"
#include "Log_Protocol.h"
#include "Log_Server.h"
#include "Log_Client.h"
#include "Log_Exceptions.h"


ILog* Log_Factory::Create_Logger(int type, const char* filename) {

	switch (type)
	{
	case L_Database:
		return new Log_Database();

	case L_LoginManager:
		return new Log_LoginManager();

	case L_ChiperEngine:
		return new Log_ChiperEngine();

	case L_Protocol:
		return new Log_Protocol();

	case L_Server:
		return new Log_Server();

	case L_Client:
		return new Log_Client();

	case L_Exceptions:
		return new Log_Exceptions();


	default:
		return nullptr;
		break;

	}
}