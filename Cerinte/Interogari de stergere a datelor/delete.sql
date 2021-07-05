
USE [Food Delivery]

--135. Stergeti clientii al caror nume de familie incepe cu 'M' si se termina cu 'e' 

DELETE FROM C
FROM Clients AS C
WHERE C.LastName LIKE 'M%' AND C.LastName LIKE '%e';

--136. Stergeti clientii al caror numar de telefon se termina cu 811
DELETE FROM C
FROM Clients AS C
WHERE C.Phone LIKE '%811';


--137. Stergeti clientii care au comandat clatite 

DELETE FROM C
FROM Clients AS C
INNER JOIN Orders AS O
ON C.ClientID = O.ClientID
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
WHERE D.Name = 'Clatite';


--138. Stergeti clientii ai caror comenzi au fost livrate de curieri cu cel putin 2 luni vechime
;
WITH 
SelectedCouriers AS
(
	SELECT O.ClientID
	FROM Orders AS O
	INNER JOIN Couriers AS c
	ON O.CourierID = O.CourierID
	WHERE DATEDIFF(MONTH,C.HireDate,GETDATE()) >= 2
)
DELETE FROM C
FROM SelectedCouriers AS S
INNER JOIN Clients AS C
ON S.ClientID = C.ClientID


--139. Stergeti clientii ai caror comenzi au valoare totala mai mica decat 40 de unitati
;
WITH 
C AS
(
	SELECT R.OrderID, SUM(R.UnitPrice*R.Quantity) - max(R.Voucher) AS Total
	FROM Receipt AS R
	GROUP BY R.OrderID
)
DELETE FROM Cl
FROM C 
INNER JOIN Orders AS O
ON C.OrderID = O.OrderID 
INNER JOIN Clients AS Cl
ON O.ClientID = Cl.ClientID
WHERE C.Total < 40


--140. Stergeti comenzile ale caror curieri au zona de livrare diferita de zona de domiciliu 

DELETE FROM O
FROM Orders AS O
INNER JOIN Couriers AS C
ON O.CourierID = C.CourierID
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE C.City <> S.City


--141. Stergeti comenzile ale caror clienti au parole care nu contin caractere precum '!,@,#,$'

DELETE FROM O
FROM Orders AS O
INNER JOIN Clients AS C
ON O.ClientID = C.ClientID
INNER JOIN ClientAccounts AS CA
ON C.ClientID = CA.ClientID
WHERE CA.Password NOT LIKE '%!%' AND CA.Password NOT LIKE '%@%' AND CA.Password NOT LIKE '%#%' AND CA.Password NOT LIKE '%$%' 


--142. Stergeti clientii care au primit comenzi de la curieri care au zona de livrare in Brasov
;
WITH 
SelectedCouriers AS
(
	SELECT C.CourierID
	FROM Couriers AS C
	INNER JOIN ShippingAreas AS S
	ON C.ShippingArea = S.LocationID
	WHERE S.City = 'Brasov' AND S.Country = 'Romania'
)
DELETE FROM Cl
FROM SelectedCouriers AS C
INNER JOIN Orders AS O
ON C.CourierID = O.CourierID
INNER JOIN Clients AS Cl
ON O.ClientID = Cl.ClientID



--143. Stergeti clientii care au comandat salata
;
WITH 
SelectedDishes AS
(
	SELECT D.DishID
	FROM Dishes AS D
	WHERE D.Name LIKE '%Salata%'
)
DELETE FROM C
FROM SelectedDishes AS D
INNER JOIN Receipt AS R
ON D.DishID = R.DishID
INNER JOIN Orders AS O
ON R.OrderID = O.OrderID
INNER JOIN Clients AS C
ON O.ClientID = C.ClientID



--144. Stergeti clientii care au avut comenzi ale caror curieri conduc autoturisme marca 'Volkswagen'
;
WITH
SelectedCouriers AS
(
	SELECT C.CourierID
	FROM Couriers AS C
	INNER JOIN Vehicles AS V
	ON C.CarID = V.CarID
	INNER JOIN AutoBrands AS AB
	ON V.BrandID = AB.BrandID
	WHERE AB.BrandName = 'Volkswagen'
)
DELETE FROM Cl
FROM SelectedCouriers AS C
INNER JOIN Orders AS O
ON C.CourierID = O.CourierID
INNER JOIN Clients AS Cl
ON O.ClientID = Cl.ClientID;


--145. Stergeti furnizorii care au furnizat produse din categoria 'Deserturi' care sa fi fost comandate
;
WITH
SelectedDishes AS 
(
	SELECT DISTINCT D.DishID
	FROM Dishes AS D
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	INNER JOIN Receipt AS R
	ON R.DishID = D.DishID
	WHERE M.Category = 'Deserturi'
)
,
SelectedProviders AS 
(
	SELECT PD.ProviderID
	FROM ProvidersDishesRelation AS PD
	INNER JOIN SelectedDishes AS D
	ON PD.DishID = D.DishID
)
DELETE FROM P
FROM Providers AS P
INNER JOIN SelectedProviders AS S
ON P.ProviderID = S.ProviderID;



--146. Stergeti clientii care au doar 1 comanda 
;
WITH
SelectedClients AS
(
	SELECT O.ClientID, COUNT(*) AS 'Numar comenzi'
	FROM Clients AS C
	INNER JOIN Orders AS O
	ON C.ClientID = O.ClientID
	GROUP BY O.ClientID
)
DELETE FROM C
FROM Clients AS C
INNER JOIN SelectedClients AS S
ON C.ClientID = S.ClientID
WHERE S.[Numar comenzi] = 1


--147. Stergeti clientii care au avut comenzi livrate cu autoturisme inmatriculate pe 'Brasov'
;
WITH 
SelectedClients AS 
(
	SELECT C.ClientID,O.CourierID, Co.CarID
	FROM Clients AS C
	INNER JOIN Orders AS O
	ON C.ClientID = O.ClientID
	INNER JOIN Couriers AS Co
	ON O.CourierID = Co.CourierID
)
,
SelectedClientsByCourierCar AS
(
	SELECT C.ClientID , V.RegistrationNumber
	FROM SelectedClients AS C
	INNER JOIN Vehicles AS V
	ON C.CarID = V.CarID
)
DELETE FROM C
FROM Clients AS C
INNER JOIN SelectedClientsByCourierCar AS SC
ON C.ClientID = SC.ClientID
WHERE SC.RegistrationNumber LIKE 'BV%'



--148. Stergeti furnizorii care au oferit produse din categoria 'Preparate carne de pui'

DECLARE @categoryID AS INT;

SELECT @categoryID = M.CategoryID
FROM Menu AS M
WHERE M.Category = 'Preparate carne de pui';

DELETE FROM P
FROM ProvidersDishesRelation AS PD
INNER JOIN Providers AS P
ON PD.ProviderID = P.ProviderID 
INNER JOIN Dishes AS D
ON PD.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
WHERE M.CategoryID = @categoryID



--149. Stergeti comenzile care au fost livrate cu autoturisme marca 'Dacia'
begin tran
;
WITH 
SelectedOrders AS 
(
	SELECT O.OrderID
	FROM Orders AS O
	INNER JOIN Couriers AS C
	ON O.CourierID = C.CourierID
	INNER JOIN Vehicles AS V
	ON C.CarID = V.CarID
	INNER JOIN AutoBrands AS AB
	ON V.BrandID = AB.BrandID
	WHERE AB.BrandName = 'Dacia'
)
DELETE FROM OD
FROM SelectedOrders AS O
INNER JOIN Orders AS OD
ON O.OrderID = OD.OrderID


rollback



