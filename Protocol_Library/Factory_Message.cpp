#include "pch.h"
#include "IMessage.h"
#include "CMessage.h"

IMessage* Factory_Message::Create_Message(int type) {

	return new CMessage(type);
}
IMessage* Factory_Message::Create_Message(char* message) {

	return new CMessage(message);
}