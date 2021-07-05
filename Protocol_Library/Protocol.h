#pragma once

#include <list>
#include <string>

#ifdef PROTOCOLLIBRARY_EXPORT
#define PROTOCOLBRARY_API __declspec(dllexport)
#else
#define PROTOCOLBRARY_API __declspec(dllimport)
#endif

class IMessage;

extern "C" PROTOCOLBRARY_API class Protocol
{

public:
	Protocol() { ; }
	~Protocol() { ; }

	PROTOCOLBRARY_API static int checkLoginRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkLoginRespone(IMessage* mess);
	PROTOCOLBRARY_API static int checkRegisterRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkRegisterResponse(IMessage* mess);
	//BasicResponse sunt raspunsuri cu un singur element
	PROTOCOLBRARY_API static int checkBasicResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkSendClientDataMessage(IMessage* mess);
	PROTOCOLBRARY_API static int chekUploadFileMessage(IMessage* mess);
	PROTOCOLBRARY_API static int checkViewFilesRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkViewFilesResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkDownloandFileRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkDownloandFileResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkChangePasswordRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkChangePasswordResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkChangeEmailRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkChangeEmailResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkDeleteUserRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkDeleteUserResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkViewUsersRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkViewUsersResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkPromoteUserRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkPromoteUserResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkStartServerRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkStartServerResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkShutdownServerRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkShutdownServerResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkLogoutRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkLogoutResponse(IMessage* mess);
	PROTOCOLBRARY_API static int checkAdminRequest(IMessage* mess);
	PROTOCOLBRARY_API static int checkTypeOfMessage(int type);

};

