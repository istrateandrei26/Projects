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

--41. Modificati zona de livrare a curierilor cu salariul brut de peste 4000 de unitati , astfel incat sa livreze in orasul Timisoara
begin tran
;
DECLARE @AreaID INT
SET @AreaID =
(	
	SELECT TOP 1 S.LocationID
	FROM ShippingAreas AS S
	WHERE S.City = 'Timisoara'
)

UPDATE C
SET C.ShippingArea = @AreaID
FROM Couriers AS C
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE C.Salary > 4000
rollback
--42. Actualizati parolele conturilor clientilor ai caror comenzi au fost efectuate in a doua luna a anului curent

UPDATE CA
SET CA.Password = 'Updated Password !'
FROM Clients AS C
INNER JOIN Orders AS O 
ON C.ClientID = O.ClientID
INNER JOIN ClientAccounts AS CA
ON C.ClientID = CA.ClientID
WHERE DATEDIFF(YEAR,O.ExpectedDate,GETDATE()) = 0 AND MONTH(O.ExpectedDate) = 2

--43. Pretul tututor produselor din categoria deserturi , comandate in anul curent se va mari cu 5%

UPDATE R
SET R.UnitPrice+=0.05*R.UnitPrice
FROM Orders AS O 
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON D.DishID = R.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
WHERE (M.Category = 'Sucuri' OR M.Category = 'Bauturi alcoolice') AND DATEDIFF(YEAR,O.ExpectedDate,GETDATE()) = 0

--44. Salariile curierilor care livreaza in Bucuresti si conduc autoturisme Dacia se vor mari cu 20%
UPDATE C
SET Salary+=0.2*Salary
FROM Couriers AS C
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
INNER JOIN Vehicles AS V
ON C.CarID = V.CarID
INNER JOIN AutoBrands AS AB
ON V.BrandID = AB.BrandID
WHERE S.City LIKE '%Bucuresti%' AND AB.BrandName = 'Dacia'

--45. Data de livrare a comenzilor care sunt efectuate de clienti din Brasov se va modifica cu o zi mai tarziu 
begin tran

UPDATE O
SET O.ExpectedDate = DATEADD(DAY,1,O.ExpectedDate)
FROM Orders AS O
INNER JOIN Clients AS C
ON O.ClientID = C.ClientID
WHERE C.City = 'Brasov'

rollback

--46. Inlocuiti ciorbele de pe toate comenzile cu supa de pui , pentru curierii care livreaza in Timisoara
begin tran
DECLARE @DishID INT
SET @DishID = 
(
	SELECT D.DishID
	FROM Dishes AS D
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	WHERE M.Category = 'Supe' AND D.Name = 'Supa de pui'
)

UPDATE R
SET R.DishID = @DishID
FROM Orders AS O
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID 
INNER JOIN Couriers AS C
ON C.CourierID = O.CourierID
INNER JOIN Dishes AS D
ON D.DishID = R.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
INNER JOIN ShippingAreas AS S
ON S.LocationID = C.ShippingArea
WHERE M.Category = 'Ciorbe' AND S.City = 'Timisoara'

rollback
--47. Modificati numarul de inmatriculare al autoturismului curierului cu cel mai mare salariu
begin tran;
WITH C AS
(
	SELECT TOP 1 C.*
	FROM Couriers AS C
	INNER JOIN ShippingAreas AS S
	ON C.ShippingArea = S.LocationID
	ORDER BY C.Salary DESC
)
UPDATE V
SET V.RegistrationNumber = 'GL59RBR'
FROM C
INNER JOIN Vehicles AS V
ON C.CarID = V.CarID

rollback
--48. Modificati adresa paginii web a primului furnizor care produce dulciuri

WITH C AS
(
	SELECT TOP 1 P.*
	FROM Providers AS P
	INNER JOIN ProvidersDishesRelation AS PD
	ON P.ProviderID = PD.ProviderID
	INNER JOIN Dishes AS D
	ON PD.DishID = D.DishID
	INNER JOIN Menu AS M
	ON M.CategoryID = D.CategoryID
	WHERE M.Category = 'Deserturi'
)
UPDATE C
SET C.Webpage = 'www.onlysweets.com'

--49. Toate comisioanele de pe toate comenzile care s-au livrat in Braila se maresc cu 1%

UPDATE R
SET R.Commission+=0.01*R.Commission
FROM Orders AS O
INNER JOIN Couriers AS C
ON O.CourierID = C.CourierID
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
INNER JOIN Receipt AS R
ON R.OrderID = O.OrderID
WHERE S.City = 'Braila'

--50. Micsorati salariul brut cu 2% al curierilor care livreaza in Brasov , dar si pe cel al celor care livreaza in Timisoara

UPDATE C
SET C.Salary-=0.02*C.Salary
FROM Couriers AS C
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE S.City = 'Brasov' OR S.City = 'Timisoara'

--51. Schimbati zona de livrare cu orasul Cluj , pentru curierii care au zona de livrare = Brasov

DECLARE @locationID INT
SET @locationID =
(
	SELECT ShippingAreas.LocationID
	FROM ShippingAreas 
	WHERE ShippingAreas.City = 'Cluj'
)

UPDATE C
SET C.ShippingArea = @locationID
FROM Couriers AS C
INNER JOIN ShippingAreas AS S
ON C.ShippingArea = S.LocationID
WHERE S.City = 'Brasov'


--52. Toate facturile din luna Aprilie vor avea un voucher de 5 unitati

UPDATE R
SET R.Voucher = 5
FROM Receipt AS R
INNER JOIN Orders AS O
ON R.OrderID = O.OrderID
WHERE MONTH(O.ExpectedDate) = 4 

--53. Produsele livrate de furnizorii care se ocupa de dulciuri / deserturi vor avea cantitatea furnizata de 5 ori mai mare

UPDATE PD
SET PD.Quantity = 5*PD.Quantity
FROM Providers AS P
INNER JOIN ProvidersDishesRelation AS PD
ON P.ProviderID = PD.ProviderID
INNER JOIN Dishes AS D
ON PD.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
WHERE M.Category = 'Deserturi'

--54. Inlocuiti bauturile alcoolice de pe facturile din prima luna a anului curent cu sucuri Pepsi

DECLARE @drinkID INT
SET @drinkID =
(
	SELECT D.DishID
	FROM Dishes AS D
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	WHERE D.Name = 'Pepsi'
)

UPDATE R
SET R.DishID = @drinkID
FROM Receipt AS R
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
INNER JOIN Orders AS O
ON R.OrderID = R.OrderID
WHERE M.Category = 'Bauturi alcoolice' AND DATEDIFF(YEAR,O.ExpectedDate,GETDATE()) = 0 AND MONTH(O.ExpectedDate) = 1


--55. Schimbati adresa de livrare a clientilor al caror nume se termina cu litera e -> ridicare personala din sediul restaurantului

UPDATE O
SET O.Address = 'Ridicare personala'
FROM Clients AS C
INNER JOIN Orders AS O
ON C.ClientID = O.ClientID
WHERE C.LastName LIKE '%e'

--56. Un client a fost inregistrat gresit. Numele sau complet este 'Vasilescu Anca' si locuieste in Constanta. Numele de familie se va modifica in 'Vasiliu'

UPDATE Clients
SET LastName = 'Vasiliu' 
WHERE LastName + FirstName = 'Vasilescu Anca' AND City = 'Constanta'

--57. Salariul brut al curierilor care au livrat produse in peste / supe / ciorbe in ziua de 1 Mai se va mari cu 5%

UPDATE C
SET C.Salary+=0.05*C.Salary
FROM Couriers AS C
INNER JOIN Orders AS O
ON C.CourierID = O.CourierID
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON D.CategoryID = M.CategoryID
WHERE M.Category LIKE '%peste%' OR M.Category = 'Supe' OR M.Category = 'Ciorbe' AND DAY(O.ExpectedDate) = 1 AND MONTH(O.ExpectedDate) = 5

--58. Actualizati parolele clientilor care au comandat produse din peste in 'newPass'

UPDATE CA
SET CA.Password = 'newPass' 
FROM ClientAccounts AS CA
INNER JOIN Clients AS C
ON CA.ClientID = C.ClientID
INNER JOIN Orders AS O
ON O.ClientID = C.ClientID
INNER JOIN Receipt AS R
ON R.OrderID = O.OrderID
INNER JOIN Dishes AS D
ON D.DishID = R.DishID
INNER JOIN Menu AS M
ON M.CategoryID = D.CategoryID
WHERE M.Category = 'Peste'


--59. Pretul produselor din categoria 'Peste' comandate in ziua de 1 Mai a anului curent se va scumpi cu 50%

UPDATE R
SET R.UnitPrice+=50/100*R.UnitPrice
FROM Receipt AS R
INNER JOIN Orders AS O
ON R.OrderID = R.OrderID
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Menu AS M
ON M.CategoryID = D.CategoryID
WHERE M.Category = 'Peste'

--60. Inlocuiti Pepsi de pe toate comenzile efectuate in luna Aprilie de curierii care conduc autoturisme de marca 'Volkswagen' in Coca Cola

DECLARE @sdrinkID INT 
SET @sdrinkID = 
(
	SELECT D.CategoryID
	FROM Dishes AS D
	WHERE D.Name = 'Coca Cola'
)


UPDATE R
SET R.DishID = @sdrinkID
FROM Couriers AS C
INNER JOIN Orders AS O
ON C.CourierID = O.CourierID
INNER JOIN Receipt AS R
ON O.OrderID = R.OrderID 
INNER JOIN Dishes AS D
ON R.DishID = D.DishID
INNER JOIN Vehicles AS V
ON C.CarID = V.CarID
INNER JOIN AutoBrands AS AB
ON V.BrandID = AB.BrandID
WHERE D.Name = 'Pepsi' AND AB.BrandName = 'Volkswagen' AND MONTH(O.ExpectedDate) = 4


