#pragma once
using namespace std;
#include "ICipherEngine.h"



#define KEY_LENGTH  2048
#define PUB_EXP     3



#define PADDING RSA_PKCS1_PADDING
#define KEYSIZE 32
#define IVSIZSE 32
#define BLOCKSIZE 256
#define SALTSIZE 8



class CipherEngine : public ICipherEngine
{
public:
	CipherEngine();
	virtual ~CipherEngine();



	
protected:
	/* RSA UTILS */

	size_t pri_len;				 // Length of private key
	size_t pub_len;				 // Length of public key
	char* pri_key;				 // Private key
	char* pub_key;				 // Public key
	char  msg[KEY_LENGTH / 8];   // Message to encrypt
	char* err;					 // Buffer for any error messages
	BIO* pri = NULL;
	BIO* pub = NULL;
	RSA* keypair = NULL;
	int encrypt_len;



	void writeFile(QString filename, QByteArray& data);
	QByteArray readFile(QString filename);

	void initialize();
	void finalize();
};