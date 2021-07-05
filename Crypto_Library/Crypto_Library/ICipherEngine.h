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

#ifdef CRYPTOLIBRARY_EXPORTS
#define CRYPTOLIBRARY_API __declspec(dllexport)
#else
#define CRYPTOLIBRARY_API __declspec(dllimport)
#endif


extern "C" CRYPTOLIBRARY_API class ICipherEngine
{
public:
	ICipherEngine() {}
	virtual ~ICipherEngine() {}


	/* RSA oriented methods */
	CRYPTOLIBRARY_API virtual void Generate_RSA_Keypair() = 0;								// generates RSA keypair 
	CRYPTOLIBRARY_API virtual void Write_keypair_to_files(std::string privKeyFilename, std::string pubKeyFilename) = 0;		    // writes public key and private key to separate files

	CRYPTOLIBRARY_API virtual RSA* getPublicKey(QByteArray& data) = 0;
	CRYPTOLIBRARY_API virtual RSA* getPublicKey(QString filename) = 0;

	CRYPTOLIBRARY_API virtual RSA* getPrivateKey(QByteArray& data) = 0;
	CRYPTOLIBRARY_API virtual RSA* getPrivateKey(QString filename) = 0;

	CRYPTOLIBRARY_API virtual QByteArray encryptRSA(RSA* key, QByteArray& data) = 0;
	CRYPTOLIBRARY_API virtual QByteArray decryptRSA(RSA* key, QByteArray& data) = 0;


	CRYPTOLIBRARY_API virtual void freeRSAKey(RSA* key) = 0;
	//

	/* AES oriented methods*/
	CRYPTOLIBRARY_API virtual QByteArray encryptAES(QByteArray passphrase, QByteArray& data) = 0;
	CRYPTOLIBRARY_API virtual QByteArray decryptAES(QByteArray passphrase, QByteArray& data) = 0;

	CRYPTOLIBRARY_API virtual QByteArray randomBytes(int size) = 0;


};




extern "C" CRYPTOLIBRARY_API class Cipher_Headquarter
{
public:
	Cipher_Headquarter() = delete;
	Cipher_Headquarter(const Cipher_Headquarter&) = delete;
	CRYPTOLIBRARY_API static unique_ptr<ICipherEngine> Build_RSA_Engine();
	CRYPTOLIBRARY_API static unique_ptr<ICipherEngine> Build_AES_Engine();
};