#include "pch.h"
#include "IException.h"
#include "Exception_Client.h"

int main() {

	IException* e = new Exception_Client("da", 1);
}