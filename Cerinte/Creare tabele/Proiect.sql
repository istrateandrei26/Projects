-- Crearea bazei de date si a organizarii pentru fisierele logger
CREATE DATABASE "Food Delivery"
ON PRIMARY
(
	Name = ExampleData1,
	FileName = 'D:\anul 2 sem ii\baze de date\proiect\Food delivery.mdf',
	size = 10MB, -- KB, Mb, GB, TB
	maxsize = unlimited,
	filegrowth = 1GB
),
(
	Name = ExampleData2,
	FileName = 'D:\anul 2 sem ii\baze de date\proiect\Food delivery.ndf',
	size = 10MB, -- KB, Mb, GB, TB
	maxsize = unlimited,
	filegrowth = 1GB
),
(
	Name = ExampleData3,
	FileName = 'D:\anul 2 sem ii\baze de date\proiect\Food delivery3.ndf',
	size = 10MB, -- KB, Mb, GB, TB
	maxsize = unlimited,
	filegrowth = 1024MB
)
LOG ON
(
	Name = ExampleLog1,
	FileName = 'D:\anul 2 sem ii\baze de date\proiect\Food delivery.ldf',
	size = 10MB, -- KB, Mb, GB, TB
	maxsize = unlimited,
	filegrowth = 1024MB
),
(
	Name = ExampleLog2,
	FileName = 'D:\anul 2 sem ii\baze de date\proiect\Food delivery2.ldf',
	size = 10MB, -- KB, Mb, GB, TB
	maxsize = unlimited,
	filegrowth = 1024MB
)


-- Crearea tabelului Clients
CREATE TABLE Clients (
	ClientID int NOT NULL IDENTITY(1,1),
	LastName nvarchar(50) NOT NULL ,
	FirstName nvarchar(50) NOT NULL ,
	Age int ,
	Address nvarchar(256) NOT NULL ,
	City nvarchar(50) NOT NULL ,
	Country nvarchar(50) NOT NULL ,
	Phone varchar(15) NOT NULL ,

	CONSTRAINT Check_OnlyNumbers_Client CHECK(Phone LIKE '%[^A-Z]%'),
	CONSTRAINT PK_Clients PRIMARY KEY(ClientID),
	CONSTRAINT Check_Client CHECK(Age >= 18)

)

-- Crearea tabelului Locations
CREATE TABLE Locations (
	LocationID int NOT NULL IDENTITY(1,1),
	City nvarchar(50) NOT NULL ,
	Country nvarchar(50) NOT NULL ,

	CONSTRAINT PK_Location PRIMARY KEY(LocationID)
)

-- Crearea tabelului Providers
CREATE TABLE Providers(
	ProviderID int NOT NULL IDENTITY(1,1),
	CompanyName nvarchar(128) NOT NULL ,
	CompanyAddress nvarchar(256) ,
	City nvarchar(50) ,
	Country nvarchar(50) ,
	PhoneContact varchar(15) NOT NULL ,
	Webpage varchar(128) ,

	CONSTRAINT PK_Provider PRIMARY KEY(ProviderID) ,
	CONSTRAINT Check_Only_Numbers_Provider CHECK(PhoneContact LIKE '%[^A-Z]%')

)

-- Crearea tabelului ShippingAreas
CREATE TABLE ShippingAreas (
	LocationID int NOT NULL IDENTITY(1,1),
	City nvarchar(128) NOT NULL ,
	Country nvarchar(128) NOT NULL ,


	CONSTRAINT PK_Location PRIMARY KEY(LocationID) ,

)


-- Crearea tabelului Couriers
CREATE TABLE Couriers(
	CourierID int NOT NULL IDENTITY(1,1),
	FirstName nvarchar(50) NOT NULL ,
	LastName nvarchar(50) NOT NULL ,
	HireDate datetime ,
	Address nvarchar(256) ,
	City nvarchar(50) ,
	Country nvarchar(50) ,
	Phone varchar(15) NOT NULL ,
	ShippingArea int FOREIGN KEY REFERENCES ShippingAreas(LocationID),

	CONSTRAINT PK_Courier PRIMARY KEY(CourierID),
	CONSTRAINT Check_Only_Numbers_Courier CHECK(Phone LIKE '%[^A-Z]%')
)


-- Crearea tabelului EmployeesTaxes
CREATE TABLE EmployeesTaxes
(
	TaxID int NOT NULL IDENTITY(1,1),
	EmployeeID int NOT NULL FOREIGN KEY REFERENCES Couriers(CourierID),

	CONSTRAINT PK_ImpozitID_AngajatID PRIMARY KEY(TaxID,EmployeeID),
	CONSTRAINT FK_TaxID FOREIGN KEY(TaxID) REFERENCES Taxes(TaxID)

)

-- Crearea tabelului Taxes
CREATE TABLE Taxes
(
	TaxID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Description nvarchar NOT NULL,
	Percentage real NOT NULL

)

-- Adaugarea cheii straine a tabelului Couriers
alter table Couriers
add constraint FK_CarID FOREIGN KEY(CarID) REFERENCES Vehicles(CarID)



-- Adaugarea unei coloane suplimentare ,necesara in tabelul Couriers
alter table Couriers
add CarID int

-- Adaugarea constrangerii de unicitate pe campul CarID din tabelul Couriers
alter table Couriers
add constraint Unique_Car unique(CarID)



-- Crearea tabelului Dishes
CREATE TABLE Dishes(
	DishID int NOT NULL IDENTITY(1,1) ,
	Name nvarchar(128) NOT NULL ,
	CategoryID int ,

	CONSTRAINT PK_Dish PRIMARY KEY(DishID),
	FOREIGN KEY(CategoryID) REFERENCES Menu(CategoryID)

)


-- Crearea tabelului ProvidersDishesRelation
CREATE TABLE ProvidersDishesRelation (
	ProviderID int NOT NULL ,
	DishID int NOT NULL ,
	Date datetime ,
	Quantity int ,

	FOREIGN KEY(ProviderID) REFERENCES Providers(ProviderID),
	FOREIGN KEY(DishID) REFERENCES Dishes(DishID),
	CONSTRAINT PK_ProviderID_and_DishID PRIMARY KEY(ProviderID, DishID)
)


-- Crearea tabelului Orders
CREATE TABLE Orders (
	OrderID int NOT NULL IDENTITY(1,1) ,
	ClientID int NOT NULL ,
	CourierID int NOT NULL ,
	ExpectedDate datetime , 
	Address nvarchar(256) NOT NULL, 
	City nvarchar(50) NOT NULL, 
	Country nvarchar(50) NOT NULL,


	CONSTRAINT PK_OrderID PRIMARY KEY(OrderID) , 
	CONSTRAINT FK_ClientID FOREIGN KEY(ClientID) REFERENCES Clients(ClientID),
	CONSTRAINT FK_CourierID FOREIGN KEY(CourierID) REFERENCES Couriers(CourierID)
)


-- Crearea tabelului Receipt
CREATE TABLE Receipt(
	OrderID int NOT NULL ,
	DishID int NOT NULL ,
	Quantity int ,
	UnitPrice money NOT NULL ,
	Voucher bit NOT NULL ,

	CONSTRAINT FK_OrderID FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
	CONSTRAINT FK_Dish FOREIGN KEY(DishID) REFERENCES Dishes(DIshID),
	CONSTRAINT PK_OrderID_and_DishID PRIMARY KEY (OrderID, DishID)

)


-- Crearea tabelului ClientAccounts
CREATE TABLE ClientAccounts(
	AccountID int NOT NULL IDENTITY(1000,5), 
	EmailAddress nvarchar(50) NOT NULL ,
	Password nvarchar(25) NOT NULL ,
	ClientID int NOT NULL ,

	CONSTRAINT PK_AccountID PRIMARY KEY(AccountID) ,
	CONSTRAINT PASSWORD_LENGTH CHECK (DATALENGTH(Password) >=7) ,
	CONSTRAINT FK_ClientIDAccount FOREIGN KEY(ClientID) REFERENCES Clients(ClientID)
)

-- Crearea tabelului Menu
CREATE TABLE Menu(
	CategoryID int NOT NULL IDENTITY(1,1),
	Category nvarchar(50) NOT NULL,

	CONSTRAINT PK_CategoryID PRIMARY KEY(CategoryID)
)

-- Crearea tabelului Vehicles
CREATE TABLE Vehicles(
	CarID int NOT NULL IDENTITY(1,1),
	RegistrationNumber nvarchar(15) NOT NULL,

	CONSTRAINT PK_CarID PRIMARY KEY(CarID)
)

-- Adaugarea constrangerii de cheie externa a tabelului Vehicles 
ALTER TABLE Vehicles
ADD BrandID int FOREIGN KEY REFERENCES AutoBrands(BrandID)


-- Crearea tableului AutoBrands
CREATE TABLE AutoBrands
(
	BrandID int PRIMARY KEY IDENTITY(1,1),
	BrandName nvarchar(50) 
)

-- Utilizarea bazei de date Food Delivery pentru recunoasterea comenzilor
USE [Food Delivery];

-- Adaugarea constrangerii de unicitate pe campul RegistrationNumber din tabelul Vehicles
alter table Vehicles
add constraint Unique_RegistrationNumber unique(RegistrationNumber)


--Crearea tabelului Taxes
CREATE TABLE Taxes(
	TaxID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Description nvarchar(50) NOT NULL,
	Percentage real NOT NULL 
)

--Crearea tabelului EmployeesTaxes
CREATE TABLE EmployeesTaxes(
	TaxID int NOT NULL ,
	EmployeeID int NOT NULL , 

	CONSTRAINT PK_ImpozitID_AngajatID PRIMARY KEY (TaxID,EmployeeID) ,
	CONSTRAINT FK_TaxID FOREIGN KEY(TaxID) REFERENCES Taxes(TaxID),
	CONSTRAINT FK_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Couriers(CourierID)
)

select * from Clients




