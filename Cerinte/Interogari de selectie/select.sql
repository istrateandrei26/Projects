select *FROM AutoBrands
select *FROM ClientAccounts
select *FROM Clients
select *FROM Couriers
select *FROM Dishes
select *FROM EmployeesTaxes
select *FROM Menu
select *FROM Orders
select *FROM Providers
select *FROM ProvidersDishesRelation
select *FROM Receipt
select *FROM ShippingAreas
select *FROM Taxes
select *FROM Vehicles


-- Utilizeaza baza de date Food Delivery
USE [Food Delivery]


--1. Afisati toti curierii din Galati
SELECT FirstName AS 'Prenume', LastName AS 'Nume' , Phone AS 'Nr. telefon' , City AS 'Oras'
FROM Couriers
WHERE City = 'Galati'

--2. Afisati toate felurile de mancare din categoria bauturi si din categoria deserturi , din meniul disponibil
SELECT DishID AS 'IDMancare' , Name AS 'Denumire' 
FROM Dishes AS D
inner join Menu AS M
ON D.CategoryID = M.CategoryID
WHERE M.Category = 'Bauturi alcoolice' or M.Category = 'Sucuri' or M.Category = 'Deserturi'


--3. Afisati toti curierii care livreaza in orasul Galati
SELECT FirstName AS 'Prenume', LastName AS 'Nume' , Phone AS 'Nr. telefon'
FROM Couriers AS C
inner join ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE S.City = 'Galati' and S.Country = 'Romania'

--4. Afisati paginile web ale furnizorilor din Bucuresti
SELECT Webpage AS 'Pagina Web' , City AS 'Oras'
FROM Providers
WHERE City = 'Bucuresti'

--5. Afisati adresele de email si numele complet pentru clientii care locuiesc in Brasov 
select CC.EmailAddress AS 'Adresa email', C.FirstName + ' ' + C.LastName AS 'Nume complet', C.City AS 'Oras'
FROM Clients AS C
inner join ClientAccounts AS CC
ON C.ClientID = CC.ClientID
WHERE C.City = 'Brasov' and Country = 'Romania'


--6. Afisati clientii care au efectuat comenzi in luna Mai
SELECT LastName AS 'Nume', FirstName AS 'Prenume' , O.ExpectedDate AS 'Data'
FROM Clients AS C
inner join Orders AS O
ON C.ClientID = O.ClientID
WHERE MONTH(O.ExpectedDate) = 5

--7. Afisati courierii cu domiciliul in Brasov ,care au livrat comenzile din lunile Aprilie si Mai   ***
SELECT FirstName AS 'Nume', LastName AS 'Prenume', Phone AS 'Nr. telefon' 
FROM Couriers AS C
inner join Orders AS O
ON C.CourierID = O.CourierID
inner join ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE S.City = 'Brasov' and S.Country = 'Romania'


--8. Afisati clientii care au comandat deserturi sau ciorbe  ***
select C.* , M.Category
FROM Orders AS O 
inner join Clients AS C
ON O.ClientID = C.ClientID
inner join Receipt AS R
ON O.OrderID = R.OrderID
inner join Dishes AS D
ON D.DishID = R.DishID
inner join Menu AS M
ON M.CategoryID = D.CategoryID
WHERE M.Category = 'Supe' or M.Category = 'Ciorbe'

--9. Afisati clientii care au comandat Salata   ***
select C.*
FROM Clients AS C
inner join Orders AS O
ON C.ClientID = O.ClientID
inner join Receipt AS R
ON O.OrderID = R.OrderID
inner join Dishes AS D
ON R.DishID = R.DishID
inner join Menu AS M
ON M.CategoryID = D.CategoryID
WHERE M.Category LIKE '%Salata%'

--10. Afisati cati curieri livreaza in bucuresti
SELECT COUNT(*) AS 'Numar curieri care livreaza in Bucuresti'
FROM Couriers AS C
inner join ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE S.City LIKE '%Bucuresti%' and S.Country = 'Romania'

--11. Afisati clientii din Cluj + ce feluri de mancare au comandat acestia ***
SELECT C.FirstName AS 'Prenume' , C.LastName AS 'Nume' ,C.City AS 'Oras' ,D.Name AS 'Denumire fel de mancare'
FROM Clients AS C
inner join Orders AS O
ON C.ClientID = O.ClientID
inner join Receipt AS R
ON O.OrderID = R.OrderID
inner join Dishes AS D
ON D.DishID = R.DishID
inner join Menu as M
ON M.CategoryID = D.CategoryID
WHERE C.City = 'Cluj' and C.Country = 'Romania'


--12. Afisati adresele de email si parolele clientilor care au comandat ciorbe sau supe ***
SELECT C.FirstName AS 'Prenume' , LastName AS 'Nume' , Cacc.EmailAddress AS 'Adresa email' , Cacc.Password AS 'Parola'
FROM Clients AS C
inner join Orders AS O
ON C.ClientID = O.ClientID
inner join Receipt AS R
ON R.OrderID = O.OrderID
inner join Dishes AS D
ON D.DishID = R.DishID
inner join Menu AS M
ON M.CategoryID = D.CategoryID
inner join ClientAccounts AS Cacc
ON Cacc.ClientID = C.ClientID
WHERE M.Category = 'Supe' or M.Category = 'Ciorbe'

--13. Afisati detalii despre furnizorii care au oferit produse din gama de deserturi ***
SELECT DISTINCT P.*
FROM ProvidersDishesRelation AS PD
inner join Dishes AS D
ON D.DishID = PD.DishID
inner join Providers AS P
ON P.ProviderID = PD.ProviderID
inner join Menu AS M
ON M.CategoryID = D.CategoryID
WHERE M.Category = 'Deserturi'

--14. Afisati cate comenzi a efectuat fiecare client , precum si detaliile acestuia **
SELECT COUNT(*) AS 'Numar comenzi' , MAX(C.FirstName + ' ' + C.LastName) AS 'Nume complet'
FROM Orders AS O
inner join Clients AS C
ON O.ClientID = C.ClientID
GROUP BY O.ClientID

--15. Afisati detalii despre vehiculele curierilor care livreaza in Timisoara + detalii despre curieri ***
SELECT V.RegistrationNumber AS 'Numar de inmatriculare', B.BrandName AS 'Marca', C.LastName + ' ' + C.FirstName AS 'Nume complet al curierului'
FROM Couriers AS C
inner join Vehicles AS V
ON C.CarID = V.CarID
inner join ShippingAreas AS S
ON S.LocationID = C.ShippingArea
inner join AutoBrands AS B
ON B.BrandID = V.BrandID
WHERE S.City = 'Timisoara' and S.Country = 'Romania'

--16. Afisati curierul/ curierii(in cazul acelorasi valori) cu salariul cel mai mare, precum si detalii despre masina cu care livreaza ***

DECLARE @max_wage int
SET @max_wage = 
(
	SELECT TOP 1 Salary
	FROM Couriers
	ORDER BY Salary DESC
)
SELECT @max_wage

SELECT C.LastName + ' ' + C.FirstName AS 'Nume complet' ,V.RegistrationNumber AS 'Numar inmatriculare' , A.BrandName AS 'Marca'
FROM Couriers AS C
inner join Vehicles AS V
ON C.CarID = V.CarID
inner join AutoBrands AS A
ON A.BrandID = V.BrandID
WHERE Salary = @max_wage


--17. Afisati clientii si valoarea platilor pe fiecare comanda efectuata ****
SELECT Clients.ClientID,max(Clients.FirstName + ' ' + Clients.LastName) AS 'Nume complet client' , SUM(R.UnitPrice*R.Quantity) - max(R.Voucher) AS Total
FROM Receipt AS R inner join Orders AS O
ON R.OrderID = O.OrderID
inner join Clients 
ON O.ClientID = Clients.ClientID
inner join Dishes
ON Dishes.DishID = R.DishID
GROUP BY Clients.ClientID, O.OrderID
;
--18. Afisati clientul care a efectuat comanda cu cea mai mare valoare ****

WITH C(ID,Name,TotalPrice) 
AS
(
	SELECT Clients.ClientID,max(Clients.FirstName + ' ' + Clients.LastName) AS 'Nume complet client' , SUM(R.UnitPrice*R.Quantity) - max(R.Voucher) AS Total
	FROM Receipt AS R inner join Orders AS O
	ON R.OrderID = O.OrderID
	inner join Clients 
	ON O.ClientID = Clients.ClientID
	inner join Dishes
	ON Dishes.DishID = R.DishID
	GROUP BY Clients.ClientID, O.OrderID
)
	SELECT TOP 1 Name AS 'Nume complet client' , TotalPrice as 'Total'
	FROM C
	ORDER BY TotalPrice DESC

--19. Afisati toate comenzile din luna Aprilie, clientii care le-au efectuat si curierii care le-au livrat ***

SELECT O.* , C.FirstName + ' ' + C.LastName AS 'Nume complet curier' , Cl.FirstName + ' ' + Cl.LastName AS 'Nume complet client'  
FROM Orders AS O 
inner join Couriers AS C
ON C.CourierID = O.CourierID
inner join Clients AS Cl
ON Cl.ClientID = O.ClientID
WHERE MONTH(O.ExpectedDate) = 4

--20. Afisati ce au comandat clientii din Brasov si pretul unitar al produselor respective ***

SELECT D.Name , R.UnitPrice
FROM Orders AS O 
inner join Receipt AS R
ON O.OrderID = R.OrderID
inner join Clients AS C
ON C.ClientID = O.ClientID
inner join Dishes AS D
ON R.DishID = D.DishID
WHERE C.City = 'Brasov' and C.Country = 'Romania'


--21. Afisati parolele conturilor , dar si adresele de email ale clientilor din Braila

SELECT CA.Password AS 'Parola', CA.EmailAddress AS 'Adresa email'
FROM Clients AS C
INNER JOIN ClientAccounts AS CA
ON C.ClientID = CA.ClientID
WHERE C.City = 'Braila'

--22. Afisati curierii care conduc masini Volkswagen si pe cei care conduc Renault

SELECT C.CourierID,C.FirstName AS 'Nume' ,C.LastName AS 'Prenume' , AB.BrandName AS 'Brand'
FROM Couriers AS C
INNER JOIN Vehicles AS V
ON C.CarID = V.CarID
INNER JOIN AutoBrands AS AB
ON AB.BrandID = V.BrandID
WHERE AB.BrandName = 'Volkswagen' or AB.BrandName = 'Renault'


--23. Afisati curierii care nu locuiesc in orasul in care sunt responsabili sa livreze

SELECT C.CourierID, C.FirstName AS 'Nume', C.LastName AS 'Prenume', C.City AS 'Oras natal', C.Country AS 'Tara', S.City AS 'Orasul in care livreaza'
FROM Couriers AS C
INNER JOIN ShippingAreas AS S
ON S.LocationID = C.ShippingArea
WHERE C.City <> S.City and S.City NOT LIKE '%' + C.City + '%'										

--24. Afisati toate felurile de mancare din meniu care au fost livrate pana in prezent 

SELECT DISTINCT D.* 
FROM Dishes AS D
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
INNER JOIN Receipt AS R
ON D.DishID = R.DishID
INNER JOIN Orders AS O 
ON R.OrderID = O.OrderID
WHERE O.ExpectedDate < GETDATE()

--25. Afisati ce masini utilizeaza curierii care au livrat produse din categoria 'Bauturi'

SELECT C.CourierID , C.FirstName AS 'Nume', C.LastName AS 'Prenume', V.RegistrationNumber AS 'Numar de inmatriculare', AB.BrandName AS 'Marca'
FROM Vehicles AS V
INNER JOIN AutoBrands AS AB
ON V.BrandID = AB.BrandID
INNER JOIN Couriers AS C
ON C.CarID = V.CarID
INNER JOIN Orders AS O
ON O.CourierID = C.CourierID
INNER JOIN Receipt AS R
ON R.OrderID = O.OrderID
INNER JOIN Dishes AS D
ON D.DishID = R.DishID
INNER JOIN Menu AS M
ON M.CategoryID = D.CategoryID
WHERE M.Category = 'Bauturi alcoolice' or M.Category = 'Sucuri' 

--26. Afisati clientii care au comandat ciorbe sau supe , dar care au alta adresa de livrare fata de cea personala

SELECT DISTINCT C.* , O.Address AS 'Adresa de livrare'
FROM Clients AS C
INNER JOIN Orders AS O
ON C.ClientID = O.ClientID
INNER JOIN Receipt AS R
ON R.OrderID = O.OrderID
INNER JOIN Dishes AS D
ON D.DishID = R.DishID
INNER JOIN Menu AS M
ON M.CategoryID = D.CategoryID
WHERE O.Address <> C.Address

--27. Afisati toate facturile comenzilor solicitate cu adresa de livrare in Brasov, precum si denumirile si categoriile produselor de pe acestea

SELECT R.* ,D.Name AS 'Denumire' , M.Category AS 'Categorie'
FROM Receipt AS R
INNER JOIN Orders AS O
ON R.OrderID = O.OrderID
INNER JOIN Dishes AS D
ON D.DishID = R.DishID
INNER JOIN Menu AS M
ON M.CategoryID = D.CategoryID
WHERE O.City = 'Brasov' and O.Country = 'Romania'

--28. Afisati numele si paginile web ale companiilor care au furnizat dulciuri, precum si denumirile de catalog ale dulciurilor furnizate

SELECT P.CompanyName, P.Webpage, D.Name AS 'Denumire'
FROM Providers AS P
INNER JOIN ProvidersDishesRelation AS PDR
ON P.ProviderID = PDR.ProviderID
INNER JOIN Dishes AS D
ON PDR.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
WHERE M.Category = 'Deserturi'

--29. Afisati toate detaliile conturilor clientilor ale caror comenzi au fost livrate cu masini de marca Volkswagen

SELECT CA.*
FROM ClientAccounts AS CA 
INNER JOIN Clients AS C
ON CA.ClientID = C.ClientID
INNER JOIN Orders AS O
ON O.ClientID = C.ClientID
INNER JOIN Couriers AS Co
ON Co.CourierID = O.CourierID
INNER JOIN Vehicles AS V
ON V.CarID = Co.CarID
INNER JOIN AutoBrands AS AB
ON AB.BrandID = V.BrandID
WHERE AB.BrandName = 'Volkswagen'

--30. Afisati curierii care au fost angajati in a doua luna a anului curent , precum si masinile conduse de acestia, cu toate detaliile

SELECT C.CourierID, C.FirstName AS 'Nume', C.LastName AS 'Prenume', V.RegistrationNumber AS 'Numar de inmatriculare autoturism' , AB.BrandName AS 'Marca autoturism'
FROM Couriers AS C
INNER JOIN Vehicles AS V
ON C.CarID = V.CarID
INNER JOIN AutoBrands AS AB
ON V.BrandID = AB.BrandID
WHERE MONTH(C.HireDate) = 2 AND YEAR(C.HireDate) = YEAR(GETDATE())


--31. Afisati in ce zona au livrat(daca a livrat) curierii al caror nume incepe cu litera M , precum si detaliile autoturismului pe care l-a folosit

SELECT C.FirstName AS 'Nume' , C.LastName AS 'Prenume', V.RegistrationNumber AS 'Nr. inmatriculare' ,AB.BrandName AS 'Marca'
FROM Couriers AS C
INNER JOIN Orders AS O
ON C.CourierID = O.CourierID
INNER JOIN Vehicles AS V
ON C.CarID = V.CarID
INNER JOIN AutoBrands AS AB
ON AB.BrandID = V.BrandID
WHERE C.FirstName LIKE 'M%'

--32. Afisati curierii care au salariul brut mai mic de 4000 unitati si care au livrat bauturi de orice fel 

SELECT C.*
FROM Couriers AS C
INNER JOIN Orders AS O
ON C.CourierID = O.CourierID
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
WHERE (M.Category = 'Bauturi' OR M.Category = 'Sucuri') AND C.Salary < 4000 


--33. Afisati zonele de livrare in care au fost efectuate comenzi care sa fi continut supe / ciorbe in primul trimestru al anului curent. 

SELECT DISTINCT S.* 
FROM Couriers AS C
INNER JOIN Orders AS O
ON C.CourierID = O.CourierID
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
INNER JOIN Receipt AS R
ON R.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
WHERE M.Category = 'Supe' OR M.Category = 'Ciorbe' AND DATEDIFF(YEAR,O.ExpectedDate,GETDATE()) = 0 AND DATEPART(QUARTER,O.ExpectedDate) = 1


--34. Afisati clientii care au comandat preparate din carne de vita , pentru care suma totala a comenzii a depasit 50 unitati

WITH C(ID,Name,TotalPrice) 
AS
(
	SELECT Clients.ClientID,max(Clients.FirstName + ' ' + Clients.LastName) AS 'Nume complet client' , SUM(R.UnitPrice*R.Quantity) - max(R.Voucher) AS Total
	FROM Receipt AS R 
	INNER JOIN Orders AS O
	ON R.OrderID = O.OrderID
	INNER JOIN Clients 
	ON O.ClientID = Clients.ClientID
	INNER JOIN Dishes
	ON Dishes.DishID = R.DishID
	INNER JOIN Menu AS M
	ON Dishes.CategoryID = M.CategoryID
	WHERE M.Category = 'Preparate carne de vita'
	GROUP BY Clients.ClientID, O.OrderID
)
	SELECT Name AS 'Nume complet client' , TotalPrice as 'Total'
	FROM C
	WHERE TotalPrice > 50

--35. Afisati toti clientii al caror nume incepe cu litera 'A' ,care au comandat desert in prima luna din anul curent 

SELECT DISTINCT C.* 
FROM Clients AS C
INNER JOIN Orders AS O
ON C.ClientID = O.ClientID
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M 
ON D.CategoryID = M.CategoryID
WHERE M.Category = 'Deserturi' AND C.LastName LIKE 'A%'

--36. Afisati autoturismele cu care s-au livrat comenzi care sa contina produse din categoria 'Peste'

SELECT V.RegistrationNumber AS 'Nr. inmatriculare' , AB.BrandName AS 'Marca', R.OrderID AS 'Id comanda'
FROM Orders AS O
INNER JOIN Couriers AS C
ON O.CourierID = C.CourierID
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
INNER JOIN Vehicles AS V
ON C.CarID = V.CarID
INNER JOIN AutoBrands AS AB
ON V.BrandID = AB.BrandID
WHERE M.Category = 'Peste'
	
--37. Afisati clientii care au efectuat comenzi in valoare de sub 80 unitati si locuiesc in Brasov

WITH C(ID,Name,TotalPrice,City) 
AS
(
	SELECT Clients.ClientID,max(Clients.FirstName + ' ' + Clients.LastName) AS 'Nume client' , SUM(R.UnitPrice*R.Quantity) - max(R.Voucher) AS Total , max(Clients.City)
	FROM Receipt AS R 
	INNER JOIN Orders AS O
	ON R.OrderID = O.OrderID
	INNER JOIN Clients 
	ON O.ClientID = Clients.ClientID
	WHERE Clients.City = 'Brasov'
	GROUP BY Clients.ClientID, O.OrderID
)
	SELECT Name AS 'Nume client' , TotalPrice as 'Total'
	FROM C
	WHERE TotalPrice < 80


--38. Afisati salariul brut al curierilor care au efectuat comenzi care sa contina pe factura aferenta deserturi 

SELECT C.FirstName + C.LastName AS 'Nume complet curier' , C.Salary
FROM Couriers AS C
INNER JOIN Orders AS O
ON C.CourierID = O.CourierID
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID 
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M 
ON D.CategoryID = M.CategoryID
WHERE M.Category = 'Deserturi'

--39. Afisati zonele in care s-au livrat comenzi cu autoturisme de marca 'Renault'

SELECT S.*
FROM Couriers AS C
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
INNER JOIN Orders AS O 
ON O.CourierID = C.CourierID 
INNER JOIN Vehicles AS V
ON C.CarID = V.CarID
INNER JOIN AutoBrands AS AB
ON V.BrandID = AB.BrandID
WHERE AB.BrandName = 'Renault'

--40. Afisati adresa de email a clientilor care au comandat bauturi alcoolice in luna aprilie

SELECT CA.EmailAddress
FROM Clients AS C
INNER JOIN Orders AS O
ON C.ClientID = O.ClientID
INNER JOIN Receipt AS R
ON R.OrderID = O.OrderID
INNER JOIN Dishes AS D
ON D.DishID = R.DishID
INNER JOIN Menu AS M
ON M.CategoryID = D.CategoryID
INNER JOIN ClientAccounts AS CA
ON C.ClientID = CA.ClientID
WHERE M.Category = 'Bauturi alcoolice' AND MONTH(O.ExpectedDate) = 4;


	



