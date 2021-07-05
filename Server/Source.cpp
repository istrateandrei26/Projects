#define  _CRT_SECURE_NO_WARNINGS
#include "IServer.h"
#include <iostream>
#include <ICipherEngine.h>
#include "QtCore/qdebug.h"
#include "QtCore/qbytearray.h"
#include "QtCore/qstring.h"
#include <string>
#include "MACRO_Message.h"
#include "IFilesManager.h"

#define  print qDebug().noquote()
void main()
{
	IServer& server = Server_Headquarter::Build();
	server.Start_Server_Working();
	Server_Headquarter::destroyInstance();
	

	/*std::unique_ptr<IFilesManager> files = Factory_FilesManager::Create_FilesManager();

	std::unique_ptr<ICipherEngine> engine = Cipher_Headquarter::Build_RSA_Engine();
	engine->Generate_RSA_Keypair();
	engine->Write_keypair_to_files(files->GetPivateKeyFilePath(), files->GetPublicKeyFilePath());
	RSA* pubkey = engine->getPublicKey(files->GetPublicKeyFilePath().c_str());
	RSA* privkey = engine->getPrivateKey(files->GetPivateKeyFilePath().c_str());
	QByteArray plaintext1 = "Andrei";
	QByteArray plaintext2 = "Andrei";
	plaintext1 = engine->encryptRSA(pubkey, plaintext1);
	plaintext2 = engine->encryptRSA(pubkey, plaintext2);
	qDebug() << plaintext1.toBase64();
	qDebug() << plaintext2.toBase64();

	plaintext1 = engine->decryptRSA(privkey, plaintext1);
	qDebug().noquote() << plaintext1;*/

	/*QByteArray info2;
	info.append(newPass);
	QByteArray encrypted_new_password = m_AES_engine->encryptAES(HASH, info2);
	encrypted_new_password = encrypted_new_password.toBase64();

	QByteArray info3;
	info3.append(encrypted_new_password.data());
	info3 = info3.fromBase64(info3);
	QByteArray decrypted = m_AES_engine->decryptAES(HASH, info3);*/



	/*unique_ptr<ICipherEngine> cipherEngine = Cipher_Headquarter::Build_AES_Engine();
	QByteArray data;
	QFile file("Log.txt");
	if (!file.open(QFile::ReadOnly))
	{
		std::cout << "Error";
	}
	data = file.readAll();
	file.close();
	std::cout << data.length() << std::endl;*/

	//std::cout << data.length() << std::endl;
	///*cipherEngine->Generate_RSA_Keypair();
	//cipherEngine->Write_keypair_to_files("privkey.txt", "pubkey.txt");
	//RSA* pubkey = cipherEngine->getPublicKey("pubkey.txt");
	//RSA* privkey = cipherEngine->getPrivateKey("privkey.txt");*/

	/*data = cipherEngine->encryptAES(HASH, data);
	std::cout << data.toBase64().length() << std::endl;
	data = data.toBase64();

	data = data.fromBase64(data);
	data = cipherEngine->decryptAES(HASH, data);
	std::cout << data.length() << std::endl;*/


	/*QString password = "nZr4u7x!A%D*G-KaNdRgUkXp2s5v8y/B";
	//qDebug().noquote() << password;
	QByteArray plaintext = "Acest text va fi criptat";

	
	cipherEngine->Generate_RSA_Keypair();
	cipherEngine->Write_keypair_to_files("privkey.txt", "pubkey.txt");
	RSA* pubkey = cipherEngine->getPublicKey("pubkey.txt");
	RSA* privkey = cipherEngine->getPrivateKey("privkey.txt");


	QByteArray encrypted = cipherEngine->encryptRSA(pubkey, plaintext);
	qDebug().noquote() << encrypted;


	QByteArray decrypted = cipherEngine->decryptRSA(privkey, encrypted);
	qDebug().noquote() << decrypted;

	*/
	//QByteArray name = "andrei";
	//std::string name2 = name.constData();
	QByteArray encrypted_text;
	QByteArray decrypted_text;
	/*std::unique_ptr<ICipherEngine> engine = Cipher_Headquarter::Build_RSA_Engine();
	engine->Generate_RSA_Keypair();
	engine->Write_keypair_to_files("privkey.txt", "pubkey.txt");
	RSA* pubkey = engine->getPublicKey("pubkey.txt");
	RSA* privkey = engine->getPrivateKey("privkey.txt");
	QByteArray plaintext1 = "Andrei";
	QByteArray plaintext2 = "Andrei";
	plaintext1 = engine->encryptRSA(pubkey, plaintext1);
	plaintext2 = engine->encryptRSA(pubkey, plaintext2);
	qDebug() << plaintext1.toBase64();
	qDebug() << plaintext2.toBase64();
	*/








	std::unique_ptr<IFilesManager> files = Factory_FilesManager::Create_FilesManager();
	std::unique_ptr<ICipherEngine> engine = Cipher_Headquarter::Build_AES_Engine();
	
	
	QByteArray private_key = "This key is our choice . It can be everything";

	QByteArray plaintext = "We have to prove that this is real";         // text to encrypt ...

	print << "Plaintext :" << plaintext;
	encrypted_text = engine->encryptAES(private_key,plaintext);
	
	print << "\nEncrypted text (ciphertext) :" << encrypted_text;
	
	decrypted_text = engine->decryptAES(private_key, encrypted_text);

	print << "\nDecrypted text (plaintext again) :" << decrypted_text;




















	getchar();


}


