/****** Object:  StoredProcedure [dbo].[S1_BillingImport_ImporteDrug]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec S1_BillingImport_ImporteDrug 8


CREATE PROCEDURE [dbo].[S1_BillingImport_ImporteDrug]
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
					(select ImportBatchFileName from ImportBatch where ImportBatchID = (select distinct ImportBatchID from eDrugImport)))
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
		SELECT ProductID, ClientID, VendorID, a.ServiceDate, a.ServiceDate as TransactionDate, 'applicantONE', 'Pre-Employment', COCNumber, '', EmployeeName, '', SSN, ProductName,
		ProductDesc, 'employment', Fee, ExternalInvoiceNumber, SalesRep, ImportBatchID
		from 
		( 
		select ED.EmployeeName, @vendorid as VendorID, ED.SSN, ED.ServiceDate, ImportBatchID, 
		Replace(ed.Comments, 'EDI Billed', 'Drug Test') as ProductDesc, ED.Fee, ProductID, P.ProductName, null as ProductType, null as SalesRep, ED.InvoiceNumber as ExternalInvoiceNumber, CV.ClientID, ED.COCNumber
		from  eDrugImport ED
		INNER JOIN Products P
			ON ED.Product = P.ProductCode 
		  AND P.ProductID in (select ProductID from VendorProducts where VendorID = @vendorid)
		INNER JOIN ClientVendors CV
			ON (CV.VendorClientNumber = ED.CustomerNumber + ED.LocationCode or CV.VendorClientNumber = ED.CustomerNumber) and CV.VendorID = @vendorid
		) a

		ORDER BY a.EmployeeName, a.SSN, a.ServiceDate
		

	
	if(@@ERROR <> 0)
	Begin
		set @errorcode = -1
		Goto Cleanup
	End	
	Else
	Begin
	
		COMMIT TRANSACTION
		
		Update ImportBatch set ImportSuccess = 1 where ImportBatchID = (select distinct ImportBatchID from eDrugImport)
		
		INSERT INTO ProductTransactions(ProductID, ClientID, VendorID, TransactionDate, DateOrdered, OrderBy, Reference, FileNum, FName, LName, MName, SSN, ProductName, ProductDescription, ProductType, ProductPrice, ExternalInvoiceNumber, SalesRep, CoLName, CoFName, CoMName, CoSSN, ImportBatchID, Invoiced)
		SELECT 368, ClientID, VendorID, TransactionDate, DateOrdered, OrderBy, Reference, FileNum, FName, LName, MName, p.SSN, 'Third Party Drug Fee', 'Third Party Collection Fee', ProductType, case when e.Comments like '%Tier 3%' then 3.00 when e.Comments like '%Tier 4%' then 7.00 else 11.00 end as Price, ExternalInvoiceNumber, SalesRep, CoLName, CoFName, CoMName, CoSSN, p.ImportBatchID, 0
		from ProductTransactions p
		inner join eDrugImport e on e.COCNumber = p.FileNum and e.ImportBatchID = p.ImportBatchID
		where (e.Comments like '%Tier 3%' or e.Comments like '%Tier 4%' or e.Comments like '%Tier 5%') and e.Comments not like '%instant%'
		
		--Fix the Reference fields on the VXI Transactions
		/* VXI no longer a company as of 5/1
		Update ProductTransactions
		set Reference = a.Reference
		from
		(
		select ProductTransactions.Producttransactionid, FileNum, 'Youngstown' as ClientCompany, c.LName, c.FName, SSN, c.OrderBy, ProductTransactions.DateOrdered, 'Youngstown ' + PositionTitle + ' - ' + Division as Reference, 
		case producttransactions.ProductID when 367 then 25 else ProductPrice end as Price
		from ProductTransactions,
		(
		Select distinct pt.FName, pt.OrderBy, pc.PositionTitle, pc.Division, /*fd.formdata,*/'202506Youngstown' as LocationCode, cv.clientid, pt.ClientID as OldCLientID, pt.ProductTransactionID, pt.LName, pt.productid
		from [504050-DB1].[ApplicantONE].[dbo].VendeDrugOrder vo
		inner join [504050-DB1].[ApplicantONE].[dbo].Applications a on a.ApplicationID = vo.applicationid
		inner join eDrugImport ed on ed.SpecimenID = Left(vo.ReferenceID, Case Len(vo.ReferenceID) when 0 then 0 else (Len(vo.ReferenceID) - 9) end)
		inner join ProductTransactions pt on pt.FileNum = ed.COCNumber and ProductID in (367,368) and pt.ImportBatchID = ed.ImportBatchID
		inner join [504050-DB1].[ApplicantONE].[dbo].Positions p on p.PositionID	= a.PositionID
		inner join [504050-DB1].[ApplicantONE].[dbo].PositionsCache pc on pc.positionid = p.positionid
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormData fd on fd.FormInstanceID = p.PositionForm
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormInstance FI ON FI.FormInstanceID = FD.FOrmIntanceID
		--INNER JOIN [504050-DB1].[ApplicantONE].[dbo].FormFields FF ON FF.FormID = FI.FormID AND FD.ClientFieldID = FF.ClientFieldID
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormFields ff on ff.FormFieldID = fd.FormFieldID and ff.FieldName = 'Division'
		LEFT join ClientVendors cv on cv.VendorID = 8 and cv.VendorClientNumber = '202506Youngstown'
		where ed.CustomerNumber = '202506'
		and ED.LocationCode = 'Youngstown'
		) c 
		where ProductTransactions.ProductTransactionID  = c.ProductTransactionID

		UNION ALL
		
		select ProductTransactions.Producttransactionid, FileNum, 'Canton' as ClientCompany, c.LName, c.FName, SSN, c.OrderBy, ProductTransactions.DateOrdered, 'Canton ' + PositionTitle + ' - ' + Division as Reference, 
		case producttransactions.ProductID when 367 then 25 else ProductPrice end as Price
		from ProductTransactions,
		(
		Select distinct pt.FName, pt.OrderBy, pc.PositionTitle, pc.Division, /*fd.formdata,*/ '202506Canton' as LocationCode, cv.clientid, pt.ClientID as OldCLientID, pt.ProductTransactionID, pt.LName, pt.productid
		from [504050-DB1].[ApplicantONE].[dbo].VendeDrugOrder vo
		inner join [504050-DB1].[ApplicantONE].[dbo].Applications a on a.ApplicationID = vo.applicationid
		inner join eDrugImport ed on ed.SpecimenID = Left(vo.ReferenceID, Case Len(vo.ReferenceID) when 0 then 0 else (Len(vo.ReferenceID) - 9) end)
		inner join ProductTransactions pt on pt.FileNum = ed.COCNumber and ProductID in (367,368) and pt.ImportBatchID = ed.ImportBatchID
		inner join [504050-DB1].[ApplicantONE].[dbo].Positions p on p.PositionID	= a.PositionID
		inner join [504050-DB1].[ApplicantONE].[dbo].PositionsCache pc on pc.positionid = p.positionid
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormData fd on fd.FormInstanceID = p.PositionForm
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormFields ff on ff.FormFieldID = fd.FormFieldID and ff.FieldName = 'Division'
		LEFT join ClientVendors cv on cv.VendorID = 8 and cv.VendorClientNumber = '202506Canton'
		where ed.CustomerNumber = '202506'
		and ED.LocationCode = 'Canton'
		) c 
		where ProductTransactions.ProductTransactionID  = c.ProductTransactionID
		
		UNION ALL
		
		select ProductTransactions.Producttransactionid, FileNum, 'Cincinnati' as ClientCompany, c.LName, c.FName, SSN, c.OrderBy, ProductTransactions.DateOrdered, 'Cincinnati ' + PositionTitle + ' - ' + Division as Reference, 
		case producttransactions.ProductID when 367 then 25 else ProductPrice end as Price
		from ProductTransactions,
		(
		Select distinct pt.FName, pt.OrderBy, pc.PositionTitle, pc.Division, /*fd.formdata,*/ '202506Cincinnati' as LocationCode, cv.clientid, pt.ClientID as OldCLientID, pt.ProductTransactionID, pt.LName, pt.productid
		from [504050-DB1].[ApplicantONE].[dbo].VendeDrugOrder vo
		inner join [504050-DB1].[ApplicantONE].[dbo].Applications a on a.ApplicationID = vo.applicationid
		inner join eDrugImport ed on ed.SpecimenID = Left(vo.ReferenceID, Case Len(vo.ReferenceID) when 0 then 0 else (Len(vo.ReferenceID) - 9) end)
		inner join ProductTransactions pt on pt.FileNum = ed.COCNumber and ProductID in (367,368) and pt.ImportBatchID = ed.ImportBatchID
		inner join [504050-DB1].[ApplicantONE].[dbo].Positions p on p.PositionID	= a.PositionID
		inner join [504050-DB1].[ApplicantONE].[dbo].PositionsCache pc on pc.positionid = p.positionid
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormData fd on fd.FormInstanceID = p.PositionForm
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormFields ff on ff.FormFieldID = fd.FormFieldID and ff.FieldName = 'Division'
		LEFT join ClientVendors cv on cv.VendorID = 8 and cv.VendorClientNumber = '202506Cincinnati'
		where ed.CustomerNumber = '202506'
		and ED.LocationCode = 'Cincinnati'
		) c 
		where ProductTransactions.ProductTransactionID  = c.ProductTransactionID
		
		UNION ALL

		select ProductTransactions.Producttransactionid, FileNum, 'VXI-CA' as ClientCompany, c.LName, c.FName, SSN, c.OrderBy, ProductTransactions.DateOrdered, 'VXI-CA ' + PositionTitle + ' - ' + Division as Reference, 
		case producttransactions.ProductID when 367 then 25 else ProductPrice end as Price
		from ProductTransactions,
		(
		Select distinct pt.FName, pt.OrderBy, pc.PositionTitle, pc.Division, /*fd.formdata,*/ '202506VXI-CA' as LocationCode, cv.clientid, pt.ClientID as OldCLientID, pt.ProductTransactionID, pt.LName, pt.productid
		from [504050-DB1].[ApplicantONE].[dbo].VendeDrugOrder vo
		inner join [504050-DB1].[ApplicantONE].[dbo].Applications a on a.ApplicationID = vo.applicationid
		inner join eDrugImport ed on ed.SpecimenID = Left(vo.ReferenceID, Case Len(vo.ReferenceID) when 0 then 0 else (Len(vo.ReferenceID) - 9) end)
		inner join ProductTransactions pt on pt.FileNum = ed.COCNumber and ProductID in (367,368) and pt.ImportBatchID = ed.ImportBatchID
		inner join [504050-DB1].[ApplicantONE].[dbo].Positions p on p.PositionID	= a.PositionID
		inner join [504050-DB1].[ApplicantONE].[dbo].PositionsCache pc on pc.positionid = p.positionid
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormData fd on fd.FormInstanceID = p.PositionForm
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormFields ff on ff.FormFieldID = fd.FormFieldID and ff.FieldName = 'Division'
		LEFT join ClientVendors cv on cv.VendorID = 8 and cv.VendorClientNumber = '202506VXI-CA'
		where ed.CustomerNumber = '202506'
		and ED.LocationCode = 'VXI-CA'
		) c 
		where ProductTransactions.ProductTransactionID  = c.ProductTransactionID


		UNION ALL

		select ProductTransactions.Producttransactionid, FileNum, 'VXI-TX' as ClientCompany, c.LName, c.FName, SSN, c.OrderBy, ProductTransactions.DateOrdered, 'VXI-TX ' + PositionTitle + ' - ' + Division as Reference, 
		case producttransactions.ProductID when 367 then 25 else ProductPrice end as Price
		from ProductTransactions,
		(
		Select distinct pt.FName, pt.OrderBy, pc.PositionTitle, pc.Division, /*fd.formdata,*/ '202506VXI-TX' as LocationCode, cv.clientid, pt.ClientID as OldCLientID, pt.ProductTransactionID, pt.LName, pt.productid
		from [504050-DB1].[ApplicantONE].[dbo].VendeDrugOrder vo
		inner join [504050-DB1].[ApplicantONE].[dbo].Applications a on a.ApplicationID = vo.applicationid
		inner join eDrugImport ed on ed.SpecimenID = Left(vo.ReferenceID, Case Len(vo.ReferenceID) when 0 then 0 else (Len(vo.ReferenceID) - 9) end)
		inner join ProductTransactions pt on pt.FileNum = ed.COCNumber and ProductID in (367,368) and pt.ImportBatchID = ed.ImportBatchID
		inner join [504050-DB1].[ApplicantONE].[dbo].Positions p on p.PositionID	= a.PositionID
		inner join [504050-DB1].[ApplicantONE].[dbo].PositionsCache pc on pc.positionid = p.positionid
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormData fd on fd.FormInstanceID = p.PositionForm
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormFields ff on ff.FormFieldID = fd.FormFieldID and ff.FieldName = 'Division'
		LEFT join ClientVendors cv on cv.VendorID = 8 and cv.VendorClientNumber = '202506VXI-TX'
		where ed.CustomerNumber = '202506'
		and ED.LocationCode = 'VXI-TX'
		) c 
		where ProductTransactions.ProductTransactionID  = c.ProductTransactionID
		) a
		where a.ProductTransactionID = ProductTransactions.ProductTransactionID
		--End VXI Update
		*/
				
		--Update Sheehy ClientIDs on Product Transactions
		update ProductTransactions
		set ClientID = c.ClientID
		from 
		(
		Select distinct pc.Division, '202505' + sl.[LocationCode] as LocationCode, cv.clientid, pt.ClientID as OldCLientID, pt.ProductTransactionID, pt.LName
		from [504050-DB1].[ApplicantONE].[dbo].VendeDrugOrder vo
		inner join [504050-DB1].[ApplicantONE].[dbo].Applications a on a.ApplicationID = vo.applicationid
		inner join eDrugImport ed on ed.SpecimenID = Left(vo.ReferenceID, Case Len(vo.ReferenceID) when 0 then 0 else (Len(vo.ReferenceID) - 9) end)
		inner join ProductTransactions pt on pt.FileNum = ed.COCNumber and ProductID in (367,368)
		inner join [504050-DB1].[ApplicantONE].[dbo].Positions p on p.PositionID	= a.PositionID
		inner join [504050-DB1].[ApplicantONE].[dbo].PositionsCache pc on pc.positionid = p.positionid
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormData fd on fd.FormInstanceID = p.PositionForm
		--inner join [504050-DB1].[ApplicantONE].[dbo].FormFields ff on ff.FormFieldID = fd.FormFieldID and ff.FieldName = 'Division'
		INNER JOIN [504050-DB1].[ApplicantONE].[dbo].SheehyLocations sl on sl.Division = pc.Division
		LEFT join ClientVendors cv on cv.VendorID = 8 and cv.VendorClientNumber = '202505' + sl.[LocationCode]
		where ed.CustomerNumber = '202505'
		and ED.LocationCode = 'Corpor'
		) c 
		where ProductTransactions.ProductTransactionID  = c.ProductTransactionID
		-- End Sheehy Update
		 
		Return @errorcode
	End
	
	

	
Cleanup:

    BEGIN
    	ROLLBACK TRANSACTION
    	Update ImportBatch set ImportSuccess = 0 where ImportBatchID = (select distinct ImportBatchID from eDrugImport)
    END

    RETURN @errorcode
	END
End







GO
