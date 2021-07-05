select *from Clients
select *from Couriers
select *from ShippingAreas
select *from Vehicles
select *from Dishes
select *from ClientAccounts
select *from menu
select *from Orders
select *from ProvidersDishesRelation
select * from Providers
select *from Receipt



USE [Food Delivery];

-- Inserare date in tabelul Clients
INSERT INTO Clients(LastName,FirstName,Age,Address,City,Country,Phone) VALUES 
('Vasilescu','Anca','2770416520093','Strada Martisorului','Constanta','Romania','0734321289'),
('Andreescu','George','1901227380034','Strada Tricolorului','Galati','Romania','0767665110'),
('Amariei','Irina','2650709380056','Strada Ghioceilor','Braila','Romania','0728987640'),
('Silivastru','Marian','1480320050028','Strada Curcubeului','Timisoara','Romania','0756550000'),
('Capatan','Radu','1670104160051','Strada Rucarului','Brasov','Romania','0756569909'),
('Namol','Marinica','1591106280073','Strada Jijiei','Cluj','Romania','0729892110'),
('Iordan','Vlad','1560719510025','Strada Racului','Hunedoara','Romania','0765432200'),
('Chiriac','Diana','2981120250059','Strada Privighetorii','Timisoara','Romania','0723432200'),
('Istrate','Andrei','1870602190040','Strada 22 Decembrie','Galati','Romania','0723350772'),
('Crihana','Dragos','1721116370047','Strada Nufarului','Timisoara','Romania','0723457123'),
('Hodorogea','Alex','1930427110019','Strada Avioanelor Nr.24','Mures','Romania','0725655658'),
('Andriev','Maiurs','1961013180073','Strada Florilor Nr.101','Galati','Romania','0752348811'),
('Vinau','Dragos','1560316050096','Strada Aurel Vlaicu','Braila','Romania','0725555678'),
('Diaconu','Ana','2480615260084','Strada 30 Decembrie','Galati','Romania','0726386549'),
('Iordachescu','Stefania','2960718040096','Strada Anghel Saligny','Timisoara','Romania','0711111111'),
('Manole','Ion','1990728370014','Strada Nucului Nr.27','Cluj','Romania','0750001345'),
('Ionescu','Marius','1751226460080','Strada Dumitru Teodoru','Bucuresti','Romania','0720001234'),
('Adamescu','David','1681119520032','Strada Luceafarul Nr.28','Brasov','Romania','0742343212'),
('Georgescu','Mihai','1610201390059','Strada Trandafirului Nr.45','Cluj','Romania','0722227777'),
('Frumuzache','Gabriel','1840131250081','Strada George Cosbuc Nr.22','Constanta','Romania','0721287651'),
('Isaila','Marius','1460502210023','Strada Manole','Galati','Romania','0711185382'),
('Berdila','Valentin','1710810460028','Strada Ciucas Nr.15','Brasov','Romania','0738889707'),
('Beraru','Stefan','1610703010093','Strada Nufarului Nr.102','Bucuresti','Romania','0728987444'),
('Berila','Alexandru','1640906330083','Strada Orizontului','Timisoara','Romania','0723234567')

select * from ClientAccounts
-- Inserare date in tabelul ClientAccounts
INSERT INTO ClientAccounts(EmailAddress,Password,ClientID) VALUES
('vasilescu_anca@gmail.com','vasy_a123',17),
('george205@yahoo.com','geogeo11',18),
('amariei_ama@yahoo.com','irinaama23',19),
('marian123@gmail.com','marian345',20),
('radu_capatan12@gmail.com','radu12',21),
('namol_marinica@gmail.com','marinicamary55',22),
('vlad12_iordan@yahoo.ro','vlad123#$%',23),
('diana123@gmail.com','diana123!@#',24),
('andriev_marius@gmail.com','asdasfgrww332',1),
('andriev_marius@yahoo.com','agsdgaq36u63abs',1),
('vinau20dragos@yahoo.com','vinau123',2),
('diaconu1996@yahoo.com','ana678d',3),
('stefania_iordachescu22@gmail.com','stef123ggh',4),
('manole_ion23@gmail.com','2020asdddd',5),
('mariussss@gmail.com','mariusss2222',6),
('david23@gmail.com','davi123xxx',7),
('alex_andrei_yahoo.com','alexandrei123',8),
('andrei_istrate@yahoo.ro','teapaaici',9),
('dragos_crh@gmail.com','parolaveche2',10),
('diaconu_qq@gmail.com','Diaconu345',3),
('georgescu_mihai@yahoo.ro','ddd2020',11),
('frumuzache12@gmail.com','asd2020!@#',12),
('mariussssIS@gmail.com','marius551',13),
('valentin_berdy@yahoo.com','valy123',14),
('beraru_stef@yahoo.ro','Stef555',15),
('alex_andrei@yahoo.com','alexA123',16)


-- Inserare date in tabelul ShippingAreas
INSERT INTO ShippingAreas(City,Country) VALUES
('Mures','Romania'),
('Galati','Romania'),
('Brasov','Romania'),
('Cluj','Romania'),
('Hunedoara','Romania'),
('Bucuresti Sector 1','Romania'),
('Bucuresti Sector 2','Romania'),
('Bucuresti Sector 3','Romania'),
('Bucuresti Sector 4','Romania'),
('Bucuresti Sector 5','Romania'),
('Bucuresti Sector 6','Romania'),
('Braila','Romania'),
('Timisoara','Romania'),
('Constanta','Romania')



-- Inserare date in tabelul Couriers
INSERT INTO Couriers(FirstName,LastName,HireDate,Address,City,Country,Phone,ShippingArea) VALUES
('Grigorescu','Sorin','2014-09-23','Strada Nae Leonard Nr.28','Galati','Romania','0712345321',2),
('Georgescu','Mihai','2015-08-14','Strada George Cosbuc Nr.23','Braila','Romania','0754677789',11),
('Iordache','Stefan','2015-08-15','Strada Aurel Constantin','Timisoara','Romania','0743432123',12),
('Caramidaru','Paul','2018-01-5','Strada Nicolae Balcescu Nr.225','Brasov','Romania','0761239274',2),
('Apostolache','Marius','2020-06-28','Strada Stefan cel Mare Nr.22','Cluj','Romania','0721212121',3),
('Luchita','Georgiana','2021-03-03','Strada Ghiocelului Nr.123','Bucuresti','Romania','0734349980',7),
('Loghin','Andrei','2020-12-20','Strada Florilor Nr.11','Bucuresti','Romania','0744446578',5),
('Craciun','Gabriel','2020-11-08','Strada Imperiul Bizantin','Bucuresti','Romania','0723452345',6),
('Popa','Silviu','2021-02-23','Strada Crizantemei Nr.82','Bucuresti','Romania','0772222289',8),
('Mocanu','George','2021-02-28','Strada Trandafirului Nr.123','Bucuresti','Romania','074789211',10),
('Moroianu','Bogdan','2020-09-27','Strada Noptii Nr.43','Bucuresti','Romania','0711112349',8)


-- Inserare date in tabelul Couriers
INSERT INTO Couriers(FirstName,LastName,HireDate,Address,City,Country,Phone,ShippingArea,Salary,CarID) VALUES
('Mocanu','Stefan','2020-04-23','Strada Nucului Nr.128','Hunedoara','Romania','0734543454',4,4200,9),
('Petrescu','Alexandru','2020-04-23','Strada Crinului','Brasov','Romania','0722223432',2,4300,7),
('Chirita','Robert','2020-08-21','Strada Vasile Alecsandri','Galati','Romania','0722228898',1,4400,14),
('Chiriac','Liviu','2020-09-26','Strada Lupilor','Braila','Romania','0767691121',11,3800,10),
('Maftei','Vlad','2020-11-11','Strada Nuferilor','Cluj','Romania','0711114366',3,3750,6),
('Doca','George','2020-12-02','Strada Avioanelor','Timisoara','Romania','0752223211',12,4000,5),
('Hahui','Razvan','2020-04-01','Strada Lebedelor','Constanta','Romania','0733347677',13,4100,8),
('Solomon','Robert','2020-06-21','Strada Brailei','Braila','Romania','0712343278',11,3700,10),
('Condrea','Radu','2020-07-17','Strada Randunicii','Constanta','Romania','0734543390',13,3900,8),
('Nastase','Ionut','2020-07-27','Strada Lalelelor','Hunedoara','Romania','0734543421',4,4200,22),
('Adamescu','George','2020-04-20','Strada Cailor Nr. 23','Constanta','Romania','0712347790',13,4000,17),
('Lazar','Ion','2020-10-08','Strada Geamgiilor','Cluj','Romania','0745544890',3,3900,23),
('Pirvulescu','David','2020-09-18','Strada Constructorilor','Galati','Romania','0756765512',1,3800,20),
('Toma','Alexandru','2020-12-02','Strada Farului Nr.28','Timisoara','Romania','0723433009',12,4100,21),
('Mihaila','Cristian','2020-08-21','Strada Soarelui','Brasov','Romania','0747777760',2,3950,19)



-- Inserare date in tabelul Providers
INSERT INTO Providers(CompanyName,CompanyAddress,City,Country,PhoneContact,Webpage) VALUES
('Vitality Bowls','Strada Ghiocelului Nr.100','Braila','Romania','0733332123','www.vitalitybowls.com'),
('Wholesome Bites','Strada Nufarului Nr.12','Brasov','Romania','0712121212','www.wholesomebytes.com'),
('Better Taste','Strada Crinului Nr.120','Bucuresti','Romania','0734563211','www.bettertaste.com'),
('The Amazing Chicken','Strada Fericirii','Bucuresti','Romania','0744445612','www.amazingchicken.com'),
('True Food','Strada Centenarului','Bucuresti','Romania','0721238889','wwwtruefood.ro'),
('Tasty Fish','Strada Primaverii Nr.56','Timisoara','Romania','0722227689','www.tastyfish.com'),
('Cafe Coyote','Strada Lalelei Nr.22','Cluj','Romania','0738251428','www.cafecoyote.com'),
('Lovely Sweets','Strada Anotimpurilor','Galati','Romania','0753234561','www.lvlsweets.com'),
('Best Chicken','Strada Nucului','Hunedoara','Romania','0722223490','www.bestchicken.com'),
('Barbeque','Strada Florilor','Constanta','Romania','0721212210','www.barbeque.com')


-- Inserare date in tabelul Menu
INSERT INTO Menu(Category) VALUES
('Supe'),
('Ciorbe'),
('Preparate carne de pui'),
('Preparate carne de porc'),
('Preparate carne de vita'),
('Peste'),
('Fructe de mare'),
('Deserturi'),
('Bauturi alcoolice'),
('Sucuri'),
('Sosuri'),
('Garnituri'),
('Aperitive')


-- Inserare date in tabelul Dishes
INSERT INTO Dishes(Name,CategoryID) VALUES
('Snitele de porc',4),
('Friptura de pui la grill',3),
('Friptura de pui la cuptor',3),
('Dorada regala la cuptor',6),
('Creveti trasi la tigaie', 7),
('Papanasi cu dulceata',8),
('Papanasi cu ciocolata', 8),
('Tort de ciocolata',8),
('Prajitura cu fructe',8),
('Mousse de ciocolata',8),
('Lava Cake',8),
('Clatite',8),
('Jack Daniel"s',9),
('Finlandia',9),
('Captain Jack',9),
('Palinca',9),
('Visinata',9),
('Pepsi',10),
('Sprite',10),
('Coca Cola',10),
('7up',10),
('Fanta',10),
('Cartofi gratinati la cuptor',12),
('Salata de varza alba',12),
('Salata de varza rosie',12),
('Mamaliguta',12),
('Cartofi natur',12),
('Cartofi prajiti',12),
('Piure de cartofi',12),
('Salata de rosii',12),
('Salata de rosii si castraveti',12),
('Salata de verdeturi',12),
('Masline',13),
('Alune',13),
('Bruschete',13),
('Sos de usturoi', 11),
('Sos de rodie',11),
('Ketchup',11),
('Pastrav la grill',6),
('Crap la cuptor',6),
('Salata de icre',6),
('Caras prajit',6),
('Vita Argentina',5),
('Friptura servita pe piatra incinsa',5),
('Carnati taranesti',4),
('Mititei',4),
('Pulpa de pui la grill',3),
('Snitele de pui',3),
('Rulada de pui',3),
('Ciorba radauteana',2),
('Ciorba de legume',2),
('Ciorba de burta',2),
('Ciorba taraneasca',2),
('Ciorba de fasole in paine',2),
('Ciorba de perisoare',2),
('Supa de pui',1),
('Supa cu galuste', 1)


-- Inserare date in tabelul ProvidersDishesRelation
INSERT INTO ProvidersDishesRelation(ProviderID,DishID,Date,Quantity) VALUES
(4,1,'2021-04-12',1),
(4,2,'2021-04-05',4),
(8,5,'2021-04-05',4),
(8,10,'2021-04-13',2),
(8,11,'2021-03-26',5),
(6,3,'2021-04-25',2),
(6,35,'2021-4-25',2),
(6,12,'2021-04-25',2),
(7,18,'2021-04-26',4),
(7,19,'2021-04-04',2),
(5,49,'2021-04-05',1),
(5,50,'2021-04-05',1),
(5,54,'2021-04-14',1),
(3,51,'2021-03-27',1),
(3,56,'2021-03-25',1),
(3,52,'2021-03-21',1)


-- Inserare date in tabelul Orders
INSERT INTO Orders(ClientID,CourierID,ExpectedDate,Address,City,Country) VALUES
(3,2,'2021-04-02','Strada 30 Decembrie','Galati','Romania'),
(4,3,'2021-04-05','Strada Anghel Saligny','Timisoara','Romania'),
(2,2,'2021-03-25','Strada Aurel Vlaicu','Braila','Romania'),
(6,7,'2021-04-15','Strada Lupului','Bucuresti','Romania'),
(9,1,'2021-04-22','Strada 22 Decembrie','Galati','Romania'),
(19,15,'2021-05-05','Strada Nucului Nr.145','Braila','Romania'),
(2,19,'2021-05-14','Strada Fecioarei','Braila','Romania'),
(18,14,'2021-04-09','Strada Constructorilor Nr.101','Galati','Romania'),
(9,26,'2021-05-12','Strada Ionascu','Galati','Romania'),
(13,14,'2021-05-13','Strada Aurel Vlaicu','Galati','Romania'),
(7,4,'2021-05-15','Strada Avioanelor Nr.107','Brasov','Romania'),
(14,13,'2021-04-21','Strada Izvorul Muntelui','Brasov','Romania'),
(21,28,'2021-04-22','Strada Tapului Nr.24','Brasov','Romania'),
(23,12,'2021-04-23','Strada Borsec Nr.4','Hunedoara','Romania'),
(5,5,'2021-04-17','Strada Horei Nr.5','Cluj','Romania'),
(11,16,'2021-05-29','Strada Caprelor Nr.56','Cluj','Romania'),
(22,25,'2021-05-08','Strada Sperantei Nr.12','Cluj','Romania'),
(4,17,'2021-05-06','Strada Ion Creanga','Timisoara','Romania'),
(10,27,'2021-05-07','Strada Mihai Eminescu','Timisoara','Romania'),
(24,17,'2021-05-07','Strada Dimitrie Cantemir','Timisoara','Romania'),
(16,3,'2021-02-22','Strada Sforilor','Timisoara','Romania'),
(20,27,'2021-03-02','Strada Capatan','Timisoara','Romania'),
(12,18,'2021-04-26','Strada Siderurgistilor','Constanta','Romania'),
(17,20,'2021-05-01','Strada Florilor Nr.12','Constanta','Romania'),
(17,24,'2021-05-02','Strada Ghioceilor Nr.12','Constanta','Romania')



-- Inserare date in tabelul Receipt
INSERT INTO Receipt(OrderID,DishID,Quantity,UnitPrice,Voucher,Commission) VALUES 
(6,6,1,12,0,1),
(6,7,1,13,0,1),
(6,9,1,15,0,1),
(7,1,3,17,0,2),
(7,22,3,5,0,1),
(7,21,2,5,0,1),
(7,24,3,4,0,1),
(8,48,1,24,0,2),
(8,49,1,15,0,2),
(8,29,1,12,0,1),
(9,42,1,84,0,10),
(9,26,1,7,0,1),
(9,24,1,7,0,1),
(10,19,10,7,0,1),
(11,20,15,7,0,1),
(12,4,1,34,0,5),
(13,10,1,23,0,4),
(14,11,1,14,0,2),
(14,12,1,15,0,2),
(15,50,1,11,0,1),
(16,51,2,15,0,2),
(17,56,4,12,0,2),
(18,55,2,13,0,2),
(18,1,2,17,0,2),
(18,35,2,4,0,1),
(19,47,1,14,0,2),
(19,51,1,15,0,2),
(19,30,1,11,0,2),
(20,38,1,25,0,2),
(20,25,1,10,0,1),
(4,5,1,21,5,2),
(2,3,3,17,0,3),
(2,12,2,4,0,1),
(2,35,2,2,0,1),
(5,11,5,13,0,3),
(3,10,1,14,0,2),
(1,8,1,12,0,1)



-- Inserare date in tabelul Vehicles
INSERT INTO Vehicles(RegistrationNumber) VALUES
('B01RTT'),
('GL95AFG'),
('GL23AVB'),
('B12GGG'),
('B13GAU'),
('TM67RAU'),
('CJ07GHJ'),
('BV02AXS'),
('CT45LUG'),
('HD98SAS'),
('BR32FRT'),
('B54RTY'),
('B66ERR'),
('B33AER'),
('GL88TYK'),
('B13GGG'),
('CT95FBB'),
('BR97UHB'),
('BV16YYU'),
('GL78TTY'),
('TM45VVT'),
('HD78YTE'),
('CJ11IOP')


-- Inserare date in tabelul AutoBrands
INSERT INTO AutoBrands(BrandName) VALUES
('Skoda'),
('Volkswagen'),
('Audi'),
('Dacia'),
('Renault'),
('Citroen')



-- Inserare date in tabelul Taxes
INSERT INTO Taxes VALUES 
('Asigurari sociale , CAS' ,0.2),
('Asigurari de sanatate, CASS' ,0.1),
('Impozit pe venit, IV', 0.1)


-- Inserare date in tabelul EmployeesTaxes
INSERT INTO EmployeesTaxes VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6),
(1,7),
(1,8),
(1,9),
(1,10),
(1,11),
(1,12),
(1,13),
(1,14),
(1,15),
(1,16),
(1,17),
(1,18),
(1,19),
(1,20),
(1,23),
(1,24),
(1,25),
(1,26),
(1,27),
(1,28),
(2,1),
(2,2),
(2,3),
(2,4),
(2,5),
(2,6),
(2,7),
(2,8),
(2,9),
(2,10),
(2,11),
(2,12),
(2,13),
(2,14),
(2,15),
(2,16),
(2,17),
(2,18),
(2,19),
(2,20),
(2,23),
(2,24),
(2,25),
(2,26),
(2,27),
(2,28),
(3,1),
(3,2),
(3,3),
(3,4),
(3,5),
(3,6),
(3,7),
(3,8),
(3,9),
(3,10),
(3,11),
(3,12),
(3,13),
(3,14),
(3,15),
(3,16),
(3,17),
(3,18),
(3,19),
(3,20),
(3,23),
(3,24),
(3,25),
(3,26),
(3,27),
(3,28)