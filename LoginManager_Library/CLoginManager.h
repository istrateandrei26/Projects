#pragma once
#include "iLoginManager.h"

class ILog;
class iDatabase;
#include "ICipherEngine.h"

class CLoginManager :
    public iLoginManager
{
public:
    CLoginManager(std::string driver, std::string server, std::string port, std::string databaseName);
    ~CLoginManager();

    //Verifica date sia dauga-le in abza de date
    //admin == false -> Utilizator nomral ________ admin == true -> Admin
    int Register(std::string username, std::string passwrod, std::string email, bool admin = false) override;

    //Verorificam existenta datelor in baza de date
    //Returneaza o valoare macro aferenta pentru Admin sai Utilizator (e retinut tipul in baza de date)
    int Login(std::string username, std::string password) override;

    //Sterge inregistrarea specifica randului cu suernameul dat
    int Delete(std::string username) override;

    int ChangePassword(std::string username, std::string new_password) override;
    int ChangeEmail(std::string username, std::string new_email) override;
    int ChangeAdminStatus(std::string username, bool admin) override;

    std::list<LoginManager_ClientsDetails> GetAllData() override;

private:

    iDatabase* m_DB;
    ILog* m_log;
    std::unique_ptr<ICipherEngine> m_AES_engine;
    std::unique_ptr<ICipherEngine> m_RSA_engine;
    RSA* m_private_key;
    RSA* m_public_key;


    //o setam in constructor. Nu oferim posibilitate de resetare
    int m_minLenghtPassword;

    //Verificam unicitate pentru email si username la inregistrare
    int CheckRegisterData(std::string username, std::string email);
    //Verificam ca parola sa nu fie prea slaba
    int CheckPasswordStrenght(std::string password);

};

