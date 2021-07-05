#define LoginManager_FAILED -1 
#define LoginManager_SUCCES 0		//cazuri de succes ce nu necesita specificatii suplimentare

#define LoginManager_SUCCES_Admin 1		//conectare cu succes ca admin
#define LoginManager_SUCCES_Utilizator 2	//conectare cu succec ca utilizator

//register
#define LoginManager_Register_ERROR 10	//eroare la inregistrare din cauza sistemului
#define LoginManager_Register_UsernameOrEmail_AlreadyUsed 12	//ii spune numele
//#define Login_ERROR_NoMatchPasswords 11
//#define Login_Error_PasswordTooWeak_NoUpperCase 13
//#define Login_Error_PasswordTooWeak_NoDigit 14
//#define Login_Error_PasswordTooWeak_TooShort 15
#define LoginManager_Login_ERROR 20 // eroare la login din cauza sistemului
#define LoginManager_Login_UsernameOrPassword_Wrong 21	//ii spune numele

#define LoginManager_Delete_ERROR 30
#define LoginManager_Update_ERROR 31