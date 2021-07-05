#include "pch.h"
#include "Protocol.h"
#include "IMessage.h"
#include "MACRO_Protocol.h"
#include "QtCore/qDebug"

int Protocol::checkLoginRequest(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	if (mess->GetType() != PROT_LOGIN_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	auto it = elements.begin();
	if (*it != std::to_string(PROT_LOGIN_REQUEST))
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	//verificam sa aiba numarul corect de elemente
	//tip_user_pass_endOfMessage => 4
	if (elements.size() != PROT_Login_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkLoginRespone(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_LOGIN_RESPONSE_ADMIN && type != PROT_LOGIN_RESPONSE_UTILIZATOR && type != PROT_LOGIN_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	auto it = elements.begin();
	if (*it != std::to_string(type))
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	//verificam sa aiba numarul corect de elemente
	//tip_endOfMessage => 2
	if (elements.size() != PROT_Login_Response_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkRegisterRequest(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	if (mess->GetType() != PROT_REGISTER_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	auto it = elements.begin();
	if (*it != std::to_string(PROT_REGISTER_REQUEST))
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	//verificam sa aiba numarul corect de elemente
	if (elements.size() != PROT_Register_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkRegisterResponse(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_REGISTER_RESPONSE_SUCCEDED && type != PROT_REGISTER_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	auto it = elements.begin();
	if (*it != std::to_string(type))
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	//verificam sa aiba numarul corect de elemente
	//tip_endOfMessage => 2
	if (elements.size() != PROT_Login_Response_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkBasicResponse(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (checkTypeOfMessage(type) != PROT_SUCCEDED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (checkTypeOfMessage(type) != PROT_SUCCEDED)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	//verificam sa aiba numarul corect de elemente
	//tip_endOfMessage => 2
	if (elements.size() != PROT_BasicResponse_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkSendClientDataMessage(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_SEND_CLIENT_DATA)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_SEND_CLIENT_DATA)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	//verificam sa aiba numarul corect de elemente
	//tip_endOfMessage => 2
	if (elements.size() != PROT_Send_Client_Data_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::chekUploadFileMessage(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_FILE_UPLOAD_REQUEST && type != PROT_BINARY_FILE_UPLOAD_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_FILE_UPLOAD_REQUEST && type != PROT_BINARY_FILE_UPLOAD_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	//verificam modul de deschidere a fisierului
	it = elements.begin();
	it++;
	type = atoi(it->c_str());
	if (type != PROT_FILE_NEW && type != PROT_FILE_APPEND && type != PROT_FILE_REPLACE)
		return PROT_ERROR_InvalidMessage;

	//verificam sa aiba numarul corect de elemente
	//tip_endOfMessage => 2
	if (elements.size() != PROT_File_Upload_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkViewFilesRequest(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_VIEW_FILES_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_VIEW_FILES_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	//verificam modul de deschidere a fisierului
	it = elements.begin();
	it++;
	type = atoi(it->c_str());
	if (type < PROT_VIEW_FILE_ALL || type > PROT_VIEW_FILE_FROM_DAY_ToPRESENT)
		return PROT_ERROR_InvalidMessage;

	//verificam sa aiba numarul corect de elemente
	//tip_endOfMessage => 2
	if (elements.size() != PROT_View_file_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkViewFilesResponse(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_VIEW_FILE_RESPONSE_SUCCEDED && type != PROT_VIEW_FILE_RESPONSE_USERNAME_NoEXIST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_VIEW_FILE_RESPONSE_SUCCEDED && type != PROT_VIEW_FILE_RESPONSE_USERNAME_NoEXIST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	if (elements.size() < PROT_BasicResponse_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkDownloandFileRequest(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_FILE_DOWNLOAND_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_FILE_DOWNLOAND_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_File_Downloand_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkDownloandFileResponse(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_FILE_DOWNLOAND_RESPONE_NoEXIST && type != PROT_FILE_DOWNLOAND_RESPONSE_SUCCEDED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_FILE_DOWNLOAND_RESPONE_NoEXIST && type != PROT_FILE_DOWNLOAND_RESPONSE_SUCCEDED)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_File_Downloand_Response_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkChangePasswordRequest(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_CHANGE_PASSWORD_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_CHANGE_PASSWORD_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;
	

	if (elements.size() != PROT_Change_Password_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkChangePasswordResponse(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type < PROT_CHANGE_PASSWORD_RESPONSE_SUCCEDED || type > PROT_CHANGE_PASSWORD_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type < PROT_CHANGE_PASSWORD_RESPONSE_SUCCEDED || type > PROT_CHANGE_PASSWORD_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_BasicResponse_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkChangeEmailRequest(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_CHANGE_EMAIL_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_CHANGE_EMAIL_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_Change_Email_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkChangeEmailResponse(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_CHANGE_EMAIL_RESPONSE_SUCCEDED && type != PROT_CHANGE_EMAIL_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_CHANGE_EMAIL_RESPONSE_SUCCEDED && type != PROT_CHANGE_EMAIL_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_BasicResponse_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkDeleteUserRequest(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_DELETE_USER_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_DELETE_USER_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_Delete_User_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkDeleteUserResponse(IMessage* mess)
{
	return PROT_SUCCEDED; // to do here
}
int Protocol::checkViewUsersRequest(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_VIEW_USERS_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_VIEW_USERS_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_View_Users_Request_Eelements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkViewUsersResponse(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_VIEW_USERS_RESPONSE_SUCCEDED && type != PROT_VIEW_USERS_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_VIEW_USERS_RESPONSE_SUCCEDED && type != PROT_VIEW_USERS_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() < PROT_BasicResponse_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}
int Protocol::checkPromoteUserRequest(IMessage* mess) {

	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_PROMOTE_USER_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_PROMOTE_USER_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_Promote_User_Request)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}

int Protocol::checkPromoteUserResponse(IMessage* mess)
{
	return PROT_SUCCEDED;
}

int Protocol::checkStartServerRequest(IMessage* mess)
{
	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_START_SERVER_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();
	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_START_SERVER_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	if (elements.size() != PROT_Start_Server_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;

}

int Protocol::checkStartServerResponse(IMessage* mess)
{
	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_START_SERVER_RESPONSE_SUCCEDED && type != PROT_START_SERVER_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_START_SERVER_RESPONSE_SUCCEDED && type != PROT_START_SERVER_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_BasicResponse_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}

int Protocol::checkShutdownServerRequest(IMessage* mess)
{
	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_SHUTDOWN_SERVER_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();
	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_SHUTDOWN_SERVER_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	if (elements.size() != PROT_Shutdown_Server_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}

int Protocol::checkShutdownServerResponse(IMessage* mess)
{
	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type !=PROT_SHUTDOWN_SERVER_RESPONSE_SUCCEDED && type != PROT_SHUTDOWN_SERVER_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_SHUTDOWN_SERVER_RESPONSE_SUCCEDED && type != PROT_SHUTDOWN_SERVER_RESPONSE_FAILED)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_BasicResponse_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}

int Protocol::checkLogoutRequest(IMessage* mess)
{
	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_LOGOUT_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();
	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_LOGOUT_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	if (elements.size() != PROT_Logout_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}

int Protocol::checkLogoutResponse(IMessage* mess)
{
	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_LOGOUT_RESPONSE_FAILED && type != PROT_LOGOUT_RESPONSE_SUCCEDED)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();

	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_LOGOUT_RESPONSE_FAILED && type != PROT_LOGOUT_RESPONSE_SUCCEDED)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;


	if (elements.size() != PROT_BasicResponse_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}

int Protocol::checkAdminRequest(IMessage* mess)
{
	if (!mess->isEnded())
		return PROT_ERROR_NoEndOfMessage;
	int type = mess->GetType();
	if (type != PROT_CHECK_ADMIN_REQUEST)
		return PROT_ERROR_InvalidType;

	std::list<std::string> elements = mess->GetElementsOfMessage();
	// verificiam tipul
	type = atoi((elements.begin()->c_str()));
	if (type != PROT_CHECK_ADMIN_REQUEST)
		return PROT_ERROR_InvalidType;

	//verificam sa aiba sfarsitul de mesaj
	auto it = elements.end();
	it--;
	if (*it != MESS_EndOfMessage)
		return PROT_ERROR_NoEndOfMessage;

	if (elements.size() != PROT_Check_Admin_Request_Elements)
		return PROT_ERROR_InvalidMessage;

	return PROT_SUCCEDED;
}


int Protocol::checkTypeOfMessage(int type) {

	if (type < PROT_FAILED || type > PROT_RESPONSE_LastID)
		return PROT_ERROR_InvalidType;
	return PROT_SUCCEDED;
}