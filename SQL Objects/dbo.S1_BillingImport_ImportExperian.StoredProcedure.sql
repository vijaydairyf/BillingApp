/****** Object:  StoredProcedure [dbo].[S1_BillingImport_ImportExperian]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec S1_BillingImport_ImportExperian 5

CREATE PROCEDURE [dbo].[S1_BillingImport_ImportExperian]
(
	@vendorid int
)
AS
SET NOCOUNT ON;
Begin

	Declare @errorcode int
			
	Set @errorcode = 0
	
	if exists(select top 1 * 
			from ProductTransactions 
			where ImportBatchID in (
				select distinct importbatchid 
				from ImportBatch I 
				where I.ImportBatchFileName = 
					(select ImportBatchFileName from ImportBatch where ImportBatchID = (select distinct ImportBatchID from ExperianImport)))
	)
	BEGIN
		set @errorcode = -2
		RETURN @errorcode
	END
	ELSE
	BEGIN
	
	BEGIN TRANSACTION

		INSERT INTO ProductTransactions (ProductID, ClientID, VendorID, DateOrdered, TransactionDate, OrderBy, Reference, 
		FileNum, FName, LName, MName, SSN, ProductName, ProductDescription, ProductType, ProductPrice, ExternalInvoiceNumber, 
		SalesRep, ImportBatchID)
		SELECT ProductID, ClientID, VendorID, XPInquiryDate, XPInquiryDate as TransactionDate, XPOperatorID, XPMKeyWord, null, XPFirstName, XPLastName, XPMiddleName, XPSSN, ProductName,
		ProductDesc, 'EXPERIAN', XPProductPrice, ExternalInvoiceNumber, SalesRep, ImportBatchID
		from 
		( 
		select XPFirstName, XPLastName, @vendorid as VendorID, XPMiddleName, XPSSN, XPOperatorID, XPMKeyWord,  XPInquiryDate, ImportBatchID, 
		P.ProductName as ProductDesc, XPProductPrice, ProductID, P.ProductName, null as ProductType, null as SalesRep,XPInvoiceCodes as ExternalInvoiceNumber, CV.ClientID
		from  ExperianImport XP
		INNER JOIN Products P
			ON XP.XPProductCode = P.ProductCode 
		  AND P.ProductID in (select ProductID from VendorProducts where VendorID = @vendorid)
		INNER JOIN ClientVendors CV
			ON CV.VendorClientNumber = XP.XPSubcode and CV.VendorID = @vendorid
		) a

		ORDER BY XPFirstName, XPLastName, XPSSN, XPOperatorID, XPInquiryDate
	
	if(@@ERROR <> 0)
	Begin
		set @errorcode = -1
		Goto Cleanup
	End	
	Else
	Begin
	
		COMMIT TRANSACTION
		
		Update ImportBatch set ImportSuccess = 1 where ImportBatchID = (select distinct ImportBatchID from ExperianImport)
		Return @errorcode
	End
	
	

	
Cleanup:

    BEGIN
    	ROLLBACK TRANSACTION
    	Update ImportBatch set ImportSuccess = 0 where ImportBatchID = (select distinct ImportBatchID from ExperianImport)
    END

    RETURN @errorcode
	END
End






GO
