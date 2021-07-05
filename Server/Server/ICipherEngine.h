#pragma once
using namespace std;
#include "openssl/rsa.h"
#include "openssl/engine.h"
#include "openssl/pem.h"
#include "openssl/conf.h"
#include "openssl/evp.h"
#include "openssl/err.h"
#include "openssl/aes.h"
#include "openssl/rand.h"
#include "openssl/ssl.h"
#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <stdio.h>
#include <string.h>
#include <QtCore/qbytearray.h>
#include <QtCore/qstring.h>
#include <QtCore/qfile.h>
#include <QtCore/qdebug.h>

class ICipherEngine
{
public:
	ICipherEngine() {}
	virtual ~ICipherEngine() {}


	/* RSA oriented methods */
	virtual void Generate_RSA_Keypair() = 0 ;								// generates RSA keypair 
	virtual void Write_keypair_to_files(std::string privKeyFilename,std::string pubKeyFilename) = 0;		    // writes public key and private key to separate files

	virtual RSA* getPublicKey(QByteArray& data) = 0;
	virtual RSA* getPublicKey(QString filename) = 0;

	virtual RSA* getPrivateKey(QByteArray& data) = 0;
	virtual RSA* getPrivateKey(QString filename) = 0;
	
	virtual QByteArray encryptRSA(RSA* key, QByteArray& data) = 0;
	virtual QByteArray decryptRSA(RSA* key, QByteArray& data) = 0;


	virtual void freeRSAKey(RSA* key) = 0;
	//

	/* AES oriented methods*/
	virtual QByteArray encryptAES(QByteArray passphrase, QByteArray& data) = 0;
	virtual QByteArray decryptAES(QByteArray passphrase, QByteArray& data) = 0;

	virtual QByteArray randomBytes(int size) = 0;

	
};




class Cipher_Headquarter
{
public:
	Cipher_Headquarter() = delete;
	Cipher_Headquarter(const Cipher_Headquarter&) = delete;
	static unique_ptr<ICipherEngine> Build_RSA_Engine();
	static unique_ptr<ICipherEngine> Build_AES_Engine();
};