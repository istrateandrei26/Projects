
--150. Creati o tranzactie cu ajutorul careia sa inserati date in tabela AutoBrands, dar si in tabela Vehicles 

BEGIN TRY
	BEGIN TRAN 
		INSERT INTO AutoBrands VALUES
		('Ford');

		DECLARE @brandID INT;

		SELECT @brandID = AB.BrandID
		FROM AutoBrands AS AB
		WHERE AB.BrandName = 'Ford';

		INSERT INTO Vehicles VALUES
		('CT78JLN',@brandID);
		
	COMMIT
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 -- Duplicate key violation
	BEGIN
		PRINT 'Primary Key violation';
	END
	ELSE IF ERROR_NUMBER() = 547 -- Constraint violations
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END;

	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH


--151. Creati o tranzactie cu ajutorul careia sa inserati date in urmatoarele tabele : Providers, Dishes, ProvidersDishesRelation

BEGIN TRY
	BEGIN TRAN 
		INSERT INTO Providers VALUES 
		('Tasty Grills','Strada Mihai Viteazul Nr. 123','Timisoara','Romania','0742222222','www.tastyGrills.com');

		DECLARE @categoryID INT;
		SELECT @categoryID = M.CategoryID
		FROM Menu AS M
		WHERE M.Category = 'Peste';

		INSERT INTO Dishes VALUES
		('Sushi',@categoryID);

		DECLARE @providerID INT ;
		SELECT @providerID = P.ProviderID
		FROM Providers AS P
		WHERE P.CompanyName = 'Tasty Grills';

		DECLARE @dishID INT;
		SELECT @dishID = D.DishID
		FROM Dishes AS D
		WHERE D.Name = 'Sushi';


		INSERT INTO ProvidersDishesRelation VALUES 
		(@providerID,@dishID,'2020-02-05',10);
		
	COMMIT
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 -- Duplicate key violation
	BEGIN
		PRINT 'Primary Key violation';
	END
	ELSE IF ERROR_NUMBER() = 547 -- Constraint violations
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END;

	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH


--152. Creati o tranzactie cu ajutorul careia sa stergeti date din urmatoarele tabele : Providers, Clients

BEGIN TRY
	BEGIN TRAN 
		DELETE Providers 
		WHERE CompanyName = 'Tasty Grills';

		DELETE Clients 
		WHERE LastName + ' ' + FirstName = 'Dumitriu Vlad';
	COMMIT
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 -- Duplicate key violation
	BEGIN
		PRINT 'Primary Key violation';
	END
	ELSE IF ERROR_NUMBER() = 547 -- Constraint violations
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END;

	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH


--153. Creati o tranzatie cu ajutorul careia sa modificati date din urmatoarele tabele : Clients ,Couriers, Vehicles

BEGIN TRY
	BEGIN TRAN 
		UPDATE Clients 
		SET Address = 'Strada Siderurgiei Nr. 17'
		WHERE ClientID = 8

		UPDATE Couriers 
		SET CarID = 100 -- va genera eroare
		WHERE CourierID = 1

		UPDATE Vehicles 
		SET BrandID = 1
		where CarID = 1
	COMMIT
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 -- Duplicate key violation
	BEGIN
		PRINT 'Primary Key violation';
	END
	ELSE IF ERROR_NUMBER() = 547 -- Constraint violations
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END;

	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH



--154. Creati o tranzactie cu ajutorul careia sa inserati date in urmatoarele tabele : Clients, Couriers , Vehicles


BEGIN TRY
	BEGIN TRAN 
		
		INSERT INTO Clients VALUES 
		('Monea','Catalin','1991125170035','Strada Primaverii Nr. 3','Galati','Romania','0744446644');

		DECLARE @brand INT ;
		SELECT @brand = AB.BrandID
		FROM AutoBrands AS AB
		WHERE AB.BrandName = 'Renault'

		INSERT INTO Vehicles VALUES
		('GL89JKN',@brand);

		DECLARE @carID INT ;
		SELECT @carID = V.CarID
		FROM Vehicles AS V
		WHERE v.RegistrationNumber = 'GL89JKN';

		INSERT INTO Couriers VALUES
		('Chiriac','Cristian','2021-05-01','Strada Zambilei Nr. 9','Galati','Romania','0754343222',1,3600,@carID);


	COMMIT
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 -- Duplicate key violation
	BEGIN
		PRINT 'Primary Key violation';
	END
	ELSE IF ERROR_NUMBER() = 547 -- Constraint violations
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE IF ERROR_NUMBER() = 50011 -- Salary Trigger !! 
	BEGIN
		PRINT 'Salary should be at least 3700 !';
	END;
	ELSE
	BEGIN 
		PRINT 'Unhandled error';
	END
	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH




