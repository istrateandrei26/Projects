#pragma once

#include <list>
#include <string>

#ifdef PROTOCOLLIBRARY_EXPORT
#define PROTOCOLBRARY_API __declspec(dllexport)
#else
#define PROTOCOLBRARY_API __declspec(dllimport)
#endif

//un mesaj va avea forma urmatoare:
// [PROTOCOL ID]_[ELEMENT]_[ELEMENT}_ .... _[END OF MESSAGE]
//Elementele sunt siruri de caractere
// '_' reprezinta separatorul dintre elemente


//ATENITE
//daca se adauga [END OF MESSAGE] iar apoi se mai adauga elemente,
//aceste elemente in plus vor fi ignorate

extern "C" PROTOCOLBRARY_API class IMessage {

public:
	IMessage() { ; }
	virtual ~IMessage() { ; }

	PROTOCOLBRARY_API virtual int GetType() = 0;
	PROTOCOLBRARY_API virtual std::string GetTheMessage() = 0;
	PROTOCOLBRARY_API virtual std::list<std::string> GetElementsOfMessage() = 0;
	PROTOCOLBRARY_API virtual bool isEnded() = 0;

	//adauga un element in continuarea mesajului
	PROTOCOLBRARY_API virtual void Add(std::string message) = 0;
	//sterge continutul measjului (exceptand tipul acestuia)
	//si adauga elementele din lista data ca parametru
	//se adauga si finalul de mesaj
	//practic construieste un mesaj ce nu va mai putea fi modificat
	PROTOCOLBRARY_API virtual void Add(std::list<std::string> messages_list) = 0;
	
	//adauga sfarsitul mesajului
	PROTOCOLBRARY_API virtual void Add_EndOfMessage() = 0;


	

};

extern "C" PROTOCOLBRARY_API class Factory_Message {

public:
	PROTOCOLBRARY_API static IMessage* Create_Message(char* message);
	PROTOCOLBRARY_API static IMessage* Create_Message(int type);
};