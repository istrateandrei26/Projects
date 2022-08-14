USE [master]
GO
/****** Object:  Database [AirlineReservationSystem]    Script Date: 14-Dec-21 11:23:38 AM ******/
CREATE DATABASE [AirlineReservationSystem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AirlineReservationSystem', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AirlineReservationSystem.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AirlineReservationSystem_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AirlineReservationSystem_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [AirlineReservationSystem] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AirlineReservationSystem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AirlineReservationSystem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET ARITHABORT OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AirlineReservationSystem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AirlineReservationSystem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET  ENABLE_BROKER 
GO
ALTER DATABASE [AirlineReservationSystem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AirlineReservationSystem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET RECOVERY FULL 
GO
ALTER DATABASE [AirlineReservationSystem] SET  MULTI_USER 
GO
ALTER DATABASE [AirlineReservationSystem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AirlineReservationSystem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AirlineReservationSystem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AirlineReservationSystem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AirlineReservationSystem] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AirlineReservationSystem] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'AirlineReservationSystem', N'ON'
GO
ALTER DATABASE [AirlineReservationSystem] SET QUERY_STORE = OFF
GO
USE [AirlineReservationSystem]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 14-Dec-21 11:23:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[IdClient] [int] IDENTITY(1,1) NOT NULL,
	[Nume] [nvarchar](50) NOT NULL,
	[Prenume] [nvarchar](50) NOT NULL,
	[CNP] [char](13) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Varsta] [int] NOT NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[IdClient] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientsNTickets]    Script Date: 14-Dec-21 11:23:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientsNTickets](
	[IdClient] [int] NOT NULL,
	[IdBilet] [int] NOT NULL,
 CONSTRAINT [PK_ClientsNTickets_1] PRIMARY KEY CLUSTERED 
(
	[IdClient] ASC,
	[IdBilet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Credentials]    Script Date: 14-Dec-21 11:23:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credentials](
	[IdCredentiale] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](88) NOT NULL,
	[IdClient] [int] NOT NULL,
	[Salt] [nvarchar](16) NULL,
 CONSTRAINT [PK_Credentials] PRIMARY KEY CLUSTERED 
(
	[IdCredentiale] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Flights]    Script Date: 14-Dec-21 11:23:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Flights](
	[IdZbor] [int] IDENTITY(1,1) NOT NULL,
	[Destinatie] [nvarchar](50) NOT NULL,
	[Plecare] [nvarchar](50) NOT NULL,
	[DataSiOraDecolarii] [datetime] NOT NULL,
	[DataSiOraSosirii] [datetime] NOT NULL,
	[TotalLocuriDisponibile] [int] NOT NULL,
	[Pret] [float] NULL,
 CONSTRAINT [PK_Flights] PRIMARY KEY CLUSTERED 
(
	[IdZbor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tickets]    Script Date: 14-Dec-21 11:23:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tickets](
	[IdBilet] [int] IDENTITY(1,1) NOT NULL,
	[IdZbor] [int] NOT NULL,
 CONSTRAINT [PK_Tickets] PRIMARY KEY CLUSTERED 
(
	[IdBilet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Clients] ON 

INSERT [dbo].[Clients] ([IdClient], [Nume], [Prenume], [CNP], [Email], [Varsta]) VALUES (1, N'Cucuta', N'Radu', N'5000925450028', N'radu.cucuta@yahoo.ro', 21)
INSERT [dbo].[Clients] ([IdClient], [Nume], [Prenume], [CNP], [Email], [Varsta]) VALUES (51, N'Last name', N'First name', N'CNP          ', N'Email', 20)
INSERT [dbo].[Clients] ([IdClient], [Nume], [Prenume], [CNP], [Email], [Varsta]) VALUES (52, N'Popa', N'Alex', N'123456789    ', N'alexyahoo.com', 20)
INSERT [dbo].[Clients] ([IdClient], [Nume], [Prenume], [CNP], [Email], [Varsta]) VALUES (53, N'newUser', N'user', N'CNPUser      ', N'EmailUser', 20)
INSERT [dbo].[Clients] ([IdClient], [Nume], [Prenume], [CNP], [Email], [Varsta]) VALUES (54, N'Ionut', N'Mihai', N'1234567891234', N'mihai@yahoo.com', 20)
SET IDENTITY_INSERT [dbo].[Clients] OFF
GO
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (1, 1)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 4)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 1006)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 1007)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 1008)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 1009)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 1010)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 1011)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 1012)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 1013)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (51, 1014)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (52, 1004)
INSERT [dbo].[ClientsNTickets] ([IdClient], [IdBilet]) VALUES (52, 1005)
GO
SET IDENTITY_INSERT [dbo].[Credentials] ON 

INSERT [dbo].[Credentials] ([IdCredentiale], [Username], [Password], [IdClient], [Salt]) VALUES (1, N'Username', N'gFKSn9qX7+E9QI7/Yxw19wc5Ic0vWN7JfUMHGgs365ts6o35lITqdEof5BdTWQcDPkFLbAar5rJhhkKN2t9dwQ==', 51, N'z2X0zkJuL50yJO0V')
INSERT [dbo].[Credentials] ([IdCredentiale], [Username], [Password], [IdClient], [Salt]) VALUES (2, N'alexpopa2000', N'sJw/VuVrSRpwA/4rqtbnQu3vecJ+nltpHCS7x5ql1c+CuNirt+hooFqV8JA0+gzehqUPxuyvAXeaJ7BULF1pMA==', 52, N'Odio6/F0uAQHj/cj')
INSERT [dbo].[Credentials] ([IdCredentiale], [Username], [Password], [IdClient], [Salt]) VALUES (1002, N'Username1', N'RA8xKk6pbsEw0Hfm6CX8i0kzK2zRFe843VRUjAiBd8CKWoOa3F1SurzFGOTxxNeI2Rr1SDkiRL1IVZgiSKUWLA==', 53, N'p0xIKQg7htkLfvqw')
INSERT [dbo].[Credentials] ([IdCredentiale], [Username], [Password], [IdClient], [Salt]) VALUES (1003, N'mihai1234', N'SGowmbpdz8GRxvA7+XA7C+z9NmazMruXCayDuroBXXGKYGkXPAAEBobtYNN35Cgr7Vvs9hdo7LwD5VqEYl2IMA==', 54, N'li73mCfiImavPLq8')
SET IDENTITY_INSERT [dbo].[Credentials] OFF
GO
SET IDENTITY_INSERT [dbo].[Flights] ON 

INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (1, N'Spania,Ibiza', N'Romania Henri Coanda', CAST(N'2021-11-20T00:00:00.000' AS DateTime), CAST(N'2021-11-20T04:00:00.000' AS DateTime), 300, 190)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (2, N'Bulgaria,Sofia', N'Romania,Bucuresti', CAST(N'2021-11-06T00:00:00.000' AS DateTime), CAST(N'2021-11-06T00:00:00.000' AS DateTime), 60, 100)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (3, N'Spania,Madrid', N'Romania,Bucuresti', CAST(N'2021-12-24T00:00:00.000' AS DateTime), CAST(N'2021-12-25T00:00:00.000' AS DateTime), 70, 120)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (4, N'Franta,Paris', N'Romania,Bucuresti', CAST(N'2021-11-06T00:00:00.000' AS DateTime), CAST(N'2021-11-06T00:00:00.000' AS DateTime), 200, 56)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (5, N'Ungaria,Budapesta', N'Romania,Bucuresti', CAST(N'2021-12-01T00:00:00.000' AS DateTime), CAST(N'2021-12-01T00:00:00.000' AS DateTime), 120, 59)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (6, N'Romania,Bucuresti', N'Germania,Berlin', CAST(N'2022-07-01T00:00:00.000' AS DateTime), CAST(N'2022-07-02T00:00:00.000' AS DateTime), 111, 75)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (7, N'Romania,Craiova', N'Romania,Bucuresti', CAST(N'2022-01-05T00:00:00.000' AS DateTime), CAST(N'2022-01-05T00:00:00.000' AS DateTime), 185, 80)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (8, N'Spania,Barcelona', N'Romania,Bucuresti', CAST(N'2022-06-06T00:00:00.000' AS DateTime), CAST(N'2022-06-06T00:00:00.000' AS DateTime), 0, 200)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (9, N'Romania,Bucuresti', N'Romania,Craiova', CAST(N'2022-01-06T00:00:00.000' AS DateTime), CAST(N'2022-01-06T00:00:00.000' AS DateTime), 169, 100)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (10, N'Rusia,Moscova', N'Franta,Marseille', CAST(N'2022-01-10T00:00:00.000' AS DateTime), CAST(N'2022-01-10T00:00:00.000' AS DateTime), 198, 150)
INSERT [dbo].[Flights] ([IdZbor], [Destinatie], [Plecare], [DataSiOraDecolarii], [DataSiOraSosirii], [TotalLocuriDisponibile], [Pret]) VALUES (11, N'Franta,Marseille', N'Rusia,Moscova', CAST(N'2022-01-11T00:00:00.000' AS DateTime), CAST(N'2022-01-11T00:00:00.000' AS DateTime), 99, 250)
SET IDENTITY_INSERT [dbo].[Flights] OFF
GO
SET IDENTITY_INSERT [dbo].[Tickets] ON 

INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1, 1)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (2, 3)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (3, 2)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (4, 7)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1004, 5)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1005, 3)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1006, 6)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1007, 7)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1008, 7)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1009, 7)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1010, 7)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1011, 9)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1012, 10)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1013, 11)
INSERT [dbo].[Tickets] ([IdBilet], [IdZbor]) VALUES (1014, 10)
SET IDENTITY_INSERT [dbo].[Tickets] OFF
GO
ALTER TABLE [dbo].[ClientsNTickets]  WITH CHECK ADD  CONSTRAINT [FK_ClientsNTickets_Clients] FOREIGN KEY([IdClient])
REFERENCES [dbo].[Clients] ([IdClient])
GO
ALTER TABLE [dbo].[ClientsNTickets] CHECK CONSTRAINT [FK_ClientsNTickets_Clients]
GO
ALTER TABLE [dbo].[ClientsNTickets]  WITH CHECK ADD  CONSTRAINT [FK_ClientsNTickets_Tickets] FOREIGN KEY([IdBilet])
REFERENCES [dbo].[Tickets] ([IdBilet])
GO
ALTER TABLE [dbo].[ClientsNTickets] CHECK CONSTRAINT [FK_ClientsNTickets_Tickets]
GO
ALTER TABLE [dbo].[Credentials]  WITH CHECK ADD  CONSTRAINT [FK_Credentials_Clients] FOREIGN KEY([IdClient])
REFERENCES [dbo].[Clients] ([IdClient])
GO
ALTER TABLE [dbo].[Credentials] CHECK CONSTRAINT [FK_Credentials_Clients]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_Flights] FOREIGN KEY([IdZbor])
REFERENCES [dbo].[Flights] ([IdZbor])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_Tickets_Flights]
GO
/****** Object:  StoredProcedure [dbo].[LoginProcedure]    Script Date: 14-Dec-21 11:23:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[LoginProcedure]
	@username AS NVARCHAR(100),
	@password AS NVARCHAR(88)
AS
BEGIN
	SELECT C.IdClient
	FROM Credentials AS C
	WHERE @username = C.Username AND @password = C.Password
END
GO
/****** Object:  StoredProcedure [dbo].[RegisterProcedure]    Script Date: 14-Dec-21 11:23:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[RegisterProcedure]
	@FirstName AS NVARCHAR(50),
	@LastName AS NVARCHAR(50),
	@Email AS NVARCHAR(70),
	@CNP AS NVARCHAR(13),
	@Age AS NVARCHAR(3),
	@username AS NVARCHAR(100),
	@password AS NVARCHAR(88),
	@salt AS NVARCHAR(16),
	@numRows AS INT = 0 OUTPUT
AS
BEGIN
	IF EXISTS(
	SELECT COUNT(*)
	FROM Clients CL
	INNER JOIN Credentials AS CR
	ON CL.IdClient = CR.IdClient
	WHERE CL.CNP = @CNP OR
		  CR.Username = @username
		  HAVING COUNT(*) > 0
		  )
	BEGIN
		SET @numRows = 0;
	END
	ELSE
	BEGIN
		INSERT INTO Clients VALUES(@LastName,@FirstName,@CNP,@Email,@Age);
		DECLARE @id AS INT;
		SELECT TOP 1 @id = IdClient
		FROM Clients
		ORDER BY IdClient DESC
		INSERT INTO Credentials VALUES(@username,@password,@id,@salt);
		SET @numRows = @@ROWCOUNT
		RETURN;
	END
END
GO
USE [master]
GO
ALTER DATABASE [AirlineReservationSystem] SET  READ_WRITE 
GO
