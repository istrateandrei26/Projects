USE [Food Delivery]

--81. Creati o procedura stocata cu ajutorul careia sa afisati produsele comandate dintotdeauna de catre un client dintr-un anumit oras

IF OBJECT_ID('GetClientDishes','P') IS NOT NULL
	DROP PROC GetClientDishes;
GO
CREATE PROC GetClientDishes
	@cityName AS NVARCHAR(50),
	@numRows AS INT = 0 OUTPUT
AS
BEGIN
	SELECT C.FirstName + ' ' + C.LastName AS 'Nume complet' ,D.Name
	FROM Clients AS C
	INNER JOIN Orders AS O
	ON C.ClientID = O.ClientID
	INNER JOIN Receipt AS R
	ON O.OrderID = R.OrderID
	INNER JOIN Dishes AS D
	ON R.DishID = D.DishID
	WHERE C.City = @cityName;
	
	SET @numRows = @@ROWCOUNT
	RETURN;
END

DECLARE @numRowsReturned AS INT;
EXEC GetClientDishes
	'Brasov',
	@numRows = @numRowsReturned OUTPUT ;

SELECT @numRowsReturned AS 'Number of rows returned'

--82. Creati o procedura stocata cu ajutorul careia sa afisati detalii despre comenzile livrate cu o anumita masina, se va da ca parametru un numar de inmatriculare

IF OBJECT_ID('GetOrderDetailsByRegistrationCarNumber', 'P') IS NOT NULL
	DROP PROC GetOrderDetailsByRegistrationCarNumber;
GO
CREATE PROC GetOrderDetailsByRegistrationCarNumber
	@registrationNumber AS NVARCHAR(20)
AS 
BEGIN
	SELECT Cl.FirstName + ' ' + Cl.LastName AS 'Client',O.Address + ', ' + O.City AS 'Adresa de livrare', O.ExpectedDate AS 'Data livrarii',
			C.FirstName AS 'Curier', D.Name AS 'Dish' , M.Category AS 'Categorie'
	FROM Orders AS O
	INNER JOIN Receipt AS R
	ON O.OrderID = R.OrderID
	INNER JOIN Couriers AS C
	ON O.CourierID = C.CourierID
	INNER JOIN Dishes AS D
	ON R.DishID = D.DishID
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	INNER JOIN Vehicles AS V
	ON C.CarID = V.CarID
	INNER JOIN AutoBrands AS AB
	ON V.BrandID = AB.BrandID
	INNER JOIN Clients AS Cl
	ON O.ClientID = Cl.ClientID
	WHERE V.RegistrationNumber = @registrationNumber;
	
	RETURN;
END

DECLARE @carNumber AS NVARCHAR(20) = 'GL95AFG';
EXEC GetOrderDetailsByRegistrationCarNumber
	@carNumber;



--83. Creati o procedura stocata cu ajutorul careia sa afisati produsele dintr-o anumita categorie , livrate intr-o anumita zi ( 2 parametri )

IF OBJECT_ID('GetAllDishesByCategoryAndDatetime', 'P') IS NOT NULL
	DROP PROC GetAllDishesByCategoryAndDatetime;
GO
CREATE PROC GetAllDishesByCategoryAndDatetime
	@categoryName AS NVARCHAR(50),
	@requiredDate AS DATETIME
AS
BEGIN 
	SELECT D.Name AS 'Dish'
	FROM Dishes AS D
	INNER JOIN Receipt AS R
	ON R.DishID = D.DishID
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	INNER JOIN Orders AS O
	ON O.OrderID = R.OrderID
	WHERE O.ExpectedDate = @requiredDate AND M.Category = @categoryName;

	RETURN;
END

DECLARE @dishCategory AS NVARCHAR(50) = 'Ciorbe';
DECLARE @specificDay AS DATETIME = CONVERT(DATETIME,'2021-04-12');
EXEC GetAllDishesByCategoryAndDatetime
	@dishCategory,
	@specificDay;


--84. Creati o procedura stocata cu ajutorul careia sa afisati detaliile despre un anumit curier, precum si toate produsele livrate dintotdeauna de acesta

IF OBJECT_ID('GetAllDishesShippedByCourier','P') IS NOT NULL
	DROP PROC GetAllDishesShippedByCourier;
GO
CREATE PROC GetAllDishesShippedByCourier
	@courierName AS NVARCHAR(50)
AS 
BEGIN
	SELECT C.Address , C.City, C.Country , C.HireDate , C.Phone , S.City AS 'Shipping Area' , D.Name AS 'Dish' , M.Category
	FROM Couriers AS C
	INNER JOIN Orders AS O
	ON C.CourierID = O.CourierID
	INNER JOIN Receipt AS R
	ON O.OrderID = R.OrderID 
	INNER JOIN Dishes AS D
	ON R.DishID = D.DishID
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	INNER JOIN ShippingAreas AS S
	ON C.ShippingArea = S.LocationID
	WHERE C.FirstName + ' ' + C.LastName = @courierName;
	RETURN;
END

DECLARE @completeName AS NVARCHAR (50)= 'Petrescu Alexandru';
EXEC GetAllDishesShippedByCourier
	@completeName

--85. Creati o procedura stocata cu ajutorul careia sa afisati toate comenzile si masina cu care au fost livrate produsele ,dintr-o anumita zi

IF OBJECT_ID('GetAllOrdersByDay','P') IS NOT NULL
	DROP PROC GetAllOrdersByDay;
GO
CREATE PROC GetAllOrdersByDay
	@specificDay AS DATETIME
AS 
BEGIN
	SELECT O.Address + ' ,' + O.City + ' ,' + O.Country AS 'Adresa de livrare', V.RegistrationNumber AS 'Numar de inmatriculare',AB.BrandName AS 'Marca autoturism'
	FROM Orders AS O
	INNER JOIN Couriers AS C
	ON O.CourierID = C.CourierID
	INNER JOIN Vehicles AS v
	ON C.CarID = V.CarID 
	INNER JOIN AutoBrands AS AB
	ON V.BrandID = AB.BrandID
	WHERE O.ExpectedDate = @specificDay;

	RETURN;
END

DECLARE @day AS DATETIME = CONVERT(DATETIME,'2021-04-09');
EXEC GetAllOrdersByDay
	@day

--86. Creati o procedura stocata cu ajutorul careia sa afisati toti clientii care au comandat un anumit produs 

IF OBJECT_ID('GetAllClientsByDish','P') IS NOT NULL
	DROP PROC GetAllClientsByDish;
GO
CREATE PROC GetAllClientsByDish
	@dishName AS NVARCHAR(50)
AS 
BEGIN 
	SELECT C.FirstName + ' ' + C.LastName AS 'Client' , C.Phone 
	FROM Dishes AS D
	INNER JOIN Receipt AS R
	ON D.DishID = R.DishID
	INNER JOIN Orders AS O
	ON O.OrderID = R.OrderID 
	INNER JOIN Clients AS C
	ON O.ClientID = C.ClientID
	WHERE D.Name LIKE '%' + @dishName + '%';

	RETURN;
END

DECLARE @specificDish AS NVARCHAR(50) = 'Dorada regala la cuptor';
EXEC GetAllClientsByDish @specificDish;

--87. Creati o procedura stocata cu ajutorul careia sa afisati produsele oferite de un anumit furnizor

IF OBJECT_ID('GetAllDishesOfferedByProvider','P') IS NOT NULL
	DROP PROC GetAllDishesOfferedByProvider;
GO
CREATE PROC GetAllDishesOfferedByProvider
	@providerName AS NVARCHAR(50)
AS 
BEGIN
	SELECT D.Name AS 'Dish' ,*
	FROM Providers AS P
	INNER JOIN ProvidersDishesRelation AS PD
	ON P.ProviderID = PD.ProviderID
	INNER JOIN Dishes AS D
	ON PD.DishID = D.DishID
	WHERE P.CompanyName = @providerName;

	RETURN 
END

DECLARE @name AS NVARCHAR(50) = 'Tasty Fish';
EXEC GetAllDishesOfferedByProvider
	@name



--88. Creati o procedura stocata cu ajutorul careia sa afisati toate produsele dintr-o anumita categorie
IF OBJECT_ID('GetAllDishesByCategory','P') IS NOT NULL
	DROP PROC GetAllDishesByCategory;
GO
CREATE PROC GetAllDishesByCategory
	@categoryName as NVARCHAR(50)
AS
BEGIN
	
	SELECT D.Name AS 'Dish name' , M.Category AS 'Category'
	FROM Dishes AS D
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	WHERE M.Category = @categoryName;

	RETURN
END

DECLARE @catName AS NVARCHAR(50) = 'Bauturi alcoolice'
EXEC GetAllDishesByCategory
	@catName

--89. Creati o procedura stocata cu ajutorul careia sa afisati toti curierii care livreaza intr-o zona care incepe cu o anumita litera. Afisati si zonele respective
IF OBJECT_ID('GetAllCouriersFromShippingAreasByLetter','P') IS NOT NULL
	DROP PROC GetAllCouriersFromShippingAreasByLetter;
GO
CREATE PROC GetAllCouriersFromShippingAreasByLetter
	@startLetter AS NVARCHAR
AS 
BEGIN
	SELECT C.FirstName + ' ' + C.LastName AS 'Courier' , C.Phone, C.HireDate, S.City AS 'Shipping Area'
	FROM Couriers AS C
	INNER JOIN ShippingAreas AS S
	ON C.ShippingArea = S.LocationID
	WHERE S.City LIKE '' + @startLetter + '%';
	
	RETURN
END

DECLARE @letter AS NVARCHAR = 'B';
EXEC GetAllCouriersFromShippingAreasByLetter
	@letter

--90. Creati o procedura stocata cu ajutorul careia sa afisati toate produsele comandate intr-un anumit oras

IF OBJECT_ID('GetAllDishesByCity','P') IS NOT NULL
	DROP PROC GetAllDishesByCity;
GO
CREATE PROC GetAllDishesByCity
	@cityName AS NVARCHAR(50)
AS 
BEGIN
	SELECT DISTINCT D.Name AS 'Dish Name' 
	FROM Orders AS O
	INNER JOIN Receipt AS R
	ON O.OrderID = R.OrderID
	INNER JOIN Dishes AS D
	ON R.DishID = D.DishID
	WHERE O.City = @cityName;

	RETURN
END

DECLARE @city AS NVARCHAR(50) = 'Braila'
EXEC GetAllDishesByCity
	@city



--91. Creati o procedura stocata cu ajutorul careia sa afisati clientii al caror nume sau prenume se termina cu o  anumita litera si care au comandat un anumit produs

IF OBJECT_ID('GetAllClientsByLetterAndDish','P') IS NOT NULL
	DROP PROC GetAllClientsByLetterAndDish;
GO
CREATE PROC GetAllClientsByLetterAndDish
	@letter AS NVARCHAR,
	@dishName AS NVARCHAR(50)
AS 
BEGIN
	SELECT C.FirstName + ' ' + C.LastName AS 'Client' , C.City , C.Country , C.Phone
	FROM Receipt AS R
	INNER JOIN Orders AS O
	ON R.OrderID = O.OrderID
	INNER JOIN Clients AS C
	ON O.ClientID = C.ClientID
	INNER JOIN Dishes AS D
	ON R.DishID = D.DishID
	WHERE ((C.FirstName LIKE '%' + @letter + '') OR (C.LastName LIKE '%' + @letter + '')) AND D.Name = @dishName;

	RETURN
END

DECLARE @alpha NVARCHAR = 'e';
DECLARE @dish NVARCHAR(50) = 'Vita Argentina'
EXEC GetAllClientsByLetterAndDish
	@alpha,@dish

--92. Creati o procedura stocata cu ajutorul careia sa afisati suma totala cheltuita dintotdeauna pentru un anumit client

IF OBJECT_ID('GetCostsByClient','P') IS NOT NULL 
	DROP PROC GetCostsByClient;
GO
CREATE PROC GetCostsByClient
	@clientcompleteName AS NVARCHAR(50)
AS
BEGIN
	SELECT [Nume complet client],Total											-- am folosit un view deja creat
	FROM EachClientAllTimeTotal 
	WHERE [Nume complet client] = @clientcompleteName;


	RETURN
END

DECLARE @name AS NVARCHAR(50) = 'Andrei Istrate';
EXEC GetCostsByClient	
	@name



--93. Creati o procedura stocata cu ajutorul careia sa afisati suma totala cheltuita pe fiecare comanda pentru un anumit client

IF OBJECT_ID('GetEachOrderCostsByClient','P') IS NOT NULL 
	DROP PROC GetEachOrderCostsByClient;
GO
CREATE PROC GetEachOrderCostsByClient
	@clientcompleteName AS NVARCHAR(50)
AS
BEGIN
	SELECT [Nume complet client],Total											-- am folosit un view deja creat
	FROM EachClientTotal 
	WHERE [Nume complet client] = @clientcompleteName;


	RETURN
END

DECLARE @name AS NVARCHAR(50) = 'Andrei Istrate';
EXEC GetEachOrderCostsByClient	
	@name


--94. Creati o procedura stocata cu ajutorul careia sa afisati toate curierul care permisiunea de a livra cu un anumit autoturism , precum si marca acestuia

IF OBJECT_ID('GetCourierAndBrandByRegistrationNumber','P') IS NOT NULL
	DROP PROC GetCourierAndBrandByRegistrationNumber;
GO
CREATE PROC GetCourierAndBrandByRegistrationNumber
	@registrationNumber AS NVARCHAR(20)
AS
BEGIN
	SELECT C.FirstName + ' ' + C.LastName AS 'Courier', C.Phone , C.HireDate
	FROM Couriers AS C
	INNER JOIN Vehicles AS V
	ON C.CarID = V.CarID
	INNER JOIN AutoBrands AS AB
	ON V.BrandID = AB.BrandID
	WHERE V.RegistrationNumber = @registrationNumber;

	RETURN
END

SELECT * FROM Vehicles
DECLARE @rnumber AS NVARCHAR(20) = 'B66ERR';
EXEC GetCourierAndBrandByRegistrationNumber
	@rnumber


--95. Creati o procedura stocata cu ajutorul careia sa afisati toti curierii care au avut livrari intr-un anumit trimestru din an

IF OBJECT_ID('GetCouriersByQuarterShipping','P') IS NOT NULL
	DROP PROC GetCouriersByQuarterShipping
GO
CREATE PROC GetCouriersByQuarterShipping
	@quarter AS INT           -- 1,2,3 sau 4
AS 
BEGIN
	SELECT C.FirstName + ' ' + C.LastName AS 'Courier', C.Phone
	FROM Orders AS O
	INNER JOIN Couriers AS C
	ON O.CourierID = C.CourierID
	WHERE DATEPART(QUARTER,O.ExpectedDate) = @quarter;

	RETURN 
END

DECLARE @trimester AS INT = 1													
EXEC GetCouriersByQuarterShipping
	@trimester


--96. Creati o procedura stocata cu ajutorul careia sa afisati detalii despre autoturismele cu care s-au efectuat livrari intr-un anumit trimestru din an

IF OBJECT_ID('GetVehiclesByQuarterShipping','P') IS NOT NULL
	DROP PROC GetVehiclesByQuarterShipping
GO
CREATE PROC GetVehiclesByQuarterShipping
	@quarter AS INT           -- 1,2,3 sau 4
AS 
BEGIN
	SELECT DISTINCT V.RegistrationNumber, AB.BrandName
	FROM Orders AS O
	INNER JOIN Couriers AS C
	ON O.CourierID = C.CourierID
	INNER JOIN Vehicles AS V
	ON C.CarID = V.CarID
	INNER JOIN AutoBrands AS AB
	ON V.BrandID = AB.BrandID
	WHERE DATEPART(QUARTER,O.ExpectedDate) = @quarter;

	RETURN 
END

DECLARE @trimester AS INT = 1													
EXEC GetVehiclesByQuarterShipping
	@trimester




--97. Creati o procedura stocata cu ajutorul careia sa afisati detalii despre conturile clientilor care au comandat un anumit produs

IF OBJECT_ID('GetClientAccountDetailsByDish','P') IS NOT NULL
	DROP PROC GetClientAccountDetailsByDish;
GO
CREATE PROC GetClientAccountDetailsByDish
	@dishName AS NVARCHAR(50)
AS 
BEGIN
	WITH SelectedDishes AS
	(
		SELECT D.*									--cte
		FROM Dishes AS D
		WHERE D.Name = @dishName
	)
	SELECT CA.EmailAddress
	FROM SelectedDishes AS SD
	INNER JOIN Receipt AS R
	ON SD.DishID = R.DishID
	INNER JOIN Orders AS O
	ON O.OrderID = R.OrderID
	INNER JOIN Clients AS C
	ON C.ClientID = O.ClientID
	INNER JOIN ClientAccounts AS CA
	ON CA.ClientID = C.ClientID

	RETURN
END

DECLARE @dName AS NVARCHAR(50) = 'Creveti trasi la tigaie';
EXEC GetClientAccountDetailsByDish
	@dName



--98. Creati o procedura stocata cu ajutorul careia sa afisati toate produsele comandate intre 2 perioade de timp specifice, date ca parametru

IF OBJECT_ID('GetAllDishesBetweenDates','P') IS NOT NULL
	DROP PROC GetAllDishesBetweenDates;
GO
CREATE PROC GetAllDishesBetweenDates
	@startDate AS DATETIME,
	@endDate AS DATETIME
AS
BEGIN
	WITH SelectedDatetimeOrders AS
	(
		SELECT O.*
		FROM Orders AS O
		WHERE O.ExpectedDate >= @startDate AND O.ExpectedDate <= @endDate
	)
	SELECT DISTINCT D.Name AS 'Dish name'
	FROM SelectedDatetimeOrders AS O
	INNER JOIN Receipt AS R
	ON O.OrderID = R.OrderID
	INNER JOIN Dishes AS D
	ON D.DishID = R.DishID
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID;

	RETURN 
END

DECLARE @date1 AS DATETIME = '2021-01-01';
DECLARE @date2 AS DATETIME = '2021-05-30';
EXEC GetAllDishesBetweenDates
	@date1,@date2

--99. Creati o procedura stocata cu ajutorul careia sa afisati produsele dintr-o anumita categorie , livrate de un anumit curier

IF OBJECT_ID('GetAllDishesByCategoryAndCourier','P') IS NOT NULL
	DROP PROC GetAllDishesByCategoryAndCourier;
GO
CREATE PROC GetAllDishesByCategoryAndCourier
	@catName AS NVARCHAR(50),
	@courierName AS NVARCHAR(50)
AS
BEGIN
	WITH SelectedCategory AS
	(
		SELECT M.*
		FROM Menu AS M
		WHERE M.Category = @catName
	),
	SelectedCourier AS
	(
		SELECT C.*
		FROM Couriers AS C
		WHERE C.FirstName + ' ' + C.LastName = @courierName
	)
	SELECT D.Name
	FROM SelectedCategory AS M
	INNER JOIN Dishes AS D
	ON M.CategoryID = D.CategoryID
	INNER JOIN Receipt AS R
	ON D.DishID = R.DishID
	INNER JOIN Orders AS O
	ON R.OrderID = O.OrderID
	INNER JOIN SelectedCourier AS C
	ON O.CourierID = C.CourierID

	RETURN
END

DECLARE @catN AS NVARCHAR(50) = 'Sucuri';
DECLARE @name AS NVARCHAR(50) = 'Chirita Robert';
EXEC GetAllDishesByCategoryAndCourier
@catN,@name


--100. Creati o procedura stocata cu ajutorul careia sa afisati curierii si autoturismele cu care s-a livrat un anumit produs

IF OBJECT_ID('GetAllCouriersAndVehiclesByShippedDish','P') IS NOT NULL 
	DROP PROC GetAllCouriersAndVehiclesByShippedDish;
GO
CREATE PROC GetAllCouriersAndVehiclesByShippedDish
	@dishName AS NVARCHAR(50)
AS 
BEGIN
	WITH SelectedDish AS
	(
		SELECT D.Name,R.OrderID
		FROM Dishes AS D
		INNER JOIN Receipt AS R
		ON D.DishID = R.DishID
		WHERE D.Name = @dishName
	)
	SELECT C.FirstName + ' ' + C.LastName, V.RegistrationNumber , AB.BrandName
	FROM SelectedDish AS S
	INNER JOIN Orders AS O
	ON S.OrderID = O.OrderID
	INNER JOIN Couriers AS c
	ON O.CourierID = C.CourierID
	INNER JOIN Vehicles AS V
	ON C.CarID = V.CarID
	INNER JOIN AutoBrands AS AB
	ON V.BrandID = AB.BrandID
	
	RETURN
END

DECLARE @dishdescription AS NVARCHAR(50) =  'Creveti trasi la tigaie'
EXEC GetAllCouriersAndVehiclesByShippedDish
@dishdescription

