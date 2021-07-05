#include "pch.h"
#define _CRT_SECURE_NO_WARNINGS
#include "RSAEngine.h"


void RSAEngine::Generate_RSA_Keypair()
{
	// Generate key pair
	this->keypair = RSA_generate_key(KEY_LENGTH, PUB_EXP, NULL, NULL);

}

void RSAEngine::Write_keypair_to_files(std::string privKeyFilename, std::string pubKeyFilename)
{

	// To get PEM form:
	this->pri = BIO_new(BIO_s_mem());
	this->pub = BIO_new(BIO_s_mem());

	PEM_write_bio_RSAPrivateKey(pri, keypair, NULL, NULL, 0, NULL, NULL);
	PEM_write_bio_RSAPublicKey(pub, keypair);

	this->pri_len = BIO_pending(pri);
	this->pub_len = BIO_pending(pub);

	this->pri_key = (char*)malloc(pri_len + 1);
	this->pub_key = (char*)malloc(pub_len + 1);

	BIO_read(pri, pri_key, pri_len);
	BIO_read(pub, pub_key, pub_len);

	this->pri_key[pri_len] = '\0';
	this->pub_key[pub_len] = '\0';
	FILE* privatekeyfile = fopen(privKeyFilename.c_str(), "w");
	if (!privatekeyfile)
	{
		std::cout << "ERROR" << std::endl;
		return;
	}
	fprintf(privatekeyfile, pri_key);

	FILE* publickeyfile = fopen(pubKeyFilename.c_str(), "w");
	if (!publickeyfile)
	{
		std::cout << "ERROR" << std::endl;
		return;
	}
	fprintf(publickeyfile, pub_key);

	fclose(privatekeyfile);
	fclose(publickeyfile);


}


RSA* RSAEngine::getPublicKey(QByteArray& data)
{
	const char* publicKeyStr = data.constData();
	BIO* bio = BIO_new_mem_buf((void*)publicKeyStr, -1);
	BIO_set_flags(bio, BIO_FLAGS_BASE64_NO_NL);

	RSA* rsaPubKey = PEM_read_bio_RSAPublicKey(bio, NULL, NULL, NULL);
	if (!rsaPubKey)
	{
		std::cout << "[CRYPTO][-] Could not load public key" << std::endl;
	}
	BIO_free(bio);
	return rsaPubKey;
}

RSA* RSAEngine::getPublicKey(QString filename)
{
	QByteArray data = readFile(filename);
	return getPublicKey(data);
}

RSA* RSAEngine::getPrivateKey(QByteArray& data)
{
	const char* privateKeyStr = data.constData();
	BIO* bio = BIO_new_mem_buf((void*)privateKeyStr, -1);
	BIO_set_flags(bio, BIO_FLAGS_BASE64_NO_NL);

	RSA* rsaPrivKey = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);
	if (!rsaPrivKey)
	{
		std::cout << "[CRYPTO][-] Could not load private key" << std::endl;
	}
	BIO_free(bio);
	return rsaPrivKey;
}

RSA* RSAEngine::getPrivateKey(QString filename)
{
	QByteArray data = readFile(filename);
	return getPrivateKey(data);
}

QByteArray RSAEngine::encryptRSA(RSA* key, QByteArray& data)
{
	QByteArray buffer;
	int dataSize = data.length();
	const unsigned char* str = (const unsigned char*)data.constData();
	int rsaLen = RSA_size(key);

	unsigned char* ed = (unsigned char*)malloc(rsaLen);

	int resultLen = RSA_public_encrypt(dataSize, (const unsigned char*)str, ed, key, PADDING);

	if (resultLen == -1)
	{
		std::cout << "[CRYPTO][-] Could not encrypt " << std::endl;
		return buffer;
	}

	buffer = QByteArray(reinterpret_cast<char*>(ed), resultLen);
	return buffer;


}

QByteArray RSAEngine::decryptRSA(RSA* key, QByteArray& data)
{
	QByteArray buffer;
	const unsigned char* encryptedData = (const unsigned char*)data.constData();

	int rsaLen = RSA_size(key);

	unsigned char* ed = (unsigned char*)malloc(rsaLen);

	int resultLen = RSA_private_decrypt(rsaLen, encryptedData, ed, key, PADDING);

	if (resultLen == -1)
	{
		//std::cout << "[CRYPTO][-] Could not decrypt " << std::endl;
		return buffer;
	}


	buffer = QByteArray::fromRawData((const char*)ed, resultLen);

	return buffer;
}

void RSAEngine::freeRSAKey(RSA* key)
{
	RSA_free(key);
}




unique_ptr<ICipherEngine> Cipher_Headquarter::Build_RSA_Engine()
{
	return make_unique<RSAEngine>();
}