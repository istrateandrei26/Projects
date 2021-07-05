#define  _CRT_SECURE_NO_WARNINGS
#include "IServer.h"
#include "ISQLDatabase_Manager.h"
#include "ICipherEngine.h"
#include "RSAEngine.h"
#include <iostream>

#define  print qDebug().noquote()
// cauta toate qt6core
//#include <QtCore/qbytearray.h>
//#include <QtCore/qstring.h>
//#include <QtCore/qdebug.h>

void main()
{
	IServer& server = Server_Headquarter::Build();
	server.Start_Server_Working();
	Server_Headquarter::destroyInstance();

	//
	//QDebug debug = qDebug();
	///*debug.noquote();
	//unique_ptr<ISQLDatabase_Manager> sqlmanager = Database_Headquarter::Deploy();
	//sqlmanager->Connect_to_SQLServerDatabase();
	//sqlmanager->Register_Client("Diaconu", "Mihai", "speedy80", "password123");
	

	unique_ptr<ICipherEngine> cipherEngine = Cipher_Headquarter::Build_AES_Engine();

	QString password = "nZr4u7x!A%D*G-KaNdRgUkXp2s5v8y/B";
	qDebug().noquote() << password;
	QByteArray plaintext = "Acest text va fi criptat";

	QByteArray encrypted1 = cipherEngine->encryptAES(password.toLatin1(), plaintext);
	qDebug().noquote() << encrypted1;

	qDebug().noquote() << cipherEngine->decryptAES(password.toLatin1(),encrypted1);


	

	


}


