#include "CipherEngine.h"
#include "FileException.h"

CipherEngine::CipherEngine()
{
	initialize();
}

CipherEngine::~CipherEngine()
{
	finalize();
}



void CipherEngine::writeFile(QString filename, QByteArray& data)
{
	QFile file(filename);
	if (!file.open(QFile::WriteOnly))
	{
		throw File_Exception();
	}

	file.write(data);
	file.close();
}

QByteArray CipherEngine::readFile(QString filename)
{
	QByteArray data;
	QFile file(filename);
	if (!file.open(QFile::ReadOnly))
	{
		std::cout << "[CRYPTO][-] Could not load file" << std::endl;
	}
	data = file.readAll();
	file.close();
	return data;
}

void CipherEngine::initialize()
{
	ERR_load_CRYPTO_strings();
	OpenSSL_add_all_algorithms();
	OpenSSL_add_all_digests();
	OPENSSL_config(NULL);
}

void CipherEngine::finalize()
{
	EVP_cleanup();
	ERR_free_strings();
	/*RSA_free(keypair);
	BIO_free_all(pub);
	BIO_free_all(pri);
	free(pri_key);
	free(pub_key);
	free(encrypt);
	free(decrypt);
	free(err);*/
}


