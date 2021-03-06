/****** Object:  StoredProcedure [dbo].[S1_InvoiceReports_GetInvoiceDetail]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_InvoiceReports_GetInvoiceDetail]
@InvoiceID int,
@GroupOrderID int
AS
BEGIN
--EXEC S1_InvoiceReports_GetInvoiceDetail 176243,4


	SET NOCOUNT ON;
	
	DECLARE @clientid int
	
	DECLARE @tmp_Report TABLE (
		Detail int,
		GroupOrder varchar(50),
		RecordCount int,
		FileNum varchar(50),
		ClientName varchar(100),
		Address1 varchar(50),
		Address2 varchar(50),
		Address3 varchar(50),
		ContactPhone varchar(50),
		ContactFax varchar(50),
		ProductType varchar(50),
		DateOrdered datetime,
		Name varchar(255),
		SSN varchar(50),
		OrderBy varchar(100),
		Reference varchar(100),
		ProductPrice money,
		ProductDescription varchar(max),
		InvoiceDate datetime,
		InvoiceNumber varchar(50),
		LName varchar(255),
		FName varchar(255),
		PrimaryClientName varchar(100)
	)

select @clientid = clientid from Invoices where InvoiceID = @InvoiceID


if (@GroupOrderID = 1) -- by Reference
BEGIN

	if (@clientid = 2600) -- Johnny Rockets, Compassion special report
	BEGIN
		INSERT INTO @tmp_Report
		SELECT 1 as Detail, 
		'REFERENCE' as GroupOrder, 
		Convert(int, (select count(FileNum)FROM ProductsOnInvoice WHERE FileNum = PT.FileNum)) as RecordCount,
		PT.FileNum, 
		C.ClientName, 
		B.ContactAddress1, 
		B.ContactAddress2, 
		B.ContactCity + ', ' + B.ContactStateCode + ' ' + B.ContactZIP As Address3, 
		B.ContactPhone, 
		B.ContactFax, 
		PT.ProductType, 
		PT.DateOrdered, 
		CASE When PT.ProductID = 372 then 'Finance Charge' When PT.ProductID <> 372 and PT.FileNum = '' then ' ' else (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID and ProductID = PT.ProductID) + ', ' + PT.FName end as Name,  
		CASE WHEN CIS.HideSSN=1 THEN '' ELSE PT.SSN END, 
		PT.OrderBy + ' ' + PT.Reference as OrderBy, 
		left(PT.Reference, 3) as Reference, 
		PT.ProductPrice, 
		PT.ProductDescription, 
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
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		UNION ALL
		SELECT 0 as Detail, 
		'REFERENCE' as GroupOrder, 
		1 as RecordCount, 
		'', 
		'' as ClientName, 
		'' as Address1, 
		'' as Address2, 
		'', 
		'',
		'', 
		'', 
		'', 
		'', 
		'', 
		'', 
		left(PT.Reference, 3) as Reference, 
		'', 
		'', 
		'', 
		'', 
		'', 
		'',
		''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY left(PT.Reference, 3)
		UNION ALL
		SELECT 2 as Detail, 'REFERENCE' as GroupOrder, 1 as RecordCount, PT.FileNum, '' as ClientName, '' as Address1, 
		'' as Address2, '', '', '', '', '', (select max(LName) from ProductTransactions where filenum = PT.FileNum) + ', ' + (select max(FName) from ProductTransactions where filenum = PT.FileNum)  as Name, '', '', 
		left(PT.Reference, 3) as Reference, SUM(PT.ProductPrice), '', '', '', '', '',''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY left(PT.Reference, 3), PT.FileNum
		Having COUNT(PT.FileNum) > 1
		UNION ALL
		SELECT 3 as Detail, 'REFERENCE' as GroupOrder, 1 as RecordCount, MAX(PT.FileNum) as FileNum, '' as ClientName, 
		'' as Address1, '' as Address2, '', '', '', '', '', 'zzzzzzzzzz' as Name, '', '', 
		left(PT.Reference, 3) as Reference, SUM(PT.ProductPrice), '', '', '', '', '',''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY left(PT.Reference, 3)
		UNION ALL
		SELECT 4 as Detail, 'REFERENCE' as GroupOrder,
		1, '9999999', '', '', '', '', '', '', '', '', '', '', '', 'zzzzzzzzzz' as Reference, 
		(select sum(productprice)
		FROM ProductsOnInvoice PT
		WHERE PT.InvoiceID = @invoiceid) as ProductPrice , '', '', '', '', '',''
		ORDER BY Reference, PT.FileNum, Detail
		
		;with minNameForAliases as (
	       select tr.FileNum,
	              min(tr.Name) as MinName
	         from @tmp_Report tr
		     where coalesce(tr.FileNum,'') <> ''
		     group by tr.FileNum)
		SELECT ROW_NUMBER() OVER (ORDER BY tr.Reference, (CASE WHEN tr.Detail=3 THEN 'ZZZZZZZZZZZZ' ELSE mnfa.MinName END), tr.FileNum, tr.Detail, tr.FName, tr.LName) as LineNumber,
		       tr.* 
		  FROM @tmp_Report tr
		       left join minNameForAliases mnfa on mnfa.FileNum = tr.FileNum
          order by LineNumber
	END
	ELSE
	--BEGIN
	IF (@clientid = 1803) --Acrisure special sort
	BEGIN
		INSERT INTO @tmp_Report
		SELECT 1 as Detail, 
		'REFERENCE' as GroupOrder, 
		Convert(int, (select count(FileNum)FROM ProductsOnInvoice WHERE FileNum = PT.FileNum)) as RecordCount,
		PT.FileNum, 
		C.ClientName, 
		B.ContactAddress1, 
		B.ContactAddress2, 
		B.ContactCity + ', ' + B.ContactStateCode + ' ' + B.ContactZIP As Address3, 
		B.ContactPhone, 
		B.ContactFax, 
		PT.ProductType, 
		PT.DateOrdered, 
		CASE When PT.ProductID = 372 then 'Finance Charge' When PT.ProductID <> 372 and PT.FileNum = '' then ' ' else (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID and ProductID = PT.ProductID) + ', ' + PT.FName end as Name,  
		CASE WHEN CIS.HideSSN=1 THEN '' ELSE PT.SSN END, 
		PT.OrderBy, 
		PT.Reference, 
		PT.ProductPrice, 
		PT.ProductDescription, 
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
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		UNION ALL
		SELECT 0 as Detail, 
		'REFERENCE' as GroupOrder, 
		1 as RecordCount, 
		'', 
		'' as ClientName, 
		'' as Address1, 
		'' as Address2, 
		'', 
		'',
		'', 
		'', 
		'', 
		'', 
		'', 
		'', 
		PT.Reference as Reference, 
		'', 
		'', 
		'', 
		'', 
		'', 
		'',
		''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY PT.Reference
		UNION ALL
		SELECT 2 as Detail, 'REFERENCE' as GroupOrder, 1 as RecordCount, PT.FileNum, '' as ClientName, '' as Address1, 
		'' as Address2, '', '', '', '', '', (select max(LName) from ProductTransactions where filenum = PT.FileNum) + ', ' + (select max(FName) from ProductTransactions where filenum = PT.FileNum)  as Name, '', '', 
		PT.Reference as Reference, SUM(PT.ProductPrice), '', '', '', '', '',''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY PT.Reference, PT.FileNum
		Having COUNT(PT.FileNum) > 1
		UNION ALL
		SELECT 3 as Detail, 'REFERENCE' as GroupOrder, 1 as RecordCount, MAX(PT.FileNum) as FileNum, '' as ClientName, 
		'' as Address1, '' as Address2, '', '', '', '', '', MAX(PT.LName) + ', ' + MAX(PT.FName)  as Name, '', '', 
		PT.Reference as Reference, SUM(PT.ProductPrice), '', '', '', '', '',''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY PT.Reference
		UNION ALL
		SELECT 4 as Detail, 'REFERENCE' as GroupOrder,
		1, '9999999', '', '', '', '', '', '', '', '', '', '', '', 'zzzzzzzzzz' as Reference, 
		(select sum(productprice)
		FROM ProductsOnInvoice PT
		WHERE PT.InvoiceID = @invoiceid) as ProductPrice , '', '', '', '', '',''
		ORDER BY Reference, PT.FileNum, Detail
		
		SELECT ROW_NUMBER() OVER (ORDER BY tr.Reference, tr.FileNum, tr.Detail) as LineNumber,
		       tr.* 
		  FROM @tmp_Report tr
		  order by LineNumber
	END
	ELSE
	if (@clientid = 3172 or @clientid = 2720) -- Compassion special report
	BEGIN
		INSERT INTO @tmp_Report
		SELECT 1 as Detail, 
		'REFERENCE' as GroupOrder, 
		Convert(int, (select count(FileNum)FROM ProductsOnInvoice WHERE FileNum = PT.FileNum)) as RecordCount,
		PT.FileNum, 
		C.ClientName, 
		B.ContactAddress1, 
		B.ContactAddress2, 
		B.ContactCity + ', ' + B.ContactStateCode + ' ' + B.ContactZIP As Address3, 
		B.ContactPhone, 
		B.ContactFax, 
		PT.ProductType, 
		PT.DateOrdered, 
		CASE When PT.ProductID = 372 then 'Finance Charge' When PT.ProductID <> 372 and PT.FileNum = '' then ' ' else (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID and ProductID = PT.ProductID) + ', ' + PT.FName end as Name,  
		CASE WHEN CIS.HideSSN=1 THEN '' ELSE PT.SSN END, 
		PT.OrderBy + ' ' + PT.Reference as OrderBy, 
		PT.Reference as Reference, 
		PT.ProductPrice, 
		PT.ProductDescription, 
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
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		UNION ALL
		SELECT 0 as Detail, 
		'REFERENCE' as GroupOrder, 
		1 as RecordCount, 
		'', 
		'' as ClientName, 
		'' as Address1, 
		'' as Address2, 
		'', 
		'',
		'', 
		'', 
		'', 
		'', 
		'', 
		'', 
		PT.Reference as Reference, 
		'', 
		'', 
		'', 
		'', 
		'', 
		'',
		''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY PT.Reference
		UNION ALL
		SELECT 2 as Detail, 'REFERENCE' as GroupOrder, 1 as RecordCount, PT.FileNum, '' as ClientName, '' as Address1, 
		'' as Address2, '', '', '', '', '', (select max(LName) from ProductTransactions where filenum = PT.FileNum) + ', ' + (select max(FName) from ProductTransactions where filenum = PT.FileNum)  as Name, '', '', 
		PT.Reference as Reference, SUM(PT.ProductPrice), '', '', '', '', '',''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY PT.Reference, PT.FileNum
		Having COUNT(PT.FileNum) > 1
		UNION ALL
		SELECT 3 as Detail, 'REFERENCE' as GroupOrder, 1 as RecordCount, MAX(PT.FileNum) as FileNum, '' as ClientName, 
		'' as Address1, '' as Address2, '', '', '', '', '', MAX(PT.LName) + ', ' + MAX(PT.FName)  as Name, '', '', 
		PT.Reference as Reference, SUM(PT.ProductPrice), '', '', '', '', '',''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY PT.Reference
		UNION ALL
		SELECT 4 as Detail, 'REFERENCE' as GroupOrder,
		1, '9999999', '', '', '', '', '', '', '', '', '', '', '', 'zzzzzzzzzz' as Reference, 
		(select sum(productprice)
		FROM ProductsOnInvoice PT
		WHERE PT.InvoiceID = @invoiceid) as ProductPrice , '', '', '', '', '',''
		ORDER BY Reference, PT.FileNum, Detail
		
		;with minNameForAliases as (
	       select tr.FileNum,
	              min(tr.Name) as MinName
	         from @tmp_Report tr
		     where coalesce(tr.FileNum,'') <> ''
		     group by tr.FileNum)
		SELECT ROW_NUMBER() OVER (ORDER BY tr.Reference, (CASE WHEN tr.Detail=3 THEN 'ZZZZZZZZZZZZ' ELSE mnfa.MinName END), tr.FileNum, tr.Detail, tr.FName, tr.LName) as LineNumber,
		       tr.* 
		  FROM @tmp_Report tr
		       left join minNameForAliases mnfa on mnfa.FileNum = tr.FileNum
		  order by LineNumber
	END
	ELSE
	BEGIN
		INSERT INTO @tmp_Report
		SELECT 1 as Detail, 
		'REFERENCE' as GroupOrder, 
		Convert(int, (select count(FileNum)FROM ProductsOnInvoice WHERE FileNum = PT.FileNum)) as RecordCount,
		PT.FileNum, 
		C.ClientName, 
		B.ContactAddress1, 
		B.ContactAddress2, 
		B.ContactCity + ', ' + B.ContactStateCode + ' ' + B.ContactZIP As Address3, 
		B.ContactPhone, 
		B.ContactFax, 
		PT.ProductType, 
		PT.DateOrdered, 
		CASE When PT.ProductID = 372 then 'Finance Charge' When PT.ProductID <> 372 and PT.FileNum = '' then ' ' else (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID and ProductID = PT.ProductID) + ', ' + PT.FName end as Name,  
		CASE WHEN CIS.HideSSN=1 THEN '' ELSE PT.SSN END, 
		PT.OrderBy, 
		PT.Reference, 
		PT.ProductPrice, 
		PT.ProductDescription, 
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
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		UNION ALL
		SELECT 0 as Detail, 
		'REFERENCE' as GroupOrder, 
		1 as RecordCount, 
		'', 
		'' as ClientName, 
		'' as Address1, 
		'' as Address2, 
		'', 
		'',
		'', 
		'', 
		'', 
		'', 
		'', 
		'', 
		PT.Reference as Reference, 
		'', 
		'', 
		'', 
		'', 
		'', 
		'',
		''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY PT.Reference
		UNION ALL
		SELECT 2 as Detail, 'REFERENCE' as GroupOrder, 1 as RecordCount, PT.FileNum, '' as ClientName, '' as Address1, 
		'' as Address2, '', '', '', '', '', (select max(LName) from ProductTransactions where filenum = PT.FileNum) + ', ' + (select max(FName) from ProductTransactions where filenum = PT.FileNum)  as Name, '', '', 
		PT.Reference as Reference, SUM(PT.ProductPrice), '', '', '', '', '',''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY PT.Reference, PT.FileNum
		Having COUNT(PT.FileNum) > 1
		UNION ALL
		SELECT 3 as Detail, 'REFERENCE' as GroupOrder, 1 as RecordCount, MAX(PT.FileNum) as FileNum, '' as ClientName, 
		'' as Address1, '' as Address2, '', '', '', '', '', 'zzzzzzzzzz'  as Name, '', '', 
		PT.Reference as Reference, SUM(PT.ProductPrice), '', '', '', '', '',''
		FROM ProductsOnInvoice PT
		INNER JOIN Products P
		ON PT.ProductID=P.ProductID
		INNER JOIN Invoices I
		ON I.InvoiceID=PT.InvoiceID
		INNER JOIN Clients C
		ON C.ClientID = I.ClientID
		LEFT JOIN ClientInvoiceSettings CIS
		ON CIS.ClientID=C.ClientID
		INNER JOIN InvoiceBillingContacts IB
		ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
		INNER JOIN BillingContacts B
		ON B.BillingContactID = IB.BillingContactID 
		WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
		GROUP BY PT.Reference
		UNION ALL
		SELECT 4 as Detail, 'REFERENCE' as GroupOrder,
		1, '9999999', '', '', '', '', '', '', '', '', '', '', '', 'zzzzzzzzzz' as Reference, 
		(select sum(productprice)
		FROM ProductsOnInvoice PT
		WHERE PT.InvoiceID = @invoiceid) as ProductPrice , '', '', '', '', '',''
		ORDER BY Reference, PT.FileNum, Detail
		
		;with minNameForAliases as (
	       select tr.FileNum,
	              min(tr.Name) as MinName
	         from @tmp_Report tr
		     where coalesce(tr.FileNum,'') <> ''
		     group by tr.FileNum)
		SELECT ROW_NUMBER() OVER (ORDER BY tr.Reference, (CASE WHEN tr.Detail=3 THEN 'ZZZZZZZZZZZZ' ELSE mnfa.MinName END), tr.FileNum, tr.Detail, tr.FName, tr.LName) as LineNumber,
		       tr.* 
		  FROM @tmp_Report tr
		       left join minNameForAliases mnfa on mnfa.FileNum = tr.FileNum
		  order by LineNumber
	END
END

if (@GroupOrderID = 2) --by Filenum
BEGIN
	INSERT INTO @tmp_Report
	SELECT 1 as Detail, 'FILE #' as GroupOrder, Convert(int, (select count(FileNum)FROM ProductsOnInvoice WHERE FileNum = PT.FileNum)) as RecordCount,
	PT.FileNum, C.ClientName, B.ContactAddress1, B.ContactAddress2, B.ContactCity + ', ' + B.ContactStateCode + ' ' + B.ContactZIP As Address3, 
	B.ContactPhone, B.ContactFax, PT.ProductType, PT.DateOrdered, 
	CASE When PT.ProductID = 372 then 'Finance Charge' When PT.ProductID <> 372 and PT.FileNum = '' then ' ' else (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID and ProductID = PT.ProductID) + ', ' + PT.FName end as Name,  
	CASE WHEN CIS.HideSSN=1 THEN '' ELSE PT.SSN END, 
	PT.OrderBy, PT.Reference, PT.ProductPrice, PT.ProductDescription, I.InvoiceDate As InvoiceDate, 
	I.InvoiceNumber, PT.LName, PT.FName, C.ClientName as PrimaryClientName
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
	UNION ALL
	SELECT 0 as Detail, 'FILE #' as GroupOrder, 1 as RecordCount, PT.FileNum, '' as ClientName, '' as Address1, 
	'' as Address2, '', '', '', '', '', MAX(PT.LName) + ', ' + MAX(PT.FName)  as Name, '', '', '','', '', '', '', '', '',''
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
	GROUP BY PT.FileNum
	UNION ALL
	SELECT 3 as Detail, 'FILE #' as GroupOrder, 1 as RecordCount, MAX(PT.FileNum) as FileNum, '' as ClientName, 
	'' as Address1, '' as Address2, '', '', '', '', '', MAX(PT.LName) + ', ' + MAX(PT.FName)  as Name, '', '', '', 
	SUM(PT.ProductPrice), '', '', '', '', '',''
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
	GROUP BY PT.FileNum
	UNION ALL
	SELECT 4 as Detail, 'FILE #' as GroupOrder,
	1, '9999999999' as FileNum, '', '', '', '', '', '', '', '', '', '', '', '', 
	(select sum(productprice)
    FROM ProductsOnInvoice PT
	WHERE PT.InvoiceID = @invoiceid) as ProductPrice , '', '', '', '', '',''
	ORDER BY PT.FileNum, Detail
	
	SELECT ROW_NUMBER() OVER (ORDER BY tr.FileNum, tr.Name, tr.Detail) as LineNumber,
	       tr.* 
	  FROM @tmp_Report tr
	  order by LineNumber
END

if (@GroupOrderID = 3) --by OrderBy
BEGIN
	INSERT INTO @tmp_Report
	SELECT 1 as Detail, 'ORDERED BY' as GroupOrder, Convert(int, (select count(FileNum)FROM ProductsOnInvoice WHERE FileNum = PT.FileNum and VendorID = PT.VendorID)) as RecordCount,
	PT.FileNum, C.ClientName, B.ContactAddress1, B.ContactAddress2, B.ContactCity + ', ' + B.ContactStateCode + ' ' + B.ContactZIP As Address3, 
	B.ContactPhone, B.ContactFax, PT.ProductType, PT.DateOrdered, 
	CASE When PT.ProductID = 372 then 'Finance Charge' When PT.ProductID <> 372 and PT.FileNum = '' then ' ' else (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID and ProductID = PT.ProductID) + ', ' + PT.FName end as Name,  
	CASE WHEN CIS.HideSSN=1 THEN '' ELSE PT.SSN END,  
	PT.OrderBy as OrderBy, PT.Reference, PT.ProductPrice, PT.ProductDescription, I.InvoiceDate As InvoiceDate, 
	I.InvoiceNumber, PT.LName, PT.FName, C.ClientName as PrimaryClientName
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
	UNION ALL
	SELECT 0 as Detail, 'ORDERED BY' as GroupOrder, 1 as RecordCount, '', '' as ClientName, '' as Address1, 
	'' as Address2, '', '', '', '', '', '', '', PT.OrderBy as OrderBy, '', '', '', '', '', '', '',''
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
	GROUP BY PT.OrderBy
	UNION ALL
	SELECT 2 as Detail, 'ORDERED BY' as GroupOrder, 1 as RecordCount, PT.FileNum, '' as ClientName, '' as Address1, 
	'' as Address2, '', '', '', '', '', (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID) + ', ' + (select max(FName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID)  as Name, '', PT.OrderBy as OrderBy, '', SUM(PT.ProductPrice), '', '', '', '', '',''
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
	GROUP BY PT.OrderBy, PT.FileNum, PT.VendorID
	Having COUNT(PT.FileNum) > 1
	UNION ALL
	SELECT 3 as Detail, 'ORDERED BY' as GroupOrder, 1 as RecordCount, '9999998' as FileNum, '' as ClientName, 
	'' as Address1, '' as Address2, '', '', '', '', '', 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZ' as Name, '', 
	PT.OrderBy as OrderBy, '', SUM(PT.ProductPrice), '', '', '', '', '',''
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND PT.VendorID NOT IN (4,5)
	GROUP BY PT.OrderBy
	UNION ALL
	SELECT 4 as Detail, 'ORDERED BY' as GroupOrder,
	1, '9999999' as FileNum, '', '', '', '', '', '', '', '', '', '', 'zzzzzzzzzz' as OrderBy, '', 
	(select sum(productprice)
    FROM ProductsOnInvoice PT
	WHERE PT.InvoiceID = @invoiceid) as ProductPrice , '', '', '', '', '',''
	ORDER BY PT.OrderBy, PT.FileNum, Detail
	
	;with minNameForAliases as (
	   select tr.FileNum,
	          min(tr.Name) as MinName
	     from @tmp_Report tr
		 where coalesce(tr.FileNum,'') <> ''
		 group by tr.FileNum
	)
	SELECT ROW_NUMBER() OVER (ORDER BY tr.OrderBy, (CASE WHEN tr.Detail=3 THEN 'ZZZZZZZZZZZZ' ELSE mnfa.MinName END), tr.FileNum, tr.Detail, tr.FName, tr.LName) as LineNumber,
	       tr.* 
	  FROM @tmp_Report tr
	  left join minNameForAliases mnfa on mnfa.FileNum = tr.FileNum
	  order by LineNumber
END

if (@GroupOrderID = 4) --by Company
BEGIN
	INSERT INTO @tmp_Report
	SELECT 1 as Detail, 'COMPANY' as GroupOrder, Convert(int, (select count(FileNum)FROM ProductsOnInvoice WHERE FileNum = PT.FileNum and VendorID = PT.VendorID)) as RecordCount,
	PT.FileNum, C2.ClientName as ClientName, B.ContactAddress1, B.ContactAddress2, B.ContactCity + ', ' + B.ContactStateCode + ' ' + B.ContactZIP As Address3,
	B.ContactPhone, B.ContactFax, PT.ProductType, PT.DateOrdered, 
	CASE When PT.ProductID = 372 then 'Finance Charge' When PT.ProductID <> 372 and PT.FileNum = '' then ' ' else (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID and ProductID = PT.ProductID) + ', ' + PT.FName end as Name, 
	CASE WHEN CIS.HideSSN=1 THEN '' ELSE PT.SSN END,  
	PT.OrderBy as OrderBy, PT.Reference, PT.ProductPrice, PT.ProductDescription, I.InvoiceDate As InvoiceDate, 
	I.InvoiceNumber, (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID and ProductID = PT.ProductID) as LName, PT.FName, C.ClientName as PrimaryClientName
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	LEFT JOIN Clients C2 
	ON C2.ClientID = PT.OriginalClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND (PT.VendorID NOT IN (4,5) or PT.ProductID = 232)
	UNION ALL
	SELECT 0 as Detail, 'COMPANY' as GroupOrder, 1 as RecordCount, '', C2.ClientName as ClientName, '' as Address1, 
	'' as Address2, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',''
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN Clients C2 
	ON C2.ClientID = PT.OriginalClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND (PT.VendorID NOT IN (4,5) or PT.ProductID = 232)
	GROUP BY C2.ClientName
	UNION ALL
	SELECT 2 as Detail, 'COMPANY' as GroupOrder, 1 as RecordCount, PT.FileNum, C2.ClientName as ClientName, 
	'' as Address1, '' as Address2, '', '', '', '', '', (select max(LName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID) + ', ' + (select max(FName) from ProductTransactions where filenum = PT.FileNum and VendorID = PT.VendorID)  as Name, '', '', '',  
	SUM(PT.ProductPrice), '', '', '', '', '',''
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN Clients C2 
	ON C2.ClientID = PT.OriginalClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND (PT.VendorID NOT IN (4,5) or PT.ProductID = 232)
	GROUP BY C2.ClientName, PT.FileNum, PT.VendorID
	Having COUNT(PT.FileNum) > 1 or PT.FileNum in (select FileNum from ProductTransactions where ClientID = 3222 and FileNum is not null and FileNum <> '')
	UNION ALL
	SELECT 3 as Detail, 'COMPANY' as GroupOrder, 1 as RecordCount, '9999998' as FileNum, 
	C2.ClientName as ClientName, '' as Address1, '' as Address2, '', '', '', '', '', 
	'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZ' as Name, '', '', '', SUM(PT.ProductPrice), '', '', '', '', '',''
	FROM ProductsOnInvoice PT
	INNER JOIN Products P
	ON PT.ProductID=P.ProductID
	INNER JOIN Invoices I
	ON I.InvoiceID=PT.InvoiceID
	INNER JOIN Clients C
	ON C.ClientID = I.ClientID
	LEFT JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=C.ClientID
	INNER JOIN Clients C2 
	ON C2.ClientID = PT.OriginalClientID
	INNER JOIN InvoiceBillingContacts IB
	ON IB.InvoiceID = I.InvoiceID AND IB.IsPrimaryBillingContact = 1
	INNER JOIN BillingContacts B
	ON B.BillingContactID = IB.BillingContactID 
	WHERE I.InvoiceID = @InvoiceID AND (PT.VendorID NOT IN (4,5) or PT.ProductID = 232)
	GROUP BY C2.ClientName
	UNION ALL
	SELECT 4 as Detail, 'COMPANY' as GroupOrder,
	1, '9999999' as FileNum, 'zzzzzzzzzz' as ClientName, '', '', '', '', '', '', '', '', '', '', '', 
	(select sum(productprice)
    FROM ProductsOnInvoice PT
	WHERE PT.InvoiceID = @InvoiceID) as ProductPrice , '', '', '', '', '',''
	ORDER BY ClientName,Detail,PT.FileNum 
	
	;with minNameForAliases as (
	   select tr.FileNum,
	          min(tr.Name) as MinName
	     from @tmp_Report tr
		 where coalesce(tr.FileNum,'') <> ''
		 group by tr.FileNum
	)
	SELECT ROW_NUMBER() OVER (ORDER BY tr.ClientName, (CASE WHEN tr.Detail=3 THEN 'ZZZZZZZZZZZZ' ELSE mnfa.MinName END), tr.FileNum, tr.Detail, tr.FName, tr.LName) as LineNumber, 
	       tr.* 
	  FROM @tmp_Report tr
	       left join minNameForAliases mnfa on mnfa.FileNum = tr.FileNum
	  order by LineNumber
END

END
GO
