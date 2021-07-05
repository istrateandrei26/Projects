USE [Food Delivery]

--61. Tranzactie pentru modificarea salariului brut al curierului cu numele Apostolache Marius

BEGIN TRAN
UPDATE Couriers 
SET Salary = 4400 WHERE FirstName + ' ' + LastName = 'Apostolache Marius'
COMMIT 


--62. Tranzactie pentru modificarea parolelor conturilor clientilor ai caror prenume se termina cu litera 'a' , precum si a celorlalti 

BEGIN TRY
	BEGIN TRAN
	UPDATE CA
	SET CA.Password = 'Updated for ladies'   
	FROM ClientAccounts AS CA
	INNER JOIN Clients AS C
	ON CA.ClientID = C.ClientID
	WHERE C.CNP LIKE '2%' 

	UPDATE CA
	SET CA.Password = 'Updated for gentlemen'   
	FROM ClientAccounts AS CA
	INNER JOIN Clients AS C
	ON CA.ClientID = C.ClientID
	WHERE C.CNP NOT LIKE '2%' 

	COMMIT
	Print 'Transaction committed'
END TRY
BEGIN CATCH
	ROLLBACK
	Print 'Transaction rolledback'
END CATCH



--63. Tranzactie pentru adaugarea unui nou client + un cont nou pentru acesta 

select *from ClientAccounts
select *from Clients

BEGIN TRY
	BEGIN TRAN
	INSERT INTO Clients(LastName,FirstName,CNP,Address,City,Country,Phone) VALUES
	('Vasile','George','1990126170033','Strada Florilor Nr.8', 'Timisioara', 'Romania','0724320871');
	COMMIT
	DECLARE @newClientID INT 
	SET @newClientID = 
	(
		SELECT ClientID
		FROM Clients 
		WHERE LastName + ' ' + FirstName = 'Dumitriu Vlad'
	)

	BEGIN TRAN
	INSERT INTO ClientAccounts(EmailAddress,Password,ClientID) VALUES
	('dumitriuvlad@gmail.com','vlad123',2000)

	COMMIT
	Print 'Transaction committed'
END TRY
BEGIN CATCH
	
	ROLLBACK
	Print 'Transaction rolledback'
END CATCH

--64. Tranzactie pentru update in tabela de curieri + tabela de autoturisme 

select *from couriers
BEGIN TRY
	BEGIN TRAN
	UPDATE Couriers 
	SET Phone = '0777777777' 
	WHERE CourierID = 17

	UPDATE Vehicles 
	SET BrandID = 100    -- nu exista -> va esua
	WHERE CarID = 1

	COMMIT
	Print 'Transaction commited'
END TRY 
BEGIN CATCH
	ROLLBACK
	Print 'Transaction rolledback , failed'
END CATCH

--65. Tranzactie cu succes pentru update in 3 tabele

BEGIN TRY
	BEGIN TRAN
	UPDATE Couriers 
	SET Phone = '0777777777' 
	WHERE CourierID = 17

	UPDATE Vehicles 
	SET BrandID = 3   
	WHERE CarID = 1

	UPDATE Clients
	SET Address = 'Strada Nae Leonard Nr. 28' 
	WHERE ClientID = 3

	COMMIT
	Print 'Transaction commited'
END TRY 
BEGIN CATCH
	ROLLBACK
	Print 'Transaction rolledback , failed'
END CATCH

--66. Tranzactie pentru inserarea unei noi categorii de produs

DECLARE @errnum INT;
BEGIN TRAN
	INSERT INTO Menu(Category) VALUES
	('Sucuri');

	SET @errnum = @@ERROR;
	IF @errnum <> 0        -- codul erorii
	BEGIN 
		PRINT 'Insert into Menu failed with this error: ' + CAST(@errnum AS VARCHAR);
		ROLLBACK
	END
	ELSE
	BEGIN 
		COMMIT
	END


--67. Tranzactie pentru stergerea unei categorii de produs 

DECLARE @err INT;				
BEGIN TRAN
	DELETE FROM Menu
	WHERE CategoryID = 3000      -- va genera eroare

	SET @err = @@ERROR;
	IF @err <> 0        -- codul erorii
	BEGIN 
		PRINT 'Delete on Menu table failed with this error: ' + CAST(@err AS VARCHAR);
		ROLLBACK
	END
	ELSE
	BEGIN 
		COMMIT
	END

--68. Tranzactie pentru adaugarea unui client nou 

BEGIN TRY
	BEGIN TRAN
	SET IDENTITY_INSERT Clients ON;
	 
	INSERT INTO Clients(ClientID,LastName,FirstName,CNP,Address,City,Country,Phone) VALUES
	(11,'Samoila','Marius','1990324170035','Strada Iuresului Nr. 125', 'Cluj','Romania','071212333');

	SET IDENTITY_INSERT Clients OFF;

	COMMIT
	Print 'Transaction commited'
END TRY 
BEGIN CATCH
	ROLLBACK
	Print 'Transaction rolledback , failed'
END CATCH


--69. Tranzactie pentru inserarea unui nou curier in lista
BEGIN TRY
	BEGIN TRAN

	INSERT INTO Couriers VALUES
	('Marinescu','Darius','2020-06-29','Strada Grigore Ventura','Galati','Romania','0722228789',3,4500,15);

	COMMIT
	Print 'Transaction commited'
END TRY 
BEGIN CATCH
	ROLLBACK
	Print 'Transaction rolledback , failed'
END CATCH


--70. Tranzactie pentru adaugarea unei zone de livrare cu un identificator specific

BEGIN TRY
	BEGIN TRAN
	SET IDENTITY_INSERT ShippingAreas ON;
	
	INSERT INTO ShippingAreas(LocationID,City,Country) VALUES
	(1,'Galati','Romania') 

	SET IDENTITY_INSERT ShippingAreas OFF;

	COMMIT
	Print 'Transaction commited'
END TRY 
BEGIN CATCH
	ROLLBACK
	Print 'Transaction rolledback , failed'
END CATCH






	

