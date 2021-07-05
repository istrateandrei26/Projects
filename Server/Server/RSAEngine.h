#pragma once
#include "CipherEngine.h"
#include "MethodException.h"



class RSAEngine : public CipherEngine
{

public:
	RSAEngine() {}
	~RSAEngine() {}


	/**/
	RSA* getPublicKey(QByteArray& data) override;
	RSA* getPublicKey(QString filename) override;

	RSA* getPrivateKey(QByteArray& data) override;
	RSA* getPrivateKey(QString filename) override;

	QByteArray encryptRSA(RSA* key, QByteArray& data) override;
	QByteArray decryptRSA(RSA* key, QByteArray& data) override;

	void freeRSAKey(RSA* key) override;

	/**/

	void Generate_RSA_Keypair() override;
	void Write_keypair_to_files(std::string privKeyFilename, std::string pubKeyFilename) override;


private:
	QByteArray encryptAES(QByteArray passphrase, QByteArray& data) override { throw Method_Exception(); }
	QByteArray decryptAES(QByteArray passphrase, QByteArray& data) override { throw Method_Exception(); }
	QByteArray randomBytes(int size) override { throw Method_Exception(); }
};