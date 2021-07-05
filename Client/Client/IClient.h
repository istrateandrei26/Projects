#pragma once
#include <memory>



class IClient
{
protected:
	virtual void WSA_Startup() = 0;
	virtual void Socket_init() = 0;
	virtual void Sockaddr_init() = 0;


public:
	IClient() {}
	virtual ~IClient() {}


	virtual void Connect() = 0;

};



/* helper / client builder in order to give user/programmer no access
	to implementation header */

class Client_Builder
{
public:
	static std::unique_ptr<IClient> Get();
};
