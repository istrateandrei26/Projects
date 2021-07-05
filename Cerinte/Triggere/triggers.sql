
USE [Food Delivery]

--101. Creati un trigger care sa nu permita duplicarea numelor de categorii in tabela Menu

IF OBJECT_ID('tr_Menu_categoryNoDuplicate','TR') IS NOT NULL
	DROP TRIGGER tr_Menu_categoryNoDuplicate;
GO
CREATE TRIGGER tr_Menu_categoryNoDuplicate
ON Menu
INSTEAD OF INSERT,UPDATE
AS 
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	IF EXISTS(SELECT COUNT(*)
						FROM Inserted AS I
						INNER JOIN Menu AS M
						ON I.Category = M.Category
						GROUP BY I.Category
						HAVING COUNT(*) >=1 )
	BEGIN
		THROW 50000, 'Duplicate category names are not allowed !',0;
	END;
	ELSE
	BEGIN
		INSERT INTO Menu(Category)
		SELECT I.Category
		FROM Inserted AS I;
	END
END



--102. Creati un trigger care sa nu permita duplicate la numerele de telefon ale curierilor 

IF OBJECT_ID('tr_Couriers_PhoneNoDuplicate','TR') IS NOT NULL
	DROP TRIGGER tr_Couriers_PhoneNoDuplicate;
GO
CREATE TRIGGER tr_Couriers_PhoneNoDuplicate
ON Couriers
INSTEAD OF INSERT
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	IF EXISTS(SELECT COUNT(*)
						FROM Inserted AS I 
						INNER JOIN Couriers AS C
						ON I.Phone = C.Phone
						GROUP BY I.Phone  
						HAVING COUNT(*) >= 1)
	BEGIN 
		THROW 50001, 'Duplicate phone numbers are not allowed !',0;
	END;
	ELSE
	BEGIN
		SET IDENTITY_INSERT Couriers ON
		INSERT INTO Couriers(CourierID,FirstName,LastName,HireDate,Address,City,Country,Phone,ShippingArea,Salary,CarID)
		SELECT I.*
		FROM Inserted AS I;
		SET IDENTITY_INSERT Couriers OFF
	END
END


--103. Creati un trigger care sa nu permita duplicate la numerele de telefon ale clientilor, dar nici numere de telefon invalide

IF OBJECT_ID('tr_Clients_PhoneNoDuplicate','TR') IS NOT NULL
	DROP TRIGGER tr_Clients_PhoneNoDuplicate;
GO
CREATE TRIGGER tr_Clients_PhoneNoDuplicate
ON Clients
INSTEAD OF INSERT
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;

	DECLARE @phoneNumber AS NVARCHAR(20) = 
											(
												SELECT I.Phone
												FROM inserted AS I
											);

	IF EXISTS(SELECT COUNT(*)
						FROM Inserted AS I 
						INNER JOIN Clients AS C
						ON I.Phone = C.Phone
						GROUP BY I.Phone  
						HAVING COUNT(*) >= 1)
	BEGIN 
		THROW 50002, 'Duplicate phone numbers are not allowed !',0;
	END

	ELSE IF DATALENGTH(@phoneNumber) <> 10 OR @phoneNumber NOT LIKE '0%'
	BEGIN 
		THROW 50004, 'Invalid phone number !',0;
	END
	ELSE
	BEGIN
		INSERT INTO Clients(LastName,FirstName,CNP,Address,City,Country,Phone)									
		SELECT I.LastName,I.FirstName,I.CNP,I.Address,I.City,I.Country,I.Phone
		FROM Inserted AS I;
	END
END

--104. Creati un trigger care sa nu permita adrese de email duplicate conturile clientilor


IF OBJECT_ID('tr_ClientAccountsEmailNoDuplicate','TR') IS NOT NULL
	DROP TRIGGER tr_ClientAccountsEmailNoDuplicate;
GO
CREATE TRIGGER tr_ClientAccountsEmailNoDuplicate
ON ClientAccounts
INSTEAD OF INSERT
AS 
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	IF EXISTS(SELECT COUNT(*)
						FROM Inserted AS I
						INNER JOIN ClientAccounts AS CA
						ON I.EmailAddress = CA.EmailAddress
						GROUP BY I.EmailAddress
						HAVING COUNT(*) >= 1)
	BEGIN 
		THROW 50003, 'This email address has been already used !' ,0;
	END;
	ELSE
	BEGIN
		INSERT INTO ClientAccounts(EmailAddress,Password,ClientID)            
		SELECT I.EmailAddress,I.Password,I.ClientID
		FROM Inserted AS I;
	END
END

--105. Creati un trigger care sa nu permita parole mai scurte de 5 caractere si adrese de email invalide( o adresa de mail valida se considera ca trebuie sa contina '@' si .com / .ro )
 
IF OBJECT_ID('tr_ClientAccounts_WeakPassword','TR') IS NOT NULL
	DROP TRIGGER tr_ClientAccounts_WeakPassword;
GO
CREATE TRIGGER tr_ClientAccounts_WeakPassword
ON ClientAccounts
AFTER INSERT, UPDATE
AS 
BEGIN 
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	
	DECLARE @insertedPassword AS NVARCHAR(20) = (
													SELECT I.Password
													FROM Inserted AS I
												);

	DECLARE @email AS NVARCHAR(50) = (
										SELECT I.EmailAddress
										FROM Inserted AS I
									 )

	IF DATALENGTH(@insertedPassword) < 5 
	BEGIN
		THROW 50005, 'Password not strong enough ! It should have at least 5 characters !',0;
	END
	ELSE IF @email NOT LIKE '%@%' AND @email NOT LIKE '%.com' AND @email NOT LIKE '%.ro'
	BEGIN 
		THROW 50006, 'Invalid email address !',0;
	END
	ELSE
	BEGIN 
		PRINT 'Successfully inserted, paswword strong enough';
	END;
END


--106. Creati un trigger care sa nu permita o zona de livrare diferita de zona de domiciliu a curierilor

IF OBJECT_ID('tr_CouriersDifferentShippingArea','TR') IS NOT NULL 
	DROP TRIGGER tr_CouriersDifferentShippingArea;
GO
CREATE TRIGGER tr_CouriersDifferentShippingArea
ON Couriers
AFTER INSERT
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	
	DECLARE @insertedCity AS NVARCHAR(50) = ( 
											 SELECT S.City
											 FROM Inserted AS I
											 INNER JOIN ShippingAreas AS S
											 ON I.ShippingArea = S.LocationID
											);
	DECLARE @insertedCourierCity AS NVARCHAR(50) = ( 
											 SELECT I.City
											 FROM Inserted AS I
											);
	
	IF @insertedCity NOT LIKE '%' + @insertedCourierCity + '%'
	BEGIN 
		THROW 50007,'Courier should have same shipping area with his home area!',0;
	END
END


--107. Creati un trigger care sa nu permita inserarea/modificarea curierului unei comenzi astfel curierul nou sa fie angajat dupa data calendaristica de pe comanda 

IF OBJECT_ID('tr_OrdersInvalidCourierHireDate','TR') IS NOT NULL
	DROP TRIGGER tr_OrdersInvalidCourierHireDate;
GO
CREATE TRIGGER tr_OrdersInvalidCourierHireDate
ON Orders
AFTER INSERT
AS
BEGIN 
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;

	DECLARE @newCourierHiredate AS DATETIME = (
												SELECT C.HireDate
												FROM Inserted AS I
												INNER JOIN Couriers AS C
												ON I.CourierID = C.CourierID
												);
	DECLARE @newOrderDate AS DATETIME = (
										 SELECT I.ExpectedDate
										 FROM Inserted AS I
										 );
	
	IF @newCourierHiredate > @newOrderDate
	BEGIN 
		THROW 50008, 'You should insert a courier hired before the order date !',0;
	END
END

--108. Creati un trigger care sa nu permita furnizorului Lovely Sweets sa ofere alte produse decat cele din categoria 'Deserturi' si 'Sucuri'

IF OBJECT_ID('tr_OnlySweetsAndJuice','TR') IS NOT NULL 
	DROP TRIGGER tr_OnlySweetsAndJuice;
GO
CREATE TRIGGER tr_OnlySweetsAndJuice
ON ProvidersDishesRelation
AFTER INSERT, UPDATE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;

	DECLARE @insertedCategory AS NVARCHAR(50) ; 
	WITH 
	SelectedDishes AS
	(
		SELECT D.CategoryID
		FROM Inserted AS I 
		INNER JOIN Dishes AS D
		ON I.DishID = D.DishID
	)
	SELECT @insertedCategory = M.Category
	FROM SelectedDishes AS S
	INNER JOIN Menu AS M
	ON S.CategoryID = M.CategoryID
												
	
	DECLARE @insertedProviderName AS NVARCHAR(50) = (
														SELECT P.CompanyName
														FROM Inserted AS I
														INNER JOIN Providers AS P
														ON I.ProviderID = P.ProviderID
													)

	IF @insertedProviderName = 'Lovely Sweets' AND @insertedCategory <> 'Sucuri' AND @insertedCategory <> 'Deserturi'
	BEGIN
		THROW 50009,'Lovely sweets cannot provide anything but sweets and juice',0;
	END
END


--109. Creati un trigger care sa nu permita duplicate la numele felurilor de mancare / produse

IF OBJECT_ID('tr_DishesNoDuplicates','TR') IS NOT NULL 
	DROP TRIGGER tr_DishesNoDuplicates;
GO
CREATE TRIGGER tr_DishesNoDuplicates
ON Dishes
AFTER INSERT, UPDATE
AS 
BEGIN
	IF @@ROWCOUNT = 0 RETURN ;
	SET NOCOUNT ON ;

	IF EXISTS( SELECT COUNT(*) 
				FROM inserted AS I
				INNER JOIN Dishes AS D
				ON I.Name = D.Name
				GROUP BY I.Name
				HAVING COUNT(*) > 1)
	BEGIN
		THROW 50010,'Dish name cannot have duplicates !',0;
	END
END
	


--110. Creati un trigger care sa adauge produse de la furnizorul 'True Food' atunci cand sunt inserate comenzi cu 'Ciorbe' sau 'Supe'. 
--De exemplu , daca apare o factura cu 2 ciorbe radautene, in ProvidersDishesRelation va fi inserata o inregistrare aferenta continutului din factura

IF OBJECT_ID('tr_SendDishFromTrueFoodProvider','TR') IS NOT NULL
	DROP TRIGGER tr_SendDishFromTrueFoodProvider;
GO
CREATE TRIGGER tr_SendDishFromTrueFoodProvider
ON Receipt
AFTER INSERT
AS 
BEGIN
	IF @@ROWCOUNT = 0 RETURN ;
	SET NOCOUNT ON ;

	DECLARE @DishName AS NVARCHAR(50);

	SELECT @DishName = D.Name
	FROM Inserted AS I
	INNER JOIN Dishes AS D
	ON I.DishID = D.DishID

	IF @DishName LIKE '%Ciorba%' OR @DishName LIKE '%Supa%'
	BEGIN 

	DECLARE @newDishIDsearched INT;     -- aflam id-ul dish ului respectiv

	SELECT @newDishIDsearched = D.DishID
	FROM Dishes AS D
	WHERE D.Name = @DishName;

	DECLARE @TrueFoodProviderID INT;    -- aflam id-ul provider-ului

	SELECT @TrueFoodProviderID = ProviderID
	FROM Providers AS P
	WHERE P.CompanyName = 'True Food';

	--aflam data comenzii

	DECLARE @datetimeProvided DATETIME;
	DECLARE @newQuantity INT;

	SELECT @datetimeProvided = O.ExpectedDate, @newQuantity = I.Quantity
	FROM inserted AS I
	INNER JOIN Orders AS O
	ON I.OrderID = O.OrderID

	INSERT INTO ProvidersDishesRelation VALUES
	(@TrueFoodProviderID,@newDishIDsearched,@datetimeProvided,@newQuantity);

	END
END


--111. Creati un trigger care sa rezolve eroarea de foreign key generata la stergerea unei inregistrari din tabela Orders.
--	   Astfel, la stergerea unei comenzi , se va sterge si factura aferenta.

IF OBJECT_ID('tr_DeleteOrderDeleteReceipt','TR') IS NOT NULL
	DROP TRIGGER tr_DeleteOrderDeleteReceipt;
GO
CREATE TRIGGER tr_DeleteOrderDeleteReceipt
ON Orders
INSTEAD OF DELETE
AS 
BEGIN 
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;

	IF EXISTS( SELECT COUNT(*)
					FROM deleted AS D
					INNER JOIN Receipt AS R
					ON D.OrderID = R.OrderID
					GROUP BY D.OrderID
					HAVING COUNT(*) <> 0 )
	BEGIN

	DELETE FROM R
	FROM deleted AS D
	INNER JOIN Receipt AS R
	ON D.OrderID = R.OrderID;

	DELETE FROM O
	FROM deleted AS D
	INNER JOIN Orders AS O
	ON D.OrderID = O.OrderID

	PRINT 'Record(s) has(have) been also deleted from Receipt !';

	END

END


--112. Creati un trigger care sa rezolve erorile de foreign key la stergerea unui client din baza de date.
--	   Astfel , la stergerea unui client, se vor sterge comenzile si conturile sale

IF OBJECT_ID('tr_DeleteClientDeleteOrdersDeleteAccounts','TR') IS NOT NULL 
	DROP TRIGGER tr_DeleteClientDeleteOrdersDeleteAccounts;
GO
CREATE TRIGGER tr_DeleteClientDeleteOrdersDeleteAccounts
ON Clients
INSTEAD OF DELETE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN ;
	SET NOCOUNT ON ;

	DECLARE @count1 INT;
	DECLARE @count2 INT;
	SELECT @count1 =  COUNT(*) 
								FROM Deleted AS D
								INNER JOIN ClientAccounts AS CA
								ON D.ClientID = CA.ClientID;
	
	SELECT @count2 =  COUNT(*) 
								FROM Deleted AS D
								INNER JOIN Orders AS O
								ON D.ClientID = O.ClientID;

	IF @count1 <> 0 AND @count2 <> 0 
	BEGIN 

	DELETE FROM CA
	FROM Deleted AS D
	INNER JOIN ClientAccounts AS CA
	ON D.ClientID = CA.ClientID
	PRINT 'Record(s) has(have) been also deleted from ClientAccounts !';

	DELETE FROM O
	FROM Deleted AS D
	INNER JOIN Orders AS O
    ON D.ClientID = O.ClientID

	END
	ELSE IF @count1 <> 0
	BEGIN 

	DELETE FROM CA
	FROM Deleted AS D
	INNER JOIN ClientAccounts AS CA
	ON D.ClientID = CA.ClientID
	PRINT 'Record(s) has(have) been also deleted from ClientAccounts !';


	END
	ELSE IF @count2 <> 0
	BEGIN

	DELETE FROM O
	FROM Deleted AS D
	INNER JOIN Orders AS O
    ON D.ClientID = O.ClientID

	END

END


--113. Creati un trigger care sa rezolve eroarea de foreign key la stergerea unui furnizor din tabela aferenta.
--	   De exemplu , la stergerea unui furnizor din tabela Providers, se vor sterge si inregistrarile aferente din tabela ProvidersDishesRelation

IF OBJECT_ID('tr_DeleteProviderFromEverywhere','TR') IS NOT NULL
	DROP TRIGGER tr_DeleteProviderFromEverywhere;
GO
CREATE TRIGGER tr_DeleteProviderFromEverywhere
ON Providers
INSTEAD OF DELETE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;

	IF EXISTS( SELECT COUNT(*)
						FROM Deleted AS D
						INNER JOIN ProvidersDishesRelation AS PD
						ON D.ProviderID = PD.ProviderID
						HAVING COUNT(*) <> 0 )

	BEGIN 
	
	DELETE FROM PD  
	FROM Deleted AS D
	INNER JOIN ProvidersDishesRelation AS PD
	ON D.ProviderID = PD.ProviderID

	DELETE FROM P
	FROM Deleted AS D
	INNER JOIN Providers AS P
	ON D.ProviderID = P.ProviderID

	PRINT 'Record(s) has(have) been also deleted from ProvidersDishesRelation !';



	END
END


--114. Creati un trigger cu ajutorul caruia sa eliminati o anumita taxa de la toti angajatii in cazul eliminarii acestei taxe din tabelul Taxes

IF OBJECT_ID('tr_DeleteSpecificTaxFromAllEmployees','TR') IS NOT NULL 
	DROP TRIGGER tr_DeleteSpecificTaxFromAllEmployees;
GO
CREATE TRIGGER tr_DeleteSpecificTaxFromAllEmployees
ON Taxes
INSTEAD OF DELETE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;

	IF EXISTS( SELECT COUNT(*) 
						FROM Deleted AS D
						INNER JOIN EmployeesTaxes AS E
						ON D.TaxID = E.TaxID
						HAVING COUNT(*) <> 0)
	BEGIN

	DELETE FROM E 
	FROM Deleted AS D
	INNER JOIN EmployeesTaxes AS E
	ON D.TaxID = E.TaxID

	DELETE FROM T
	FROM Deleted AS D
	INNER JOIN Taxes AS T
	ON D.TaxID = T.TaxID

	END
END

						

--115. Creati un trigger care sa nu permita un salariu brut cu o valoare mai mica decat 3700 unitati pentru curieri

IF OBJECT_ID('tr_CouriersSalary','TR') IS NOT NULL
	DROP TRIGGER tr_CouriersSalary;
GO
CREATE TRIGGER tr_CouriersSalary
ON Couriers
AFTER INSERT, UPDATE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;

	DECLARE @salary INT;
	SELECT @salary = 
						I.Salary
						FROM inserted AS I;

	IF @salary < 3700
	BEGIN

	THROW 50011,'Salary should be at least 3700 !',0;

	END
END


