#pragma once
#include "CipherEngine.h"
#include "MethodException.h"



class AESEngine : public CipherEngine
{
public:

	AESEngine() {} 
	~AESEngine() {}

	/**/

	QByteArray encryptAES(QByteArray passphrase, QByteArray& data) override;
	QByteArray decryptAES(QByteArray passphrase, QByteArray& data) override;
	QByteArray randomBytes(int size) override;

	/**/
	

private:
	void Generate_RSA_Keypair() override { throw Method_Exception(); }
	void Write_keypair_to_files(std::string privKeyFilename, std::string pubKeyFilename) override { throw Method_Exception(); }
	RSA* getPublicKey(QByteArray& data) override { throw Method_Exception(); }
	RSA* getPublicKey(QString filename) override { throw Method_Exception(); }
	RSA* getPrivateKey(QByteArray& data) override { throw Method_Exception(); }
	RSA* getPrivateKey(QString filename) override { throw Method_Exception(); }

	QByteArray encryptRSA(RSA* key, QByteArray& data) override { throw Method_Exception(); }
	QByteArray decryptRSA(RSA* key, QByteArray& data) override { throw Method_Exception(); }

	void freeRSAKey(RSA* key) override { throw Method_Exception(); }

};