
USE [Food Delivery]

--116. Afisati toti curierii care livreaza in orasul Galati ,dar si pe cei care livreaza in orasul Timisoara
SELECT FirstName AS 'Prenume', LastName AS 'Nume' , Phone AS 'Nr. telefon'
FROM Couriers AS C
inner join ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE S.City = 'Galati' and S.Country = 'Romania'
UNION
SELECT FirstName AS 'Prenume', LastName AS 'Nume' , Phone AS 'Nr. telefon'
FROM Couriers AS C
inner join ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE S.City = 'Timisoara' and S.Country = 'Romania'

--117. Afisati orasele in care activeaza curierii si orasele in care locuiesc clientii ( din Romania )

SELECT C.City
FROM Couriers AS C
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE S.Country = 'Romania'
UNION
SELECT Cl.City
FROM Clients AS Cl
WHERE Cl.Country = 'Romania'

--118. Afisati orasele in care se afla atat clienti, cat si curieri care livreaza acolo

SELECT S.City
FROM Couriers AS C
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE S.Country = 'Romania'
INTERSECT
SELECT Cl.City
FROM Clients AS Cl
WHERE Cl.Country = 'Romania'



--119. Afisati orasele in care s-au livrat produse din categoria 'Ciorbe' , dar in care nu s-au livrat produse din categoria 'Supe'

SELECT O.City
FROM Orders AS O
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
INNER JOIN Couriers AS C
ON O.CourierID = C.CourierID
WHERE M.Category = 'Ciorbe'
EXCEPT
SELECT O.City
FROM Orders AS O
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
INNER JOIN Couriers AS C
ON O.CourierID = C.CourierID
WHERE M.Category = 'Supe'

--120. Afisati clientii care au comandat bauturi alcoolice si nu au comandat sucuri

SELECT DISTINCT C.FirstName + ' ' + C.LastName AS 'Nume client'
FROM Orders AS O
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
INNER JOIN Clients AS C
ON O.ClientID = C.ClientID
WHERE M.Category = 'Bauturi alcoolice'
EXCEPT
SELECT DISTINCT C.FirstName + ' ' + C.LastName AS 'Nume client'
FROM Orders AS O
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
INNER JOIN Clients AS C
ON O.ClientID = C.ClientID
WHERE M.Category = 'Sucuri'

--121. Afisati cati clienti au solicitat comenzi in al doilea trimestru al anului curent

WITH 
ClientsWhoOrderedSomething AS
(
	SELECT C.ClientID, O.ExpectedDate
	FROM Clients AS C
	INNER JOIN Orders AS O
	ON C.ClientID = O.ClientID
),
SelectedClients AS
(
	SELECT CO.ClientID
	FROM ClientsWhoOrderedSomething AS CO
	WHERE DATEDIFF(YEAR,CO.ExpectedDate,GETDATE()) = 0 AND DATEPART(QUARTER,CO.ExpectedDate) = 2
)
SELECT COUNT(*) AS 'Numar clienti'
FROM SelectedClients;

--122. Afisati cate comenzi a avut fiecare client (alltime) 

WITH 
GroupedClients AS
(
	SELECT C.ClientID, COUNT(*) AS 'Numar comenzi'
	FROM Orders AS O
	INNER JOIN Clients AS C
	ON O.ClientID = C.ClientID
	GROUP BY C.ClientID
)
SELECT C.FirstName + ' ' + C.LastName AS 'Nume client' , G.[Numar comenzi]
FROM GroupedClients AS G
INNER JOIN Clients AS C
ON G.ClientID = C.ClientID

--123. Afisati toti clientii care au efectuat exact 2 comenzi

WITH 
GroupedClients AS
(
	SELECT C.ClientID, COUNT(*) AS 'Numar comenzi'
	FROM Orders AS O
	INNER JOIN Clients AS C
	ON O.ClientID = C.ClientID
	GROUP BY C.ClientID
)
SELECT C.FirstName + ' ' + C.LastName AS 'Nume client'
FROM GroupedClients AS G
INNER JOIN Clients AS C
ON G.ClientID = C.ClientID
WHERE G.[Numar comenzi] = 2;


--124. Afisati cate comenzi au fost livrate in fiecare oras , precum si numele orasului respectiv

WITH 
SelectedOrders AS
(
	SELECT O.OrderID, C.ShippingArea, O.ClientID
	FROM Orders AS O
	INNER JOIN Receipt AS R
	ON O.OrderID = R.OrderID
	INNER JOIN Couriers AS C
	ON O.CourierID = C.CourierID
)
,
GroupedOrdersByCity AS
(
	SELECT COUNT(*) AS 'Numar comenzi',O.ShippingArea
	FROM SelectedOrders AS O
	INNER JOIN ShippingAreas AS S
	ON O.ShippingArea = S.LocationID
	GROUP BY O.ShippingArea
)
SELECT S.City AS 'Oras' , G.[Numar comenzi]
FROM GroupedOrdersByCity AS G
INNER JOIN ShippingAreas AS S
ON G.ShippingArea = S.LocationID


--125. Afisati orasele in care au fost livrate cel putin 7 comenzi

WITH 
SelectedOrders AS
(
	SELECT O.OrderID, C.ShippingArea, O.ClientID
	FROM Orders AS O
	INNER JOIN Receipt AS R
	ON O.OrderID = R.OrderID
	INNER JOIN Couriers AS C
	ON O.CourierID = C.CourierID
)
,
GroupedOrdersByCity AS
(
	SELECT COUNT(*) AS 'Numar comenzi',O.ShippingArea
	FROM SelectedOrders AS O
	INNER JOIN ShippingAreas AS S
	ON O.ShippingArea = S.LocationID
	GROUP BY O.ShippingArea
	HAVING COUNT(*) >=7
)
SELECT S.City AS 'Oras' , G.[Numar comenzi]
FROM GroupedOrdersByCity AS G
INNER JOIN ShippingAreas AS S
ON G.ShippingArea = S.LocationID

--126. Afisati numarul de comenzi pentru fiecare client din orasul Brasov

WITH 
GroupedClients AS
(
	SELECT C.ClientID, COUNT(*) AS 'Numar comenzi'
	FROM Orders AS O
	INNER JOIN Clients AS C
	ON O.ClientID = C.ClientID
	GROUP BY C.ClientID
)
SELECT C.FirstName + ' ' + C.LastName AS 'Nume' , G.[Numar comenzi]
FROM GroupedClients AS G
INNER JOIN Clients AS C
ON G.ClientID = C.ClientID
WHERE C.City = 'Brasov';


--127. Afisati produsul cel mai scump de pe fiecare factura, dar si numele produsului si categoria

WITH 
SelectedProducts AS
(
	SELECT max(R.UnitPrice) as 'Cel mai scump produs de pe factura', R.OrderID
	FROM Receipt AS R
	GROUP BY R.OrderID
)
SELECT S.[Cel mai scump produs de pe factura], D.Name AS 'Nume produs', M.Category AS 'Categorie', S.OrderID AS 'Id comanda' 
FROM SelectedProducts AS S
INNER JOIN Receipt AS R
ON S.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
WHERE R.UnitPrice = S.[Cel mai scump produs de pe factura]



--128. Afisati pentru fiecare comanda ID-ul si valoarea totala a acesteia 

SELECT R.OrderID, SUM(R.UnitPrice*R.Quantity) - max(R.Voucher)
FROM Receipt AS R
GROUP BY R.OrderID;

--129. In plus fata de interogarea anterioara, afisati si denumirea clientului 

WITH
SelectedOrders AS
(
	SELECT R.OrderID, SUM(R.UnitPrice*R.Quantity) - max(R.Voucher) AS 'Valoare comanda'
	FROM Receipt AS R
	GROUP BY R.OrderID
)
SELECT S.OrderID, C.FirstName + ' ' + C.LastName AS 'Nume complet client', S.[Valoare comanda] 
FROM SelectedOrders AS S
INNER JOIN Orders AS O
ON S.OrderID = O.OrderID
INNER JOIN Clients AS C
ON O.ClientID = C.ClientID;

--130. La interogarea anterioara , rafinati astfel incat sa afisati fiecare comanda din anul 2021, luna 5  ->  valoarea acesteia si numele clientului 

WITH
SelectedOrders AS
(
	SELECT R.OrderID, SUM(R.UnitPrice*R.Quantity) - max(R.Voucher) AS 'Valoare comanda'
	FROM Receipt AS R
	GROUP BY R.OrderID
)
SELECT S.OrderID, C.FirstName + ' ' + C.LastName AS 'Nume complet client', S.[Valoare comanda] , O .ExpectedDate AS 'Data comenzii'
FROM SelectedOrders AS S
INNER JOIN Orders AS O
ON S.OrderID = O.OrderID
INNER JOIN Clients AS C
ON O.ClientID = C.ClientID
WHERE YEAR(O.ExpectedDate) = 2021 AND MONTH(O.ExpectedDate) = 5;



--131. Afisati cate tipuri de taxe plateste fiecare curier , din salariul lui brut; Afisati si numele fiecarui curier

WITH 
SelectedCouriers AS 
(
	SELECT COUNT(*) AS 'Nr. taxe', C.CourierID
	FROM Couriers AS C
	INNER JOIN EmployeesTaxes AS ET
	ON C.CourierID = ET.EmployeeID
	GROUP BY C.CourierID
)
SELECT Cc.FirstName + ' ' + Cc.LastName  AS 'Nume' , C.[Nr. taxe]
FROM SelectedCouriers AS C
INNER JOIN Couriers AS Cc
ON C.CourierID = Cc.CourierID

--131. Afisati numele tuturor curierilor si salariul net al acestora 

WITH
SelectedCourierTaxes AS
(
	SELECT SUM(T.Percentage) AS 'Scaderi totale', ET.EmployeeID
	FROM EmployeesTaxes AS ET
	INNER JOIN Taxes AS T
	ON ET.TaxID = T.TaxID
	GROUP BY ET.EmployeeID
)
SELECT C.FirstName + ' ' + C.LastName AS 'Nume curier', C.Salary AS 'Salariu brut',CAST((1-T.[Scaderi totale])*C.Salary AS DECIMAL(10,2)) --CONVERT(DECIMAL(10,2),(1-T.[Scaderi totale])* C.Salary) AS 'Salariu net'
FROM SelectedCourierTaxes AS T
INNER JOIN Couriers AS C
ON T.EmployeeID = C.CourierID

--132. Aflati ce suma totala este redirectionata din salariul tuturor curierilor catre CASS ( asigurari de sanatate )

DECLARE @percentageValue REAL;

SELECT @percentageValue = T.Percentage
FROM Taxes AS T
WHERE T.Description LIKE '%sanatate%'


SELECT SUM(C.Salary) AS 'Valoare totala salarii',@percentageValue*SUM(C.Salary) AS 'Valoare totala redirectionata catre CASS'
FROM Couriers AS C;


--133. Aflati ce suma este redirectionata din salariul fiecarui curier catre CASS 

WITH
SelectedCourierTaxes AS
(
	SELECT SUM(T.Percentage) AS 'Scaderi catre CASS', ET.EmployeeID
	FROM EmployeesTaxes AS ET
	INNER JOIN Taxes AS T
	ON ET.TaxID = T.TaxID
	WHERE T.Description LIKE '%sanatate%'
	GROUP BY ET.EmployeeID
)
SELECT C.FirstName + ' ' + C.LastName AS 'Nume curier', C.Salary AS 'Salariu brut',CONVERT(DECIMAL(10,2),T.[Scaderi catre CASS]* C.Salary) AS 'Suma redirectionata catre CASS'
FROM SelectedCourierTaxes AS T
INNER JOIN Couriers AS C
ON T.EmployeeID = C.CourierID

--134. Aflati ce suma este redirectionata din salariul fiecarui curier catre fiecare institutie care incaseaza taxe

WITH
SelectedCourierTaxes AS
(
	SELECT SUM(T.Percentage) AS 'Scaderi catre orice', ET.EmployeeID, T.TaxID
	FROM EmployeesTaxes AS ET
	INNER JOIN Taxes AS T
	ON ET.TaxID = T.TaxID
	GROUP BY ET.EmployeeID , T.TaxID
)
SELECT C.FirstName + ' ' + C.LastName AS 'Nume curier', C.Salary AS 'Salariu brut',CAST(CONVERT(DECIMAL(10,2),T.[Scaderi catre orice]* C.Salary) AS NVARCHAR) + ' ,' + Ta.Description AS 'Details'
FROM SelectedCourierTaxes AS T
INNER JOIN Couriers AS C
ON T.EmployeeID = C.CourierID
INNER JOIN Taxes AS Ta
ON T.TaxID = Ta.TaxID
ORDER BY [Nume curier]





