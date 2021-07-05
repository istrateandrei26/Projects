USE [Food Delivery]

--71. Creati un view pentru a afisa toti clientii(doar prenumele) , dar si conturile si parolele acestora

IF OBJECT_ID('OrderClientsByName', 'V') IS NOT NULL
	DROP VIEW OrderClientsByName
GO
CREATE VIEW OrderClientsByName AS 
	SELECT C.FirstName, CA.EmailAddress , CA.Password
	FROM Clients AS C
	INNER JOIN ClientAccounts AS CA
	ON C.ClientID = CA.ClientID

	--testare view
SELECT *FROM OrderClientsByName
ORDER BY FirstName ASC

--72. Creati un view care sa afiseze totalul fiecarei comenzi pentru fiecare client

IF OBJECT_ID('EachClientTotal','V') IS NOT NULL
	DROP VIEW EachClientTotal
GO
CREATE VIEW EachClientTotal AS
	SELECT Clients.ClientID,max(Clients.FirstName + ' ' + Clients.LastName) AS 'Nume complet client' , SUM(R.UnitPrice*R.Quantity) AS Total
	FROM Receipt AS R inner join Orders AS O
	ON R.OrderID = O.OrderID
	inner join Clients 
	ON O.ClientID = Clients.ClientID
	inner join Dishes
	ON Dishes.DishID = R.DishID
	GROUP BY Clients.ClientID, O.OrderID
	

	--testare view
SELECT *FROM EachClientTotal
ORDER BY [Nume complet client] , Total ASC

	--testare view , afisati clientul cu cea mai mica valoare a comenzii . Observatie : clientul sa fie afisat cu toate detaliile acestuia
SELECT TOP 1 C.*
FROM EachClientTotal AS E
INNER JOIN Clients AS C
ON E.ClientID = C.ClientID
ORDER BY Total ASC

--73. Creati un view care sa afiseze totalul vanzarilor catre fiecare client

IF OBJECT_ID('EachClientAllTimeTotal','V') IS NOT NULL
	DROP VIEW EachClientAllTimeTotal
GO
CREATE VIEW EachClientAllTimeTotal AS
	SELECT Clients.ClientID,max(Clients.FirstName + ' ' + Clients.LastName) AS 'Nume complet client' , SUM(R.UnitPrice*R.Quantity) AS Total
	FROM Receipt AS R inner join Orders AS O
	ON R.OrderID = O.OrderID
	inner join Clients 
	ON O.ClientID = Clients.ClientID
	inner join Dishes
	ON Dishes.DishID = R.DishID
	GROUP BY Clients.ClientID

	--testare view
SELECT *FROM EachClientAllTimeTotal
ORDER BY Total DESC


--74. Creati un view care sa afiseze numele si paginile web ale companiilor care au furnizat dulciuri, precum si denumirile de catalog ale dulciurilor furnizate

IF OBJECT_ID('SweetsCompanyDetails','V') IS NOT NULL
	DROP VIEW SweetsCompanyDetails
GO
CREATE VIEW SweetsCompanyDetails AS
	SELECT P.CompanyName, P.Webpage, D.Name AS 'Denumire'
	FROM Providers AS P
	INNER JOIN ProvidersDishesRelation AS PDR
	ON P.ProviderID = PDR.ProviderID
	INNER JOIN Dishes AS D
	ON PDR.DishID = D.DishID
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	WHERE M.Category = 'Deserturi'

	--testare view
SELECT *FROM SweetsCompanyDetails


--75. Creati un view care sa afiseze toti curierii , pe care il veti putea folosi pentru filtrari ulterioare

IF OBJECT_ID('AllCouriers','V') IS NOT NULL
	DROP VIEW AllCouriers
GO
CREATE VIEW AllCouriers AS
	SELECT *FROM Couriers

	--testare view cu filtrare
SELECT *
FROM AllCouriers 
WHERE City = 'Brasov'
ORDER BY Salary ASC

--76. Creati un view care sa afiseze toate felurile de mancare / produse puse la dispozitie 

IF OBJECT_ID('AllDishes','V') IS NOT NULL
	DROP VIEW AllDishes
GO
CREATE VIEW AllDishes AS
	SELECT *FROM Dishes

	--testare view cu filtrare, dorim sa afisam produsele din categoria dulciuri + bauturi de orice tip
	SELECT D.*
	FROM AllDishes AS D
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	WHERE M.Category = 'Sucuri' OR M.Category = 'Bauturi alcoolice' OR M.Category = 'Deserturi'

--77. Creati un view care sa afiseze toate autoturismele disponibile , impreuna cu detalii despre acestea

IF OBJECT_ID('AllCars','V') IS NOT NULL
	DROP VIEW AllCars
GO
CREATE VIEW AllCars AS
	SELECT V.RegistrationNumber, AB.BrandName
	FROM Vehicles AS V
	INNER JOIN AutoBrands AS AB
	ON V.BrandID = AB.BrandID

	--testare view -> afisati toate autoturismele inmatriculate pe orasul Constanta si curierul aferent
SELECT *
FROM AllCars AS C
WHERE SUBSTRING(RegistrationNumber,1,2) = 'CT'

--78. Creati un view care care sa afiseze toate zonele de livrare disponibile

IF OBJECT_ID('AllShippingAreas','V') IS NOT NULL
	DROP VIEW AllShippingAreas
GO
CREATE VIEW AllShippingAreas AS
	SELECT *
	FROM ShippingAreas

	--testare view
SELECT S.*
FROM AllShippingAreas AS S
WHERE S.City LIKE '%Bucuresti%'

--79. Creați un view pentru a calcula totalul vânzărilor pe ani

IF OBJECT_ID('Total vanzari pe ani','V') IS NOT NULL
	DROP VIEW [Total vanzari pe ani]
GO
CREATE VIEW [Total vanzari pe ani] AS
	SELECT year(O.ExpectedDate) as An , sum(R.UnitPrice*R.Quantity -R.Voucher) as Vanzari
	FROM Receipt AS R
	INNER JOIN Orders O
	ON R.OrderID = O.OrderID
	GROUP BY year(O.ExpectedDate)

	--testare view 
SELECT *
FROM [Total vanzari pe ani]

--80. Creati un view care sa afiseze toti furnizorii disponibili

IF OBJECT_ID('AllProviders','V') IS NOT NULL
	DROP VIEW AllProviders
GO
CREATE VIEW AllProviders AS
	SELECT *
	FROM Providers

	--testare view
SELECT *
FROM AllProviders










