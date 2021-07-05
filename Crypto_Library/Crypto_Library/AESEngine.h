#pragma once
#include "CipherEngine.h"
#include "Exception_Method.h"



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
	void Generate_RSA_Keypair() override { throw Exception_Method(); }
	void Write_keypair_to_files(std::string privKeyFilename, std::string pubKeyFilename) override { throw Exception_Method(); }
	RSA* getPublicKey(QByteArray& data) override { throw Exception_Method(); }
	RSA* getPublicKey(QString filename) override { throw Exception_Method(); }
	RSA* getPrivateKey(QByteArray& data) override { throw Exception_Method(); }
	RSA* getPrivateKey(QString filename) override { throw Exception_Method(); }

	QByteArray encryptRSA(RSA* key, QByteArray& data) override { throw Exception_Method(); }
	QByteArray decryptRSA(RSA* key, QByteArray& data) override { throw Exception_Method(); }

	void freeRSAKey(RSA* key) override { throw Exception_Method(); }

};