#pragma once




class IServer
{
private:

public:
	virtual ~IServer() {}
	virtual void Start_Server_Working() = 0;
};



class Server_Headquarter
{
public:
	Server_Headquarter() = delete;
	Server_Headquarter(const Server_Headquarter&) = delete;
	static IServer& Build();
	static void destroyInstance();
};

