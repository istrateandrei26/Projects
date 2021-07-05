#pragma once
#include <iostream>

#define LOGIN				"1"
#define REGISTER			"2"
#define UPLOAD_FILE			"3"
#define UPLOAD_MESSAGE		"4"
#define DOWNLOAD_FILE		"5"
#define DOWNLOAD_MESSAGE	"6"


class Protocol
{

public:
	Protocol() {}
	~Protocol() {}

	static std::string getLoginProtocol() { return LOGIN; }
	static std::string getRegisterProtocol()  { return REGISTER; }
	static std::string getUploadFileProtocol()  { return UPLOAD_FILE; }
	static std::string getUploadMessageProtocol()  { return UPLOAD_MESSAGE; }
	static std::string getDownloadFileProtocol()  { return DOWNLOAD_FILE; }
	static std::string getDownloadMessageProtocol()  { return DOWNLOAD_MESSAGE; }

};