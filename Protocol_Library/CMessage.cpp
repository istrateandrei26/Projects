#define _CRT_SECURE_NO_WARNINGS

#include "pch.h"
#include "CMessage.h"
#include "MACRO_Protocol.h"
#include "Protocol.h"
#include "Exception_Protocol.h"

#include <sstream>

CMessage::CMessage(int type) {


	if (PROT_SUCCEDED != Protocol::checkTypeOfMessage(type)) {

		throw new Exception_Protocol("Invalid type of message!");
	}

	m_message = std::to_string(type);
	m_type = type;
	m_ended = false;
}

//!!!!!!!!!
//! //!!!!!!!!!!!!!!!
//! !!!!!!!!!!!!!!!!!!!!
//! verificari!!!
CMessage::CMessage(char* message) {

	m_ended = false;

	char* delim = (char*)malloc(sizeof(char) * 2);
	delim[0] = MESS_SEPARATOR;
	delim[1] = '\0';

	char* token = strtok(message, "+");
	if (token == nullptr)
		throw new Exception_Protocol("Invalid type of message!");

	int type = atoi(token);
	if (PROT_SUCCEDED != Protocol::checkTypeOfMessage(type))
		throw new Exception_Protocol("Invalid type of message!");
	else
		this->m_type = type;

	this->Add(token);
	token = strtok(NULL, "+");
	while (token) {

		this->Add(token);
		token = strtok(NULL, "+");
	}

	m_ended = true;

	free(delim);
}
CMessage::~CMessage() {

}

std::list<std::string> CMessage::GetElementsOfMessage() {

	std::list<std::string> result;
	std::istringstream iss(m_message);
	std::string token;
	while (std::getline(iss, token, MESS_SEPARATOR)) {

		result.push_back(token);
	}

	return result;
}

void CMessage::Add(std::string message) {

	if (m_ended)
		return;
	if (m_message.empty())
		m_message += message;
	else
		m_message += MESS_SEPARATOR + message;
}
void CMessage::Add(std::list<std::string> messages_list) {

	for (auto it = messages_list.begin(); it != messages_list.end(); it++) {

		this->Add(*it);
	}
	this->Add_EndOfMessage();
}
void CMessage::Add_EndOfMessage() {

	m_message += MESS_SEPARATOR;
	m_message += MESS_EndOfMessage;
	m_ended = true;
}