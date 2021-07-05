#pragma once

#include "MACRO_Message.h"

#define PROT_FAILED		-1
#define PROT_SUCCEDED	0
//----------------
//----------------------


#define PROT_FirstType_ID					1

//requsets
#define PROT_REQUEST_FirstID				1

#define PROT_LOGIN_REQUEST					1	
#define PROT_REGISTER_REQUEST				2
#define PROT_FILE_UPLOAD_REQUEST		    3		// se trasnmit si niste date despre fisier odata cu niste continut
#define PROT_BINARY_FILE_UPLOAD_REQUEST		4
#define PROT_SEND_CLIENT_DATA				6		//la reconectare trimitem usernameul (vedem daca mai dam si atlceva)
#define PROT_VIEW_FILES_REQUEST				7		//cerere de vizualizare fisiere
#define PROT_FILE_DOWNLOAND_REQUEST			8
#define PROT_CHANGE_PASSWORD_REQUEST		9
#define PROT_CHANGE_EMAIL_REQUEST			10
#define PROT_PROMOTE_USER_REQUEST			11
#define PROT_DELETE_USER_REQUEST			12
#define PROT_VIEW_USERS_REQUEST				13
#define PROT_SHUTDOWN_SERVER_REQUEST		14
#define PROT_START_SERVER_REQUEST			15
#define PROT_LOGOUT_REQUEST					16
#define PROT_CHECK_ADMIN_REQUEST			17

#define PROT_REQUEST_LastID					17


//responses
#define PROT_RESPONSE_FirstID				20

#define PROT_LOGIN_RESPONSE_ADMIN						20
#define PROT_LOGIN_RESPONSE_UTILIZATOR					21
#define PROT_LOGIN_RESPONSE_FAILED						22
#define PROT_REGISTER_RESPONSE_SUCCEDED					23
#define PROT_REGISTER_RESPONSE_FAILED					24
#define PROT_FILE_UPLOAD_RESPONSE_SUCCEDED				25
#define PROT_FILE_UPLOAD_RESPONSE_FAILED				26
#define PROT_FILE_UPLOAD_RESPONSE_ALREADY_EXIST			27
#define PROT_VIEW_FILE_RESPONSE_SUCCEDED				28
#define PROT_VIEW_FILE_RESPONSE_USERNAME_NoEXIST		29
#define PROT_FILE_DOWNLOAND_RESPONE_NoEXIST				30
#define PROT_FILE_DOWNLOAND_RESPONSE_SUCCEDED			31
#define PROT_CHANGE_PASSWORD_RESPONSE_SUCCEDED			32
#define PROT_CHANGE_PASSWORD_RESPONSE_OLD_PASS_WRONG	33
#define PROT_CHANGE_PASSWORD_RESPONSE_FAILED			34
#define PROT_CHANGE_EMAIL_RESPONSE_SUCCEDED				35
#define PROT_CHANGE_EMAIL_RESPONSE_FAILED				36
#define PROT_VIEW_USERS_RESPONSE_SUCCEDED				37
#define PROT_VIEW_USERS_RESPONSE_FAILED					38
#define PROT_DELETE_USER_RESPONSE_SUCCEDED				39
#define PROT_DELETE_USER_RESPONSE_USER_NoEXIST			40
#define PROT_DELETE_USER_RESPONSE_FAILED				41
#define PROT_PROMOTE_USER_RESPONSE_SUCCEDED				42
#define PROT_PROMOTE_USER_RESPONSE_USER_NoEXIST			43
#define PROT_PROMOTE_USER_RESPONSE_FAILED				44
#define PROT_SHUTDOWN_SERVER_RESPONSE_FAILED			45
#define PROT_START_SERVER_RESPONSE_FAILED				46
#define PROT_SHUTDOWN_SERVER_RESPONSE_SUCCEDED			47
#define PROT_START_SERVER_RESPONSE_SUCCEDED				48
#define PROT_LOGOUT_RESPONSE_SUCCEDED					49
#define PROT_LOGOUT_RESPONSE_FAILED						50

#define PROT_RESPONSE_LastID				200


#define PROT_LastType_ID					50



//MODurile psoibile de transmitere a unui fisier\
//pt upload Client -> server
#define PROT_FILE_NEW					500
#define PROT_FILE_APPEND				501
#define PROT_FILE_REPLACE			    502
//pt Downloand server -> client
#define PROT_FILE_END					503
#define PROT_FILE_NO_END				504

//MODurile psoibile de vizualizare a fisierelor
#define PROT_VIEW_FILE_ALL					510		//toate fisierele unui utilziaotr
#define PROT_VIEW_FILE_DAY					511		//toate dintr-o data specifica (pe o zi)
#define PROT_VIEW_FILE_MONTH				512		//toate dintr-o luna specifica
#define PROT_VIEW_FILE_FROM_DAY_ToPRESENT	513		//toate dintr-o data specifica si pana in prezent

//MODuri pentru promote user
#define PROT_PROMOTE_ADMIN		520
#define PROT_PROMOTE_USER		521

//----------------------
//---------------------
//Astea vin folosite doar in cadrul acestui proiect, nu si in in cele in care folosim libraria
#define PROT_ERROR					300
#define PROT_ERROR_NoEndOfMessage	301
#define PROT_ERROR_InvalidType		302
#define PROT_ERROR_InvalidMessage	303

//numarul de elemente aferent fiecarui tip de mesaj
#define PROT_BasicResponse_Elements				2
#define PROT_Login_Request_Elements				4	//mesaj de logare Client -> Server
#define PROT_Login_Response_Elements			2	//raspuns la logare Server -> Client
#define PROT_Register_Request_Elements			6	//tip_username_parola_email_cod+ENDofMESSAGE
#define PROT_Send_Client_Data_Elements			3	//tip+username+END
#define PROT_File_Upload_Elements				5	//tip+modScriere+numeFisier+continut+ENDofMEssage
#define PROT_View_file_Request_Elements			5	//tip+modView+data+username+ENDofMESS
#define PROT_File_Downloand_Request_Elements	4	//tip+filename+ultima pozitie citita+ENDofmessage (client ->server)
#define PROT_File_Downloand_Response_Elements	5   //tip+END/NO END+ultima poz cititia+cotinut+ENDofmessage(server -> client)
#define PROT_Change_Password_Request_Elements	5	//tip+username+newpass+oldpass+ENDofMessage
#define PROT_Change_Email_Request_Elements		4	//tip+username+newEmail+oldEmail+ENDofMessage
#define PROT_Delete_User_Request_Elements		3   //tip_username_End
#define PROT_View_Users_Request_Eelements		2	//tip+End
#define PROT_Promote_User_Request				4	//tip+user+Admin/Util+END
#define PROT_Start_Server_Request_Elements		2   //tip+END
#define PROT_Shutdown_Server_Request_Elements	2	//tip+END
#define PROT_Logout_Elements					2	//tip+END
#define PROT_Check_Admin_Request_Elements		3	//tip+username+END

