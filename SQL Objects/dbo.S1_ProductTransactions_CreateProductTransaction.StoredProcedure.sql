/****** Object:  StoredProcedure [dbo].[S1_ProductTransactions_CreateProductTransaction]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--S1_ProductTransactions_CreateProductTransaction

CREATE PROCEDURE [dbo].[S1_ProductTransactions_CreateProductTransaction]
(
	@ProductID int, 
	@ClientID int, 
	@VendorID int, 
	@TransactionDate datetime,
	@DateOrdered datetime, 
	@OrderBy varchar(50), 
	@Reference varchar(50), 
	@FileNum varchar(50), 
	@FName varchar(50), 
	@LName varchar(50), 
	@MName varchar(50), 
	@SSN varchar(50), 
	@ProductDescription varchar(max), 
	@ProductType varchar(50), 
	@ProductPrice money
)
AS
	SET NOCOUNT ON;
	
	INSERT INTO ProductTransactions (ProductID, ClientID, VendorID, TransactionDate, 
	DateOrdered, OrderBy, Reference, FileNum, FName, LName, MName, SSN, ProductDescription, 
	ProductType, ProductPrice)
	VALUES (@ProductID, @ClientID, @VendorID, @TransactionDate, @DateOrdered, @OrderBy, 
	@Reference, @FileNum, @FName, @LName, @MName, @SSN, @ProductDescription, @ProductType, 
	@ProductPrice)

GO
