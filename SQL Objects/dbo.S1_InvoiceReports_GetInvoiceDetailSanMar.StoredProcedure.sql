/****** Object:  StoredProcedure [dbo].[S1_InvoiceReports_GetInvoiceDetailSanMar]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_InvoiceReports_GetInvoiceDetailSanMar 110200049

CREATE PROCEDURE [dbo].[S1_InvoiceReports_GetInvoiceDetailSanMar]
(
	@InvoiceNumber varchar(50)
	
)
AS
	SET NOCOUNT ON;
	
	DECLARE @tmp_Report TABLE (
		Detail int,
		GroupOrder varchar(50),
		RecordCount int,
		FileNum varchar(50),
		ClientName varchar(100),
		Address1 varchar(50),
		Address2 varchar(50),
		Address3 varchar(50),
		ContactPhone varchar(20),
		ContactFax varchar(20),
		ProductType varchar(50),
		DateOrdered varchar(10),
		Name varchar(255),
		SSN varchar(50),
		OrderBy varchar(100),
		Reference varchar(100),
		ProductPrice money,
		ProductDescription varchar(max),
		StateAccessFee money,
		CourtAccessFee money,
		InvoiceDate datetime,
		InvoiceNumber varchar(50),
		LName varchar(255),
		FName varchar(255),
		PrimaryClientName varchar(100)
	)

BEGIN
	INSERT INTO @tmp_Report
	SELECT 1 as Detail, 
	'REFERENCE' as GroupOrder, 
	Convert(int, (select count(distinct FileNum)FROM ProductsOnInvoice WHERE FileNum = PT.FileNum)) as RecordCount,
	PT.FileNum, 
	C.ClientName, 
	B.ContactAddress1, 
	B.ContactAddress2, 
	B.ContactCity + ', ' + B.ContactStateCode + ' ' + B.ContactZIP As Address3, 
	B.ContactPhone, 
	B.ContactFax, 
	PT.ProductType, 
	Convert(varchar, PT.DateOrdered, 101) as DateOrdered, 
	PT.LName + ', ' + PT.FName as Name, 
	PT.SSN, 
	PT.OrderBy, 
	PT.Reference, 
	PT.ProductPrice, 
	case when pt.productid in (167, 168) then 'Drug Test' else 'Background Screening' end as ProductDescription,
	Case When PT.ProductDescription like '%- State%Fee%' Then PT.ProductPrice else 0.00 end as StateAccessFee, 
	Case When PT.ProductDescription like '%- Court%Fee%' Then PT.ProductPrice else 0.00 end as CourtAccessFee,
	I.InvoiceDate As InvoiceDate, 
	I.InvoiceNumber, 
	PT.LName, 
	PT.FName, 
	C.ClientName as PrimaryClientName
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceNumber = @InvoiceNumber AND PT.VendorID NOT IN (4,5)
	ORDER BY Reference, PT.LName + ', ' + PT.FName, Detail
	
	SELECT ROW_NUMBER() OVER (ORDER BY Reference, max(name), Detail) as LineNumber, 
	Detail, GroupOrder, RecordCount, FileNum, ClientName, Address1, Address2, Address3, ContactPhone, ContactFax,
	max(DateOrdered) as DateOrdered,  Min(Name) as Name, SSN, OrderBy, Reference,SUM(ProductPrice) as ProductPrice, ProductDescription, SUM(StateAccessFee) as StateAccessFee,
	SUM(CourtAccessFee) as CourtAccessFee, InvoiceDate, InvoiceNumber, Max(LName) as LName, MAX(FName) as FName, PrimaryClientName
	FROM @tmp_Report 
	GROUP BY Detail, GroupOrder, RecordCount, FileNum, ClientName, Address1, Address2, Address3, ContactPhone, ContactFax,
	SSN, OrderBy, Reference, ProductDescription, InvoiceDate, InvoiceNumber, PrimaryClientName
END






GO
