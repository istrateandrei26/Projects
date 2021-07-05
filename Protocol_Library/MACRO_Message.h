#pragma once

//#define MESS_BUFF_FILE 1000000 //lungimea maxima a mesajului pentru continut FISIERE
#define MESS_BUFF		2048 // -||- pentru comunicare ce nu icnldue fisiere
#define CHUNK_OF_FILE	1024 // lungimea maxima de continut de fisier trimisa intr-un mesaj
// atentie CHUNK_OF_FILE + restul mesajului nu trebuie sa depaseasca MESS_BUFF

#define MESS_ENCRYPTED_MAX_LENGHT    2000

#define MESS_EndOfMessage			"?.?!n"
#define MESS_Lenght_endOfMessage	5

#define MESS_SEPARATOR			'+'

#define MESS_START_OF_FILE		"%S_O_F%"
#define MESS_END_OF_FILE		"%E_O_F%"

#define HASH "nZr4u7x!A%D*G-KaNdRgUkXp2s5v8y/B"
