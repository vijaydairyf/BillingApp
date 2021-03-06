/****** Object:  StoredProcedure [dbo].[S1_BillingImport_UpdateTransUnionSurcharges]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec S1_BillingImport_UpdateTransUnionSurcharges '06/01/2010', '06/30/2010'

CREATE PROCEDURE [dbo].[S1_BillingImport_UpdateTransUnionSurcharges]
(
	@startdate datetime,
	@enddate datetime
)
AS
SET NOCOUNT ON;
Begin

	Declare @errorcode int	
	
	Set @errorcode = 0

		
	BEGIN TRANSACTION

	insert into ProductTransactions (ProductID, ClientID, VendorID, TransactionDate, DateOrdered, OrderBy, Reference, FileNum, FName, LName, MName, SSN, ProductName, ProductDescription, ProductType, ProductPrice, ExternalInvoiceNumber, SalesRep, CoLName, CoFName, CoMName, SoSSN)
	select PT.ProductID, PT.ClientID, PT.VendorID, PT.TransactionDate, PT.DateOrdered, PT.OrderBy, PT.Reference, PT.FileNum, PT.FName, 
	PT.LName, PT.MName, PT.SSN, PT.ProductName, PT.ProductDescription, PT.ProductType, 
	PT.ProductPrice/
	(select COUNT(PT2.ProductTransactionID) from ProductTransactions PT2 
	WHERE PT2.ClientID = PT1.ClientID and PT2.VendorID = PT1.Vendorid and PT2.ProductID = PT1.ProductID),
	PT.ExternalInvoiceNumber, PT.SalesRep, PT.CoLName, PT.CoFName, PT.CoMName, PT.SoSSN
	 from ProductTransactions PT
	inner join ProductTransactions PT1 on PT1.ClientID = PT.ClientID and PT1.VendorID = PT.VendorID and PT1.ProductID = 175
	WHERE PT.ClientID in (590, 1480,43, 45, 46, 47, 48, 49, 50, 51, 52, 53, 1658, 1659, 1660, 1661, 2690, 2722)
	  AND PT.VendorID = 4
	  AND PT.ProductID = 178
	  AND PT.TransactionDate between @startdate and @enddate
	  order by PT.clientid
	  
	if(@@ERROR <> 0)
	Begin
		set @errorcode = -1
		Goto Cleanup
	End	
	Else
	Begin
	
		COMMIT TRANSACTION
		Return @errorcode
	End
		  
	

Cleanup:

    BEGIN
    	ROLLBACK TRANSACTION
    END

    RETURN @errorcode
	
End






GO
