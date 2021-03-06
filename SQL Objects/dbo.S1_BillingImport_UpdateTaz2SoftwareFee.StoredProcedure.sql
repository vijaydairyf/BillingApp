/****** Object:  StoredProcedure [dbo].[S1_BillingImport_UpdateTaz2SoftwareFee]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec S1_BillingImport_UpdateTaz2SoftwareFee 

CREATE PROCEDURE [dbo].[S1_BillingImport_UpdateTaz2SoftwareFee]

AS
SET NOCOUNT ON;
Begin

	Declare @errorcode int	
	
	Set @errorcode = 0


	BEGIN TRANSACTION


	INSERT INTO ProductTransactions (ProductID, ClientID, VendorID, DateOrdered, TransactionDate, OrderBy, Reference, 
	FileNum, FName, LName, MName, SSN, ProductName, ProductDescription, ProductType, ProductPrice, ExternalInvoiceNumber, 
	SalesRep, CoLName, CoFName, CoSSN, ImportBatchID)
	SELECT 	251, PT.ClientID, PT.VendorID, PT.DateOrdered, PT.TransactionDate, PT.OrderBy, PT.Reference, PT.FileNum, PT.FName, 
		PT.LName, PT.MName, PT.SSN, (select productname from products where productid = 251) as ProductName, (select productname from products where productid = 251) as ProductDescription, 
		'FEE', (select salesprice from clientproducts where clientid = pt.clientid and productid = 251), PT.ExternalInvoiceNumber, PT.SalesRep, PT.CoLName, PT.CoFName, PT.CoSSN, PT.ImportBatchID	
	FROM ProductTransactions PT
	WHERE PT.ImportBatchID = (select max(importbatchid) from ImportBatch where ImportBatchVendorID = 2 and ImportSuccess = 1)
	AND PT.ClientID in (select clientid from ClientProducts where ProductID = 251 and ImportsAtBaseOrSales = 0)
	AND PT.VendorID = 2
	GROUP BY FileNum, ClientID, VendorID, DateOrdered, TransactionDate, OrderBy, Reference, FName, LName, MName, SSN, ExternalInvoiceNumber, SalesRep, CoLName, CoFName, CoSSN, pt.ImportBatchID
		  

	  
	if(@@ERROR <> 0)
	Begin
		set @errorcode = -1
		ROLLBACK TRANSACTION
	End	
	Else
	Begin
	
		COMMIT TRANSACTION
		  
	End


	
    return @errorcode

END	







GO
