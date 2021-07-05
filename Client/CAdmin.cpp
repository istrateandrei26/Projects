#include "CAdmin.h"

#include <conio.h>

void CAdmin::Run() {

	do {
		system("cls");
		WelcomePrint();

		char option;
		option = _getch();
		switch (option)
		{
		case '1':
			//vizualizeaza lista utilizatori
			break;
		case '2':
			//ceva
			break;
		case '3':
			//vizualizeaza fisiere
			break;
		case '4':
			//setari cont
			break;
		default:
			break;
		}

	} while (true);

}

void CAdmin::WelcomePrint() {

	std::cout << "Bine ati venit pe platforma DataSentinel!" << std::endl;
	std::cout << "\nApasati:";
	std::cout << "\n\t1. Ceva";
	std::cout << "\n\t2. Altceva";
	std::cout << "\n\t3. Vizualizare fisiere";
	std::cout << "\n\t4. Setari cont" << std::endl;
}