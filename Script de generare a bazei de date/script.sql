USE [master]
GO
/****** Object:  Database [Food Delivery]    Script Date: 11-May-21 12:50:59 PM ******/
CREATE DATABASE [Food Delivery]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ExampleData1', FILENAME = N'D:\anul 2 sem ii\baze de date\proiect\Food delivery.mdf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1048576KB ),
( NAME = N'ExampleData2', FILENAME = N'D:\anul 2 sem ii\baze de date\proiect\Food delivery.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1048576KB ),
( NAME = N'ExampleData3', FILENAME = N'D:\anul 2 sem ii\baze de date\proiect\Food delivery3.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1048576KB )
 LOG ON 
( NAME = N'ExampleLog1', FILENAME = N'D:\anul 2 sem ii\baze de date\proiect\Food delivery.ldf' , SIZE = 1058816KB , MAXSIZE = 2048GB , FILEGROWTH = 1048576KB ), 
( NAME = N'ExampleLog2', FILENAME = N'D:\anul 2 sem ii\baze de date\proiect\Food delivery2.ldf' , SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 1048576KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Food Delivery] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Food Delivery].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Food Delivery] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Food Delivery] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Food Delivery] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Food Delivery] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Food Delivery] SET ARITHABORT OFF 
GO
ALTER DATABASE [Food Delivery] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Food Delivery] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Food Delivery] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Food Delivery] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Food Delivery] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Food Delivery] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Food Delivery] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Food Delivery] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Food Delivery] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Food Delivery] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Food Delivery] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Food Delivery] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Food Delivery] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Food Delivery] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Food Delivery] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Food Delivery] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Food Delivery] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Food Delivery] SET RECOVERY FULL 
GO
ALTER DATABASE [Food Delivery] SET  MULTI_USER 
GO
ALTER DATABASE [Food Delivery] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Food Delivery] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Food Delivery] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Food Delivery] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Food Delivery] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Food Delivery] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Food Delivery', N'ON'
GO
ALTER DATABASE [Food Delivery] SET QUERY_STORE = OFF
GO
USE [Food Delivery]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[ClientID] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[CNP] [nvarchar](20) NULL,
	[Address] [nvarchar](256) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Phone] [varchar](15) NOT NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientAccounts]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientAccounts](
	[AccountID] [int] IDENTITY(1000,5) NOT NULL,
	[EmailAddress] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](25) NOT NULL,
	[ClientID] [int] NOT NULL,
 CONSTRAINT [PK_AccountID] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[OrderClientsByName]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OrderClientsByName] AS 
	SELECT C.FirstName, CA.EmailAddress , CA.Password
	FROM Clients AS C
	INNER JOIN ClientAccounts AS CA
	ON C.ClientID = CA.ClientID
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[CourierID] [int] NOT NULL,
	[ExpectedDate] [datetime] NULL,
	[Address] [nvarchar](256) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OrderID] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dishes]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dishes](
	[DishID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[CategoryID] [int] NULL,
 CONSTRAINT [PK_Dish] PRIMARY KEY CLUSTERED 
(
	[DishID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Receipt]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Receipt](
	[OrderID] [int] NOT NULL,
	[DishID] [int] NOT NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [money] NOT NULL,
	[Commission] [real] NOT NULL,
	[Voucher] [int] NULL,
 CONSTRAINT [PK_OrderID_and_DishID] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[DishID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[EachClientTotal]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EachClientTotal] AS
	SELECT Clients.ClientID,max(Clients.FirstName + ' ' + Clients.LastName) AS 'Nume complet client' , SUM(R.UnitPrice*R.Quantity) AS Total
	FROM Receipt AS R inner join Orders AS O
	ON R.OrderID = O.OrderID
	inner join Clients 
	ON O.ClientID = Clients.ClientID
	inner join Dishes
	ON Dishes.DishID = R.DishID
	GROUP BY Clients.ClientID, O.OrderID
GO
/****** Object:  View [dbo].[EachClientAllTimeTotal]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EachClientAllTimeTotal] AS
	SELECT Clients.ClientID,max(Clients.FirstName + ' ' + Clients.LastName) AS 'Nume complet client' , SUM(R.UnitPrice*R.Quantity) AS Total
	FROM Receipt AS R inner join Orders AS O
	ON R.OrderID = O.OrderID
	inner join Clients 
	ON O.ClientID = Clients.ClientID
	inner join Dishes
	ON Dishes.DishID = R.DishID
	GROUP BY Clients.ClientID
GO
/****** Object:  Table [dbo].[Providers]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Providers](
	[ProviderID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](128) NOT NULL,
	[CompanyAddress] [nvarchar](256) NULL,
	[City] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[PhoneContact] [varchar](15) NOT NULL,
	[Webpage] [varchar](128) NULL,
 CONSTRAINT [PK_Provider] PRIMARY KEY CLUSTERED 
(
	[ProviderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProvidersDishesRelation]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProvidersDishesRelation](
	[ProviderID] [int] NOT NULL,
	[DishID] [int] NOT NULL,
	[Date] [datetime] NULL,
	[Quantity] [int] NULL,
 CONSTRAINT [PK_ProviderID_and_DishID] PRIMARY KEY CLUSTERED 
(
	[ProviderID] ASC,
	[DishID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menu]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Category] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SweetsCompanyDetails]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SweetsCompanyDetails] AS
	SELECT P.CompanyName, P.Webpage, D.Name AS 'Denumire'
	FROM Providers AS P
	INNER JOIN ProvidersDishesRelation AS PDR
	ON P.ProviderID = PDR.ProviderID
	INNER JOIN Dishes AS D
	ON PDR.DishID = D.DishID
	INNER JOIN Menu AS M
	ON D.CategoryID = M.CategoryID
	WHERE M.Category = 'Deserturi'
GO
/****** Object:  Table [dbo].[Couriers]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Couriers](
	[CourierID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[HireDate] [datetime] NULL,
	[Address] [nvarchar](256) NULL,
	[City] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[Phone] [varchar](15) NOT NULL,
	[ShippingArea] [int] NULL,
	[Salary] [int] NULL,
	[CarID] [int] NULL,
 CONSTRAINT [PK_Courier] PRIMARY KEY CLUSTERED 
(
	[CourierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AllCouriers]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllCouriers] AS
	SELECT *FROM Couriers
GO
/****** Object:  View [dbo].[AllDishes]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllDishes] AS
	SELECT *FROM Dishes

GO
/****** Object:  Table [dbo].[AutoBrands]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoBrands](
	[BrandID] [int] IDENTITY(1,1) NOT NULL,
	[BrandName] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[BrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vehicles]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicles](
	[CarID] [int] IDENTITY(1,1) NOT NULL,
	[RegistrationNumber] [nvarchar](15) NOT NULL,
	[BrandID] [int] NULL,
 CONSTRAINT [PK_CarID] PRIMARY KEY CLUSTERED 
(
	[CarID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AllCars]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllCars] AS
	SELECT V.RegistrationNumber, AB.BrandName
	FROM Vehicles AS V
	INNER JOIN AutoBrands AS AB
	ON V.BrandID = AB.BrandID
GO
/****** Object:  Table [dbo].[ShippingAreas]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingAreas](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[City] [nvarchar](128) NOT NULL,
	[Country] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AllShippingAreas]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllShippingAreas] AS
	SELECT *
	FROM ShippingAreas

GO
/****** Object:  View [dbo].[Total vanzari pe ani]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Total vanzari pe ani] AS
	SELECT year(O.ExpectedDate) as An , sum(R.UnitPrice*R.Quantity -R.Voucher) as Vanzari
	FROM Receipt AS R
	INNER JOIN Orders O
	ON R.OrderID = O.OrderID
	GROUP BY year(O.ExpectedDate)

GO
/****** Object:  View [dbo].[AllProviders]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllProviders] AS
	SELECT *
	FROM Providers
GO
/****** Object:  Table [dbo].[EmployeesTaxes]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeesTaxes](
	[TaxID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
 CONSTRAINT [PK_ImpozitID_AngajatID] PRIMARY KEY CLUSTERED 
(
	[TaxID] ASC,
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Taxes]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Taxes](
	[TaxID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Percentage] [real] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TaxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AutoBrands] ON 
GO
INSERT [dbo].[AutoBrands] ([BrandID], [BrandName]) VALUES (1, N'Skoda')
GO
INSERT [dbo].[AutoBrands] ([BrandID], [BrandName]) VALUES (2, N'Volkswagen')
GO
INSERT [dbo].[AutoBrands] ([BrandID], [BrandName]) VALUES (3, N'Audi')
GO
INSERT [dbo].[AutoBrands] ([BrandID], [BrandName]) VALUES (4, N'Dacia')
GO
INSERT [dbo].[AutoBrands] ([BrandID], [BrandName]) VALUES (5, N'Renault')
GO
INSERT [dbo].[AutoBrands] ([BrandID], [BrandName]) VALUES (6, N'Citroen')
GO
INSERT [dbo].[AutoBrands] ([BrandID], [BrandName]) VALUES (7, N'Ford')
GO
SET IDENTITY_INSERT [dbo].[AutoBrands] OFF
GO
SET IDENTITY_INSERT [dbo].[ClientAccounts] ON 
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1310, N'andriev_marius@gmail.com', N'asdasfgrww332', 1)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1315, N'andriev_marius@yahoo.com', N'agsdgaq36u63abs', 1)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1320, N'vinau20dragos@yahoo.com', N'vinau123', 2)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1325, N'diaconu1996@yahoo.com', N'ana678d', 3)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1330, N'stefania_iordachescu22@gmail.com', N'stef123ggh', 4)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1335, N'manole_ion23@gmail.com', N'2020asdddd', 5)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1340, N'mariussss@gmail.com', N'mariusss2222', 6)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1345, N'david23@gmail.com', N'davi123xxx', 7)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1350, N'alex_andrei_yahoo.com', N'alexandrei123', 8)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1355, N'andrei_istrate@yahoo.ro', N'teapaaici', 9)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1360, N'dragos_crh@gmail.com', N'parolaveche2', 10)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1365, N'diaconu_qq@gmail.com', N'Diaconu345', 3)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1370, N'georgescu_mihai@yahoo.ro', N'ddd2020', 11)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1375, N'frumuzache12@gmail.com', N'asd2020!@#', 12)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1380, N'mariussssIS@gmail.com', N'marius551', 13)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1385, N'valentin_berdy@yahoo.com', N'valy123', 14)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1390, N'beraru_stef@yahoo.ro', N'Stef555', 15)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1395, N'alex_andrei@yahoo.com', N'Updated Password !', 16)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1400, N'vasilescu_anca@gmail.com', N'vasy_a123', 17)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1405, N'george205@yahoo.com', N'geogeo11', 18)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1410, N'amariei_ama@yahoo.com', N'irinaama23', 19)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1415, N'marian123@gmail.com', N'marian345', 20)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1420, N'radu_capatan12@gmail.com', N'radu12', 21)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1425, N'namol_marinica@gmail.com', N'marinicamary55', 22)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1430, N'vlad12_iordan@yahoo.ro', N'vlad123#$%', 23)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1435, N'diana123@gmail.com', N'diana123!@#', 24)
GO
INSERT [dbo].[ClientAccounts] ([AccountID], [EmailAddress], [Password], [ClientID]) VALUES (1460, N'nastase_alexandru@gmail.com', N'nastalex123', 29)
GO
SET IDENTITY_INSERT [dbo].[ClientAccounts] OFF
GO
SET IDENTITY_INSERT [dbo].[Clients] ON 
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (1, N'Andriev', N'Marius', N'1961013180073', N'Strada Florilor Nr.101', N'Galati', N'Romania', N'0752348811')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (2, N'Vinau', N'Dragos', N'1560316050096', N'Strada Aurel Vlaicu', N'Braila', N'Romania', N'0725555678')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (3, N'Diaconu', N'Ana', N'2480615260084', N'Strada Nae Leonard Nr. 28', N'Galati', N'Romania', N'0726386549')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (4, N'Iordachescu', N'Stefania', N'2960718040096', N'Strada Anghel Saligny', N'Timisoara', N'Romania', N'0711111111')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (5, N'Manole', N'Ion', N'1990728370014', N'Strada Nucului Nr.27', N'Cluj', N'Romania', N'0750001345')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (6, N'Ionescu', N'Marius', N'1751226460080', N'Strada Dumitru Teodoru', N'Bucuresti', N'Romania', N'0720001234')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (7, N'Adamescu', N'David', N'1681119520032', N'Strada Luceafarul Nr.28', N'Brasov', N'Romania', N'0742343212')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (8, N'Hodorogea', N'Alex', N'1930427110019', N'Strada Avioanelor Nr.24', N'Mures', N'Romania', N'0725655658')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (9, N'Istrate', N'Andrei', N'1870602190040', N'Strada 22 Decembrie', N'Galati', N'Romania', N'0723350772')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (10, N'Crihana', N'Dragos', N'1721116370047', N'Strada Nufarului', N'Timisoara', N'Romania', N'0723457123')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (11, N'Georgescu', N'Mihai', N'1610201390059', N'Strada Trandafirului Nr.45', N'Cluj', N'Romania', N'0722227777')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (12, N'Frumuzache', N'Gabriel', N'1840131250081', N'Strada George Cosbuc Nr.22', N'Constanta', N'Romania', N'0721287651')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (13, N'Isaila', N'Marius', N'1460502210023', N'Strada Manole', N'Galati', N'Romania', N'0711185382')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (14, N'Berdila', N'Valentin', N'1710810460028', N'Strada Ciucas Nr.15', N'Brasov', N'Romania', N'0738889707')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (15, N'Beraru', N'Stefan', N'1610703010093', N'Strada Nufarului Nr.102', N'Bucuresti', N'Romania', N'0728987444')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (16, N'Berila', N'Alexandru', N'1640906330083', N'Strada Orizontului', N'Timisoara', N'Romania', N'0723234567')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (17, N'Vasilescu', N'Anca', N'2770416520093', N'Strada Martisorului', N'Constanta', N'Romania', N'0734321289')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (18, N'Andreescu', N'George', N'1901227380034', N'Strada Tricolorului', N'Galati', N'Romania', N'0767665110')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (19, N'Amariei', N'Irina', N'2650709380056', N'Strada Ghioceilor', N'Braila', N'Romania', N'0728987640')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (20, N'Silivastru', N'Marian', N'1480320050028', N'Strada Curcubeului', N'Timisoara', N'Romania', N'0756550000')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (21, N'Capatan', N'Radu', N'1670104160051', N'Strada Rucarului', N'Brasov', N'Romania', N'0756569909')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (22, N'Namol', N'Marinica', N'1591106280073', N'Strada Jijiei', N'Cluj', N'Romania', N'0729892110')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (23, N'Iordan', N'Vlad', N'1560719510025', N'Strada Racului', N'Hunedoara', N'Romania', N'0765432200')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (24, N'Chiriac', N'Diana', N'2981120250059', N'Strada Privighetorii', N'Timisoara', N'Romania', N'0723432200')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (29, N'Nastase', N'Alexandru', N'1991126170035', N'Strada Florilor Nr.6', N'Galati', N'Romania', N'0723350871')
GO
INSERT [dbo].[Clients] ([ClientID], [LastName], [FirstName], [CNP], [Address], [City], [Country], [Phone]) VALUES (30, N'Dumitriu', N'Vlad', N'1990126170035', N'Strada Florilor Nr.7', N'Braila', N'Romania', N'0724350871')
GO
SET IDENTITY_INSERT [dbo].[Clients] OFF
GO
SET IDENTITY_INSERT [dbo].[Couriers] ON 
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (1, N'Grigorescu', N'Sorin', CAST(N'2014-09-23T00:00:00.000' AS DateTime), N'Strada Nae Leonard Nr.28', N'Galati', N'Romania', N'0712345321', 2, 4000, 1)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (2, N'Georgescu', N'Mihai', CAST(N'2015-08-14T00:00:00.000' AS DateTime), N'Strada George Cosbuc Nr.23', N'Braila', N'Romania', N'0754677789', 11, 4000, 10)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (3, N'Iordache', N'Stefan', CAST(N'2015-08-15T00:00:00.000' AS DateTime), N'Strada Aurel Constantin', N'Timisoara', N'Romania', N'0743432123', 12, 4000, 5)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (4, N'Caramidaru', N'Paul', CAST(N'2018-01-05T00:00:00.000' AS DateTime), N'Strada Nicolae Balcescu Nr.225', N'Brasov', N'Romania', N'0761239274', 2, 4000, 7)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (5, N'Apostolache', N'Marius', CAST(N'2020-06-28T00:00:00.000' AS DateTime), N'Strada Stefan cel Mare Nr.22', N'Cluj', N'Romania', N'0721212121', 3, 4000, 6)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (6, N'Luchita', N'Georgiana', CAST(N'2021-03-03T00:00:00.000' AS DateTime), N'Strada Ghiocelului Nr.123', N'Bucuresti', N'Romania', N'0734349980', 7, 4000, 3)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (7, N'Loghin', N'Andrei', CAST(N'2020-12-20T00:00:00.000' AS DateTime), N'Strada Florilor Nr.11', N'Bucuresti', N'Romania', N'0744446578', 5, 4000, 4)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (8, N'Craciun', N'Gabriel', CAST(N'2020-11-08T00:00:00.000' AS DateTime), N'Strada Imperiul Bizantin', N'Bucuresti', N'Romania', N'0723452345', 6, 4000, 13)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (9, N'Popa', N'Silviu', CAST(N'2021-02-23T00:00:00.000' AS DateTime), N'Strada Crizantemei Nr.82', N'Bucuresti', N'Romania', N'0772222289', 8, 4000, 11)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (10, N'Mocanu', N'George', CAST(N'2021-02-28T00:00:00.000' AS DateTime), N'Strada Trandafirului Nr.123', N'Bucuresti', N'Romania', N'0747892110', 10, 4000, 12)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (11, N'Moroianu', N'Bogdan', CAST(N'2020-09-27T00:00:00.000' AS DateTime), N'Strada Noptii Nr.43', N'Bucuresti', N'Romania', N'0711112349', 9, 4000, 15)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (12, N'Mocanu', N'Stefan', CAST(N'2020-04-23T00:00:00.000' AS DateTime), N'Strada Nucului Nr.128', N'Hunedoara', N'Romania', N'0734543454', 12, 4200, 9)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (13, N'Petrescu', N'Alexandru', CAST(N'2020-04-23T00:00:00.000' AS DateTime), N'Strada Crinului', N'Brasov', N'Romania', N'0722223432', 12, 4300, 7)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (14, N'Chirita', N'Robert', CAST(N'2020-08-21T00:00:00.000' AS DateTime), N'Strada Vasile Alecsandri', N'Galati', N'Romania', N'0722228898', 12, 4400, 14)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (15, N'Chiriac', N'Liviu', CAST(N'2020-09-26T00:00:00.000' AS DateTime), N'Strada Lupilor', N'Braila', N'Romania', N'0767691121', 11, 3800, 10)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (16, N'Maftei', N'Vlad', CAST(N'2020-11-11T00:00:00.000' AS DateTime), N'Strada Nuferilor', N'Cluj', N'Romania', N'0711114366', 3, 3750, 6)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (17, N'Doca', N'George', CAST(N'2020-12-02T00:00:00.000' AS DateTime), N'Strada Avioanelor', N'Timisoara', N'Romania', N'0777777777', 12, 4000, 5)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (18, N'Hahui', N'Razvan', CAST(N'2020-04-01T00:00:00.000' AS DateTime), N'Strada Lebedelor', N'Constanta', N'Romania', N'0733347677', 12, 4100, 8)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (19, N'Solomon', N'Robert', CAST(N'2020-06-21T00:00:00.000' AS DateTime), N'Strada Brailei', N'Braila', N'Romania', N'0712343278', 11, 3700, 10)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (20, N'Condrea', N'Radu', CAST(N'2020-07-17T00:00:00.000' AS DateTime), N'Strada Randunicii', N'Constanta', N'Romania', N'0734543390', 13, 3900, 8)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (23, N'Nastase', N'Ionut', CAST(N'2020-07-27T00:00:00.000' AS DateTime), N'Strada Lalelelor', N'Hunedoara', N'Romania', N'0734543421', 12, 4200, 22)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (24, N'Adamescu', N'George', CAST(N'2020-04-20T00:00:00.000' AS DateTime), N'Strada Cailor Nr. 23', N'Constanta', N'Romania', N'0712347790', 13, 4000, 17)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (25, N'Lazar', N'Ion', CAST(N'2020-10-08T00:00:00.000' AS DateTime), N'Strada Geamgiilor', N'Cluj', N'Romania', N'0745544890', 3, 3900, 23)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (26, N'Pirvulescu', N'David', CAST(N'2020-09-18T00:00:00.000' AS DateTime), N'Strada Constructorilor', N'Galati', N'Romania', N'0756765512', 1, 3800, 20)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (27, N'Toma', N'Alexandru', CAST(N'2020-12-02T00:00:00.000' AS DateTime), N'Strada Farului Nr.28', N'Timisoara', N'Romania', N'0723433009', 12, 4100, 21)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (28, N'Mihaila', N'Cristian', CAST(N'2020-08-21T00:00:00.000' AS DateTime), N'Strada Soarelui', N'Brasov', N'Romania', N'0747777760', 2, 3950, 19)
GO
INSERT [dbo].[Couriers] ([CourierID], [FirstName], [LastName], [HireDate], [Address], [City], [Country], [Phone], [ShippingArea], [Salary], [CarID]) VALUES (29, N'Marinescu', N'Darius', CAST(N'2020-06-29T00:00:00.000' AS DateTime), N'Strada Grigore Ventura', N'Galati', N'Romania', N'0722228789', 3, 4500, 15)
GO
SET IDENTITY_INSERT [dbo].[Couriers] OFF
GO
SET IDENTITY_INSERT [dbo].[Dishes] ON 
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (1, N'Friptura de pui la grill', 3)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (2, N'Friptura de pui la cuptor', 3)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (3, N'Dorada regala la cuptor', 6)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (4, N'Creveti trasi la tigaie', 7)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (5, N'Papanasi cu dulceata', 8)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (6, N'Papanasi cu ciocolata', 8)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (7, N'Tort de ciocolata', 8)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (8, N'Prajitura cu fructe', 8)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (9, N'Mousse de ciocolata', 8)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (10, N'Lava Cake', 8)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (11, N'Clatite', 8)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (12, N'Jack Daniel"s', 9)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (13, N'Finlandia', 9)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (14, N'Captain Jack', 9)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (15, N'Palinca', 9)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (16, N'Visinata', 9)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (17, N'Pepsi', 10)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (18, N'Sprite', 10)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (19, N'Coca Cola', 10)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (20, N'7up', 10)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (21, N'Fanta', 10)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (22, N'Cartofi gratinati la cuptor', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (23, N'Salata de varza alba', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (24, N'Salata de varza rosie', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (25, N'Mamaliguta', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (26, N'Cartofi natur', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (27, N'Cartofi prajiti', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (28, N'Piure de cartofi', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (29, N'Salata de rosii', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (30, N'Salata de rosii si castraveti', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (31, N'Salata de verdeturi', 12)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (32, N'Masline', 13)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (33, N'Alune', 13)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (34, N'Bruschete', 13)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (35, N'Sos de usturoi', 11)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (36, N'Sos de rodie', 11)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (37, N'Ketchup', 11)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (38, N'Pastrav la grill', 6)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (39, N'Crap la cuptor', 6)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (40, N'Salata de icre', 6)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (41, N'Caras prajit', 6)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (42, N'Vita Argentina', 5)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (43, N'Friptura servita pe piatra incinsa', 5)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (44, N'Carnati taranesti', 4)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (45, N'Mititei', 4)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (46, N'Pulpa de pui la grill', 3)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (47, N'Snitele de pui', 3)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (48, N'Rulada de pui', 3)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (49, N'Ciorba radauteana', 2)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (50, N'Ciorba de legume', 2)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (51, N'Ciorba de burta', 2)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (52, N'Ciorba taraneasca', 2)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (53, N'Ciorba de fasole in paine', 2)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (54, N'Ciorba de perisoare', 2)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (55, N'Supa de pui', 1)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (56, N'Supa cu galuste', 1)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (57, N'Snitele de porc', 4)
GO
INSERT [dbo].[Dishes] ([DishID], [Name], [CategoryID]) VALUES (59, N'Sushi', 6)
GO
SET IDENTITY_INSERT [dbo].[Dishes] OFF
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 1)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 2)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 3)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 4)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 5)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 6)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 7)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 8)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 9)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 10)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 11)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 12)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 13)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 14)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 15)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 16)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 17)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 18)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 19)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 20)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 23)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 24)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 25)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 26)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 27)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (1, 28)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 1)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 2)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 3)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 4)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 5)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 6)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 7)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 8)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 9)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 10)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 11)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 12)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 13)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 14)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 15)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 16)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 17)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 18)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 19)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 20)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 23)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 24)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 25)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 26)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 27)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (2, 28)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 1)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 2)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 3)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 4)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 5)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 6)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 7)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 8)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 9)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 10)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 11)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 12)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 13)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 14)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 15)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 16)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 17)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 18)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 19)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 20)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 23)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 24)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 25)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 26)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 27)
GO
INSERT [dbo].[EmployeesTaxes] ([TaxID], [EmployeeID]) VALUES (3, 28)
GO
SET IDENTITY_INSERT [dbo].[Menu] ON 
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (1, N'Supe')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (2, N'Ciorbe')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (3, N'Preparate carne de pui')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (4, N'Preparate carne de porc')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (5, N'Preparate carne de vita')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (6, N'Peste')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (7, N'Fructe de mare')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (8, N'Deserturi')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (9, N'Bauturi alcoolice')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (10, N'Sucuri')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (11, N'Sosuri')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (12, N'Garnituri')
GO
INSERT [dbo].[Menu] ([CategoryID], [Category]) VALUES (13, N'Aperitive')
GO
SET IDENTITY_INSERT [dbo].[Menu] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (1, 3, 2, CAST(N'2021-04-02T00:00:00.000' AS DateTime), N'Strada 30 Decembrie', N'Galati', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (2, 4, 3, CAST(N'2021-04-05T00:00:00.000' AS DateTime), N'Strada Anghel Saligny', N'Timisoara', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (3, 2, 2, CAST(N'2021-03-25T00:00:00.000' AS DateTime), N'Strada Aurel Vlaicu', N'Braila', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (4, 6, 7, CAST(N'2021-04-15T00:00:00.000' AS DateTime), N'Strada Lupului', N'Bucuresti', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (5, 9, 1, CAST(N'2021-04-22T00:00:00.000' AS DateTime), N'Strada 22 Decembrie', N'Galati', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (6, 19, 15, CAST(N'2021-05-05T00:00:00.000' AS DateTime), N'Strada Nucului Nr.145', N'Braila', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (7, 2, 19, CAST(N'2021-05-14T00:00:00.000' AS DateTime), N'Strada Fecioarei', N'Braila', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (8, 18, 14, CAST(N'2021-04-09T00:00:00.000' AS DateTime), N'Strada Constructorilor Nr.101', N'Galati', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (9, 9, 26, CAST(N'2021-05-12T00:00:00.000' AS DateTime), N'Strada Ionascu', N'Galati', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (10, 13, 14, CAST(N'2021-05-13T00:00:00.000' AS DateTime), N'Strada Aurel Vlaicu', N'Galati', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (11, 7, 4, CAST(N'2021-05-15T00:00:00.000' AS DateTime), N'Strada Avioanelor Nr.107', N'Brasov', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (12, 14, 13, CAST(N'2021-04-21T00:00:00.000' AS DateTime), N'Strada Izvorul Muntelui', N'Brasov', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (13, 21, 28, CAST(N'2021-04-22T00:00:00.000' AS DateTime), N'Strada Tapului Nr.24', N'Brasov', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (14, 23, 12, CAST(N'2021-04-23T00:00:00.000' AS DateTime), N'Strada Borsec Nr.4', N'Hunedoara', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (15, 5, 5, CAST(N'2021-04-17T00:00:00.000' AS DateTime), N'Strada Horei Nr.5', N'Cluj', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (16, 11, 16, CAST(N'2021-05-29T00:00:00.000' AS DateTime), N'Strada Caprelor Nr.56', N'Cluj', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (17, 22, 25, CAST(N'2021-05-08T00:00:00.000' AS DateTime), N'Strada Sperantei Nr.12', N'Cluj', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (18, 4, 17, CAST(N'2021-05-06T00:00:00.000' AS DateTime), N'Strada Ion Creanga', N'Timisoara', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (19, 10, 27, CAST(N'2021-05-07T00:00:00.000' AS DateTime), N'Strada Mihai Eminescu', N'Timisoara', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (20, 24, 17, CAST(N'2021-05-07T00:00:00.000' AS DateTime), N'Strada Dimitrie Cantemir', N'Timisoara', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (21, 16, 3, CAST(N'2021-02-22T00:00:00.000' AS DateTime), N'Strada Sforilor', N'Timisoara', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (22, 20, 27, CAST(N'2021-03-02T00:00:00.000' AS DateTime), N'Strada Capatan', N'Timisoara', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (23, 12, 18, CAST(N'2021-04-26T00:00:00.000' AS DateTime), N'Strada Siderurgistilor', N'Constanta', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (24, 17, 20, CAST(N'2021-05-01T00:00:00.000' AS DateTime), N'Strada Florilor Nr.12', N'Constanta', N'Romania')
GO
INSERT [dbo].[Orders] ([OrderID], [ClientID], [CourierID], [ExpectedDate], [Address], [City], [Country]) VALUES (25, 17, 24, CAST(N'2021-05-02T00:00:00.000' AS DateTime), N'Strada Ghioceilor Nr.12', N'Constanta', N'Romania')
GO
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[Providers] ON 
GO
INSERT [dbo].[Providers] ([ProviderID], [CompanyName], [CompanyAddress], [City], [Country], [PhoneContact], [Webpage]) VALUES (1, N'Vitality Bowls', N'Strada Ghiocelului Nr.100', N'Braila', N'Romania', N'0733332123', N'www.vitalitybowls.com')
GO
INSERT [dbo].[Providers] ([ProviderID], [CompanyName], [CompanyAddress], [City], [Country], [PhoneContact], [Webpage]) VALUES (2, N'Wholesome Bites', N'Strada Nufarului Nr.12', N'Brasov', N'Romania', N'0712121212', N'www.wholesomebytes.com')
GO
INSERT [dbo].[Providers] ([ProviderID], [CompanyName], [CompanyAddress], [City], [Country], [PhoneContact], [Webpage]) VALUES (4, N'The Amazing Chicken', N'Strada Fericirii', N'Bucuresti', N'Romania', N'0744445612', N'www.amazingchicken.com')
GO
INSERT [dbo].[Providers] ([ProviderID], [CompanyName], [CompanyAddress], [City], [Country], [PhoneContact], [Webpage]) VALUES (5, N'True Food', N'Strada Centenarului', N'Bucuresti', N'Romania', N'0721238889', N'wwwtruefood.ro')
GO
INSERT [dbo].[Providers] ([ProviderID], [CompanyName], [CompanyAddress], [City], [Country], [PhoneContact], [Webpage]) VALUES (6, N'Tasty Fish', N'Strada Primaverii Nr.56', N'Timisoara', N'Romania', N'0722227689', N'www.tastyfish.com')
GO
INSERT [dbo].[Providers] ([ProviderID], [CompanyName], [CompanyAddress], [City], [Country], [PhoneContact], [Webpage]) VALUES (7, N'Cafe Coyote', N'Strada Lalelei Nr.22', N'Cluj', N'Romania', N'0738251428', N'www.cafecoyote.com')
GO
INSERT [dbo].[Providers] ([ProviderID], [CompanyName], [CompanyAddress], [City], [Country], [PhoneContact], [Webpage]) VALUES (8, N'Lovely Sweets', N'Strada Anotimpurilor', N'Galati', N'Romania', N'0753234561', N'www.lvlsweets.com')
GO
INSERT [dbo].[Providers] ([ProviderID], [CompanyName], [CompanyAddress], [City], [Country], [PhoneContact], [Webpage]) VALUES (9, N'Best Chicken', N'Strada Nucului', N'Hunedoara', N'Romania', N'0722223490', N'www.bestchicken.com')
GO
INSERT [dbo].[Providers] ([ProviderID], [CompanyName], [CompanyAddress], [City], [Country], [PhoneContact], [Webpage]) VALUES (10, N'Barbeque', N'Strada Florilor', N'Constanta', N'Romania', N'0721212210', N'www.barbeque.com')
GO
SET IDENTITY_INSERT [dbo].[Providers] OFF
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (1, 2, CAST(N'2021-04-02T00:00:00.000' AS DateTime), 2)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (4, 1, CAST(N'2021-04-12T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (4, 2, CAST(N'2021-04-05T00:00:00.000' AS DateTime), 4)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (5, 49, CAST(N'2021-04-05T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (5, 50, CAST(N'2021-04-05T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (5, 54, CAST(N'2021-04-14T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (6, 3, CAST(N'2021-04-25T00:00:00.000' AS DateTime), 2)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (6, 12, CAST(N'2021-04-25T00:00:00.000' AS DateTime), 2)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (6, 35, CAST(N'2021-04-25T00:00:00.000' AS DateTime), 2)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (7, 18, CAST(N'2021-04-26T00:00:00.000' AS DateTime), 4)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (7, 19, CAST(N'2021-04-04T00:00:00.000' AS DateTime), 2)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (8, 5, CAST(N'2021-04-05T00:00:00.000' AS DateTime), 4)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (8, 10, CAST(N'2021-04-13T00:00:00.000' AS DateTime), 2)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (8, 11, CAST(N'2021-03-26T00:00:00.000' AS DateTime), 5)
GO
INSERT [dbo].[ProvidersDishesRelation] ([ProviderID], [DishID], [Date], [Quantity]) VALUES (8, 17, CAST(N'2020-03-03T00:00:00.000' AS DateTime), 10)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (1, 8, 1, 12.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (2, 3, 3, 17.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (2, 12, 2, 40.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (2, 35, 2, 2.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (3, 10, 1, 14.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (4, 5, 1, 21.0000, 2, 5)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (5, 11, 5, 13.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (6, 6, 1, 12.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (6, 7, 1, 13.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (6, 9, 1, 15.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (7, 1, 3, 17.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (7, 21, 2, 5.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (7, 22, 3, 5.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (7, 24, 3, 4.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (8, 29, 1, 12.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (8, 48, 1, 24.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (8, 49, 1, 15.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (9, 24, 1, 7.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (9, 26, 1, 7.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (9, 42, 1, 84.0000, 10, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (10, 19, 10, 7.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (11, 20, 15, 7.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (12, 4, 1, 34.0000, 5, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (13, 10, 1, 23.0000, 4, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (14, 11, 1, 14.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (14, 12, 1, 40.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (15, 50, 1, 11.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (16, 51, 2, 15.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (17, 56, 4, 12.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (18, 1, 2, 17.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (18, 35, 2, 4.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (18, 55, 2, 13.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (19, 30, 1, 11.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (19, 47, 1, 14.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (19, 51, 1, 15.0000, 2, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (20, 25, 1, 10.0000, 1, 0)
GO
INSERT [dbo].[Receipt] ([OrderID], [DishID], [Quantity], [UnitPrice], [Commission], [Voucher]) VALUES (20, 38, 1, 25.0000, 2, 0)
GO
SET IDENTITY_INSERT [dbo].[ShippingAreas] ON 
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (1, N'Galati', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (2, N'Brasov', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (3, N'Cluj', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (4, N'Hunedoara', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (5, N'Bucuresti Sector 1', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (6, N'Bucuresti Sector 2', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (7, N'Bucuresti Sector 3', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (8, N'Bucuresti Sector 4', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (9, N'Bucuresti Sector 5', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (10, N'Bucuresti Sector 6', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (11, N'Braila', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (12, N'Timisoara', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (13, N'Constanta', N'Romania')
GO
INSERT [dbo].[ShippingAreas] ([LocationID], [City], [Country]) VALUES (14, N'Mures', N'Romania')
GO
SET IDENTITY_INSERT [dbo].[ShippingAreas] OFF
GO
SET IDENTITY_INSERT [dbo].[Taxes] ON 
GO
INSERT [dbo].[Taxes] ([TaxID], [Description], [Percentage]) VALUES (1, N'Asigurari sociale , CAS', 0.2)
GO
INSERT [dbo].[Taxes] ([TaxID], [Description], [Percentage]) VALUES (2, N'Asigurari de sanatate, CASS', 0.1)
GO
INSERT [dbo].[Taxes] ([TaxID], [Description], [Percentage]) VALUES (3, N'Impozit pe venit, IV', 0.1)
GO
SET IDENTITY_INSERT [dbo].[Taxes] OFF
GO
SET IDENTITY_INSERT [dbo].[Vehicles] ON 
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (1, N'GL95AFG', 3)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (2, N'GL23AVB', 1)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (3, N'B12GGG', 2)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (4, N'B13GAU', 2)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (5, N'TM67RAU', 5)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (6, N'CJ07GHJ', 3)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (7, N'BV02AXS', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (8, N'CT45LUG', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (9, N'HD98SAS', 5)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (10, N'BR32FRT', 5)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (11, N'B54RTY', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (12, N'B66ERR', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (13, N'B33AER', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (14, N'GL88TYK', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (15, N'B01RTT', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (16, N'B13GGG', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (17, N'CT95FBB', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (18, N'BR97UHB', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (19, N'BV16YYU', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (20, N'GL78TTY', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (21, N'TM45VVT', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (22, N'HD78YTE', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (23, N'CJ11IOP', 4)
GO
INSERT [dbo].[Vehicles] ([CarID], [RegistrationNumber], [BrandID]) VALUES (24, N'CT78JLN', 7)
GO
SET IDENTITY_INSERT [dbo].[Vehicles] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Unique_RegistrationNumber]    Script Date: 11-May-21 12:50:59 PM ******/
ALTER TABLE [dbo].[Vehicles] ADD  CONSTRAINT [Unique_RegistrationNumber] UNIQUE NONCLUSTERED 
(
	[RegistrationNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientAccounts]  WITH CHECK ADD  CONSTRAINT [FK_ClientIDAccount] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientAccounts] CHECK CONSTRAINT [FK_ClientIDAccount]
GO
ALTER TABLE [dbo].[Couriers]  WITH CHECK ADD FOREIGN KEY([ShippingArea])
REFERENCES [dbo].[ShippingAreas] ([LocationID])
GO
ALTER TABLE [dbo].[Couriers]  WITH CHECK ADD  CONSTRAINT [FK_CarID] FOREIGN KEY([CarID])
REFERENCES [dbo].[Vehicles] ([CarID])
GO
ALTER TABLE [dbo].[Couriers] CHECK CONSTRAINT [FK_CarID]
GO
ALTER TABLE [dbo].[Dishes]  WITH CHECK ADD  CONSTRAINT [FK__Dishes__Category__0A9D95DB] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Menu] ([CategoryID])
GO
ALTER TABLE [dbo].[Dishes] CHECK CONSTRAINT [FK__Dishes__Category__0A9D95DB]
GO
ALTER TABLE [dbo].[EmployeesTaxes]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeID] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Couriers] ([CourierID])
GO
ALTER TABLE [dbo].[EmployeesTaxes] CHECK CONSTRAINT [FK_EmployeeID]
GO
ALTER TABLE [dbo].[EmployeesTaxes]  WITH CHECK ADD  CONSTRAINT [FK_TaxID] FOREIGN KEY([TaxID])
REFERENCES [dbo].[Taxes] ([TaxID])
GO
ALTER TABLE [dbo].[EmployeesTaxes] CHECK CONSTRAINT [FK_TaxID]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_ClientID] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_ClientID]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_CourierID] FOREIGN KEY([CourierID])
REFERENCES [dbo].[Couriers] ([CourierID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_CourierID]
GO
ALTER TABLE [dbo].[ProvidersDishesRelation]  WITH CHECK ADD  CONSTRAINT [FK__Providers__DishI__0E6E26BF] FOREIGN KEY([DishID])
REFERENCES [dbo].[Dishes] ([DishID])
GO
ALTER TABLE [dbo].[ProvidersDishesRelation] CHECK CONSTRAINT [FK__Providers__DishI__0E6E26BF]
GO
ALTER TABLE [dbo].[ProvidersDishesRelation]  WITH CHECK ADD  CONSTRAINT [FK__Providers__Provi__0D7A0286] FOREIGN KEY([ProviderID])
REFERENCES [dbo].[Providers] ([ProviderID])
GO
ALTER TABLE [dbo].[ProvidersDishesRelation] CHECK CONSTRAINT [FK__Providers__Provi__0D7A0286]
GO
ALTER TABLE [dbo].[Receipt]  WITH CHECK ADD  CONSTRAINT [FK_Dish] FOREIGN KEY([DishID])
REFERENCES [dbo].[Dishes] ([DishID])
GO
ALTER TABLE [dbo].[Receipt] CHECK CONSTRAINT [FK_Dish]
GO
ALTER TABLE [dbo].[Receipt]  WITH CHECK ADD  CONSTRAINT [FK_OrderID] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[Receipt] CHECK CONSTRAINT [FK_OrderID]
GO
ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD FOREIGN KEY([BrandID])
REFERENCES [dbo].[AutoBrands] ([BrandID])
GO
ALTER TABLE [dbo].[Clients]  WITH CHECK ADD  CONSTRAINT [Check_OnlyNumbers] CHECK  (([Phone] like '%[^A-Z]%'))
GO
ALTER TABLE [dbo].[Clients] CHECK CONSTRAINT [Check_OnlyNumbers]
GO
ALTER TABLE [dbo].[Couriers]  WITH CHECK ADD  CONSTRAINT [Check_Only_Numbers_Courier] CHECK  (([Phone] like '%[^A-Z]%'))
GO
ALTER TABLE [dbo].[Couriers] CHECK CONSTRAINT [Check_Only_Numbers_Courier]
GO
ALTER TABLE [dbo].[Couriers]  WITH CHECK ADD  CONSTRAINT [Check_Salary] CHECK  (([Salary]>=(1900)))
GO
ALTER TABLE [dbo].[Couriers] CHECK CONSTRAINT [Check_Salary]
GO
ALTER TABLE [dbo].[Providers]  WITH CHECK ADD  CONSTRAINT [Check_Only_Numbers_Provider] CHECK  (([PhoneContact] like '%[^A-Z]%'))
GO
ALTER TABLE [dbo].[Providers] CHECK CONSTRAINT [Check_Only_Numbers_Provider]
GO
ALTER TABLE [dbo].[Receipt]  WITH CHECK ADD  CONSTRAINT [Check_commission_not_zero] CHECK  (([Commission]<>(0) AND [Commission]>(0)))
GO
ALTER TABLE [dbo].[Receipt] CHECK CONSTRAINT [Check_commission_not_zero]
GO
/****** Object:  StoredProcedure [dbo].[GetAllClientsByDish]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllClientsByDish]
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
GO
/****** Object:  StoredProcedure [dbo].[GetAllClientsByLetterAndDish]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllClientsByLetterAndDish]
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
	WHERE ((C.FirstName LIKE '%' + @letter + '') OR (C.LastName LIKE '%' + @letter + '')) AND D.Name = @dishName

	RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllCouriersAndVehiclesByShippedDish]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllCouriersAndVehiclesByShippedDish]
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
GO
/****** Object:  StoredProcedure [dbo].[GetAllCouriersFromShippingAreasByLetter]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllCouriersFromShippingAreasByLetter]
	@startLetter AS NVARCHAR
AS 
BEGIN
	SELECT C.FirstName + ' ' + C.LastName AS 'Courier' , C.Phone, C.HireDate, S.City AS 'Shipping Area'
	FROM Couriers AS C
	INNER JOIN ShippingAreas AS S
	ON C.ShippingArea = S.LocationID
	WHERE S.City LIKE '' + @startLetter + '%'
	
	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[GetAllDishesBetweenDates]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllDishesBetweenDates]
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
GO
/****** Object:  StoredProcedure [dbo].[GetAllDishesByCategory]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllDishesByCategory]
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
GO
/****** Object:  StoredProcedure [dbo].[GetAllDishesByCategoryAndCourier]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllDishesByCategoryAndCourier]
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

GO
/****** Object:  StoredProcedure [dbo].[GetAllDishesByCategoryAndDatetime]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllDishesByCategoryAndDatetime]
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
GO
/****** Object:  StoredProcedure [dbo].[GetAllDishesByCity]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllDishesByCity]
	@cityName AS NVARCHAR(50)
AS 
BEGIN
	SELECT DISTINCT D.Name AS 'Dish Name' 
	FROM Orders AS O
	INNER JOIN Receipt AS R
	ON O.OrderID = R.OrderID
	INNER JOIN Dishes AS D
	ON R.DishID = D.DishID
	WHERE O.City = @cityName

	RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllDishesOfferedByProvider]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllDishesOfferedByProvider]
	@providerName AS NVARCHAR(50)
AS 
BEGIN
	SELECT D.Name AS 'Dish'
	FROM Providers AS P
	INNER JOIN ProvidersDishesRelation AS PD
	ON P.ProviderID = PD.ProviderID
	INNER JOIN Dishes AS D
	ON PD.DishID = D.DishID
	WHERE P.CompanyName = @providerName;

	RETURN 
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllDishesShippedByCourier]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllDishesShippedByCourier]
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
GO
/****** Object:  StoredProcedure [dbo].[GetAllOrdersByDay]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllOrdersByDay]
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
GO
/****** Object:  StoredProcedure [dbo].[GetClientAccountDetailsByDish]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetClientAccountDetailsByDish]
	@dishName AS NVARCHAR(50)
AS 
BEGIN
	WITH SelectedDishes AS
	(
		SELECT D.*
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

GO
/****** Object:  StoredProcedure [dbo].[GetClientDishes]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetClientDishes]
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
	@cityName = 'Brasov',
	@numRows = @numRowsReturned OUTPUT ;

SELECT @numRowsReturned AS 'Number of rows returned'

GO
/****** Object:  StoredProcedure [dbo].[GetCostsByClient]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCostsByClient]
	@clientcompleteName AS NVARCHAR(50)
AS
BEGIN
	SELECT [Nume complet client],Total											-- am folosit un view deja creat
	FROM EachClientAllTimeTotal 
	WHERE [Nume complet client] = @clientcompleteName;


	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[GetCourierAndBrandByRegistrationNumber]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCourierAndBrandByRegistrationNumber]
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
GO
/****** Object:  StoredProcedure [dbo].[GetCouriersByQuarterShipping]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCouriersByQuarterShipping]
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
GO
/****** Object:  StoredProcedure [dbo].[GetEachOrderCostsByClient]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetEachOrderCostsByClient]
	@clientcompleteName AS NVARCHAR(50)
AS
BEGIN
	SELECT [Nume complet client],Total											-- am folosit un view deja creat
	FROM EachClientTotal 
	WHERE [Nume complet client] = @clientcompleteName;


	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[GetOrderDetailsByRegistrationCarNumber]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetOrderDetailsByRegistrationCarNumber]
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
GO
/****** Object:  StoredProcedure [dbo].[GetVehiclesByQuarterShipping]    Script Date: 11-May-21 12:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetVehiclesByQuarterShipping]
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
GO
USE [master]
GO
ALTER DATABASE [Food Delivery] SET  READ_WRITE 
GO
