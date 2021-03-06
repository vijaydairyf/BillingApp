/****** Object:  StoredProcedure [dbo].[S1_Invoices_CreateInvoicesVerify]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_CreateInvoicesVerify '4/1/2010','4/30/2010','5/1/2010'
--EXEC S1_Invoices_CreateInvoicesVerify '8/1/2010','8/31/2010','9/1/2010',0

CREATE PROCEDURE [dbo].[S1_Invoices_CreateInvoicesVerify]
(
	@StartTransactionDate datetime,
	@EndTransactionDate datetime,
	@InvoiceDate datetime,
	@BillingGroup int
)
AS
	SET NOCOUNT ON;

DECLARE @StartNewInvoiceNumber int
SELECT @StartNewInvoiceNumber=IDENT_CURRENT('Invoices')

DECLARE @StartTransactionDateToPull datetime
SELECT @StartTransactionDateToPull=DATEADD(month,-1,@StartTransactionDate)

DECLARE @InvoiceNumberPrefix varchar(20)
SELECT @InvoiceNumberPrefix = CONVERT(varchar,YEAR(@InvoiceDate)) + RIGHT('0' + CONVERT(varchar, MONTH(@InvoiceDate)),2)

DECLARE @CountOfNextInvoiceNumber int
SELECT @CountOfNextInvoiceNumber = COUNT(*) FROM NextInvoiceNumber WHERE InvoiceNumberPrefix=@InvoiceNumberPrefix

DECLARE @NextInvoiceNumber int
SELECT @NextInvoiceNumber = 0

DECLARE @ClientsTemp TABLE (
	[ClientID] [int] NOT NULL,
	[OriginalClientID] [int] NOT NULL
)

DECLARE @ProductsOnInvoice TABLE (
	[ProductsOnInvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[SplitBy] [int] NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[OriginalClientID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductTransactionID] [int] NULL,
	[TransactionDate] [smalldatetime] NULL,
	[ProductPrice] [money] NOT NULL,
	[OrderBy] [varchar](100) NULL,
	[Reference] [varchar](100) NULL,
	[ProductName] [varchar](100) NULL,
	[ProductDescription] [varchar](max) NULL,
	[ProductType] [varchar](50) NULL,
	[FileNum] [varchar](50) NULL,
	[DateOrdered] [smalldatetime] NULL,
	[FName] [varchar](255) NULL,
	[LName] [varchar](255) NULL,
	[MName] [varchar](255) NULL,
	[SSN] [varchar](50) NULL,
	[CoFName] [varchar](255) NULL,
	[CoLName] [varchar](255) NULL,
	[CoMName] [varchar](255) NULL,
	[CoSSN] [varchar](50) NULL,
	[ExternalInvoiceNumber] [varchar](50) NULL,
	[InvoiceSplitID] [int] NULL,
	[VendorID] [int] NULL
)
DECLARE @InvoiceID int
SET @InvoiceID=1

/* Split By = 1 - Individual Clients */

INSERT INTO @ClientsTemp (ClientID, OriginalClientID)
SELECT C.ClientID, C.ClientID
FROM Clients C
INNER JOIN ClientInvoiceSettings CIS
	ON C.ClientID=CIS.ClientID
WHERE CIS.SplitByMode=1

/* Split By = 2 - Group by Master Client */

INSERT INTO @ClientsTemp (ClientID, OriginalClientID)
SELECT CIS.ClientID, C.ClientID
FROM Clients C
INNER JOIN ClientInvoiceSettings CIS
	ON (C.ClientID=CIS.ClientID OR C.ParentClientID=CIS.ClientID)
WHERE CIS.SplitByMode=2

/* Split By = 3 - Group by Custom Client Splits */

INSERT INTO @ClientsTemp (ClientID, OriginalClientID)
SELECT CS.GroupAsClientID,CSC.ClientID 
FROM Clients C
INNER JOIN ClientInvoiceSettings CIS
	ON C.ClientID=CIS.ClientID
INNER JOIN ClientSplit CS
	ON C.ClientID=CS.ParentClientID
INNER JOIN ClientSplitClient CSC
	ON CS.ClientSplitID=CSC.ClientSplitID
WHERE C.ParentClientID IS NULL AND CIS.SplitByMode=3


--Split By Product
	DECLARE @tmp_ProductSplit TABLE (
		ClientID int,
		BillingContactID int,
		InvoiceSplitID int,
		ProductID int
	)

	INSERT INTO @tmp_ProductSplit (ClientID, BillingContactID, InvoiceSplitID, ProductID)
	SELECT INS.ClientID, ISBC.BillingContactID, INS.InvoiceSplitID, PS.ProductID
	FROM InvoiceSplit INS
	INNER JOIN ProductSplit PS
		ON PS.InvoiceSplitID=INS.InvoiceSplitID
	INNER JOIN InvoiceSplitBillingContacts ISBC
		ON ISBC.InvoiceSplitID=INS.InvoiceSplitID
		AND ISBC.IsPrimaryBillingContact=1
	WHERE PS.ProductID>0

	INSERT INTO @tmp_ProductSplit (ClientID, BillingContactID, InvoiceSplitID, ProductID)
	SELECT INS.ClientID, ISBC.BillingContactID, INS.InvoiceSplitID, P.ProductID
	FROM InvoiceSplit INS
	INNER JOIN ProductSplit PS
		ON PS.InvoiceSplitID=INS.InvoiceSplitID
	INNER JOIN InvoiceSplitBillingContacts ISBC
		ON ISBC.InvoiceSplitID=INS.InvoiceSplitID
		AND ISBC.IsPrimaryBillingContact=1
	CROSS JOIN Products P
	WHERE PS.ProductID=0 AND P.ProductID NOT IN 
	(SELECT ProductID FROM @tmp_ProductSplit PS2 WHERE PS2.ClientID=INS.ClientID
	AND PS2.ProductID=PS2.ProductID)
--End Split By Product



--Insert into Temp Table (Split by Product)
INSERT INTO @ProductsOnInvoice
(SplitBy, InvoiceID, ClientID, OriginalClientID, ProductID, ProductTransactionID, ProductPrice, 
OrderBy, Reference, ProductName, ProductDescription, ProductType, FileNum, DateOrdered, 
FName, LName, MName, SSN, CoFName, CoLName, CoMName, CoSSN, ExternalInvoiceNumber, 
InvoiceSplitID, VendorID)
SELECT 1 as SplitBy, DENSE_RANK() OVER (ORDER BY CT.ClientID, INS.InvoiceSplitID) + @StartNewInvoiceNumber,
CT.ClientID,PT.ClientID,PT.ProductID,PT.ProductTransactionID,PT.ProductPrice,PT.OrderBy,
PT.Reference,PT.ProductName,
PT.ProductDescription,PT.ProductType,PT.FileNum,PT.DateOrdered,PT.FName,
PT.LName,PT.MName,PT.SSN,PT.CoFName,
PT.CoLName,PT.CoMName,PT.CoSSN,PT.ExternalInvoiceNumber,
INS.InvoiceSplitID, PT.VendorID
FROM (
SELECT PT2.ProductTransactionID,
PT2.ProductID, PT2.ClientID, PT2.VendorID, PT2.TransactionDate, PT2.DateOrdered,
PT2.OrderBy, PT2.Reference, PT2.FileNum, PT2.FName, PT2.LName, PT2.MName, PT2.SSN,
PT2.ProductName, PT2.ProductDescription, PT2.ProductType, PT2.CoLName, PT2.CoFName,
PT2.CoMName, PT2.CoSSN,
(CASE WHEN CP.ImportsAtBaseOrSales=0 THEN CP.SalesPrice ELSE PT2.ProductPrice END)
AS ProductPrice,
PT2.SalesRep,PT2.ExternalInvoiceNumber
FROM ProductTransactions PT2
INNER JOIN Clients C
	ON PT2.ClientID=C.ClientID
INNER JOIN ClientProducts CP
	ON PT2.ClientID=CP.ClientID
	AND PT2.ProductID=CP.ProductID
WHERE PT2.TransactionDate BETWEEN @StartTransactionDateToPull AND @EndTransactionDate  
AND PT2.Invoiced=0
AND (C.BillingGroup=@BillingGroup OR @BillingGroup=0)
AND C.DoNotInvoice=0
AND CP.IncludeOnInvoice<>2
AND (CP.IncludeOnInvoice<>1 OR PT2.ProductPrice<>0)
/*AND NOT EXISTS (SELECT 1 FROM ProductsOnInvoice POI
	WHERE POI.ProductTransactionID=PT2.ProductTransactionID)*/
) PT
INNER JOIN @ClientsTemp CT
	ON PT.ClientID=CT.OriginalClientID
INNER JOIN InvoiceSplit INS
	ON CT.ClientID=INS.ClientID
INNER JOIN @tmp_ProductSplit PS
	ON PS.InvoiceSplitID=INS.InvoiceSplitID
	AND PS.ProductID=PT.ProductID
WHERE PT.TransactionDate BETWEEN @StartTransactionDateToPull AND @EndTransactionDate

DECLARE @TempStartNewInvoiceNumber int
SELECT @TempStartNewInvoiceNumber=MAX(InvoiceID) FROM @ProductsOnInvoice
IF (@TempStartNewInvoiceNumber IS NOT NULL)
BEGIN
	SELECT @StartNewInvoiceNumber=@TempStartNewInvoiceNumber
END


--Insert into Temp Table (Split by Reference)
INSERT INTO @ProductsOnInvoice
(SplitBy, InvoiceID, ClientID, OriginalClientID, ProductID, ProductTransactionID, ProductPrice, 
OrderBy, Reference, ProductName, ProductDescription, ProductType, FileNum, DateOrdered, 
FName, LName, MName, SSN, CoFName, CoLName, CoMName, CoSSN, ExternalInvoiceNumber, 
InvoiceSplitID, VendorID)
SELECT 1 as SplitBy, DENSE_RANK() OVER (ORDER BY CT.ClientID, INS.InvoiceSplitID) + @StartNewInvoiceNumber,
CT.ClientID,PT.ClientID,PT.ProductID,PT.ProductTransactionID,PT.ProductPrice,PT.OrderBy,
PT.Reference,PT.ProductName,
PT.ProductDescription,PT.ProductType,PT.FileNum,PT.DateOrdered,PT.FName,
PT.LName,PT.MName,PT.SSN,PT.CoFName,
PT.CoLName,PT.CoMName,PT.CoSSN,PT.ExternalInvoiceNumber,
INS.InvoiceSplitID, PT.VendorID
FROM (
SELECT PT2.ProductTransactionID,
PT2.ProductID, PT2.ClientID, PT2.VendorID, PT2.TransactionDate, PT2.DateOrdered,
PT2.OrderBy, PT2.Reference, PT2.FileNum, PT2.FName, PT2.LName, PT2.MName, PT2.SSN,
PT2.ProductName, PT2.ProductDescription, PT2.ProductType, PT2.CoLName, PT2.CoFName,
PT2.CoMName, PT2.CoSSN,
(CASE WHEN CP.ImportsAtBaseOrSales=0 THEN CP.SalesPrice ELSE PT2.ProductPrice END)
AS ProductPrice,
PT2.SalesRep,PT2.ExternalInvoiceNumber
FROM ProductTransactions PT2
INNER JOIN Clients C
	ON PT2.ClientID=C.ClientID
INNER JOIN ClientProducts CP
	ON PT2.ClientID=CP.ClientID
	AND PT2.ProductID=CP.ProductID
WHERE PT2.TransactionDate BETWEEN @StartTransactionDateToPull AND @EndTransactionDate  
AND PT2.Invoiced=0
AND C.DoNotInvoice=0
AND (C.BillingGroup=@BillingGroup OR @BillingGroup=0)
AND CP.IncludeOnInvoice<>2
AND (CP.IncludeOnInvoice<>1 OR PT2.ProductPrice<>0)
/*AND NOT EXISTS (SELECT 1 FROM ProductsOnInvoice POI
	INNER JOIN Invoices I
		ON POI.InvoiceID=I.InvoiceID
	WHERE POI.ProductTransactionID=PT2.ProductTransactionID AND I.VoidedOn IS NULL)
	*/
	) PT
INNER JOIN @ClientsTemp CT
	ON PT.ClientID=CT.OriginalClientID
INNER JOIN InvoiceSplit INS
	ON CT.ClientID=INS.ClientID
INNER JOIN ReferenceSplit RS
	ON RS.InvoiceSplitID=INS.InvoiceSplitID
	AND RS.ReferenceText=PT.Reference
WHERE PT.TransactionDate BETWEEN @StartTransactionDateToPull AND @EndTransactionDate

SELECT @TempStartNewInvoiceNumber=MAX(InvoiceID) FROM @ProductsOnInvoice
IF (@TempStartNewInvoiceNumber IS NOT NULL)
BEGIN
	SELECT @StartNewInvoiceNumber=@TempStartNewInvoiceNumber
END


--Insert into Temp Table (Split by Ordered By)
INSERT INTO @ProductsOnInvoice
(SplitBy, InvoiceID, ClientID, OriginalClientID, ProductID, ProductTransactionID, ProductPrice, 
OrderBy, Reference, ProductName, ProductDescription, ProductType, FileNum, DateOrdered, 
FName, LName, MName, SSN, CoFName, CoLName, CoMName, CoSSN, ExternalInvoiceNumber, 
InvoiceSplitID, VendorID)
SELECT 1 as SplitBy, DENSE_RANK() OVER (ORDER BY CT.ClientID, INS.InvoiceSplitID) + @StartNewInvoiceNumber,
CT.ClientID,PT.ClientID,PT.ProductID,PT.ProductTransactionID,PT.ProductPrice,PT.OrderBy,
PT.Reference,PT.ProductName,
PT.ProductDescription,PT.ProductType,PT.FileNum,PT.DateOrdered,PT.FName,
PT.LName,PT.MName,PT.SSN,PT.CoFName,
PT.CoLName,PT.CoMName,PT.CoSSN,PT.ExternalInvoiceNumber,
INS.InvoiceSplitID, PT.VendorID
FROM (
SELECT PT2.ProductTransactionID,
PT2.ProductID, PT2.ClientID, PT2.VendorID, PT2.TransactionDate, PT2.DateOrdered,
PT2.OrderBy, PT2.Reference, PT2.FileNum, PT2.FName, PT2.LName, PT2.MName, PT2.SSN,
PT2.ProductName, PT2.ProductDescription, PT2.ProductType, PT2.CoFName, PT2.CoLName,
PT2.CoMName, PT2.CoSSN,
(CASE WHEN CP.ImportsAtBaseOrSales=0 THEN CP.SalesPrice ELSE PT2.ProductPrice END)
AS ProductPrice,
PT2.SalesRep,PT2.ExternalInvoiceNumber
FROM ProductTransactions PT2
INNER JOIN Clients C
	ON PT2.ClientID=C.ClientID
INNER JOIN ClientProducts CP
	ON PT2.ClientID=CP.ClientID
	AND PT2.ProductID=CP.ProductID
WHERE PT2.TransactionDate BETWEEN @StartTransactionDateToPull AND @EndTransactionDate  
AND PT2.Invoiced=0
AND C.DoNotInvoice=0
AND (C.BillingGroup=@BillingGroup OR @BillingGroup=0)
AND CP.IncludeOnInvoice<>2
AND (CP.IncludeOnInvoice<>1 OR PT2.ProductPrice<>0)
/*AND NOT EXISTS (SELECT 1 FROM ProductsOnInvoice POI
	INNER JOIN Invoices I
		ON POI.InvoiceID=I.InvoiceID
	WHERE POI.ProductTransactionID=PT2.ProductTransactionID AND I.VoidedOn IS NULL)*/
	) PT
INNER JOIN @ClientsTemp CT
	ON PT.ClientID=CT.OriginalClientID
INNER JOIN InvoiceSplit INS
	ON CT.ClientID=INS.ClientID
INNER JOIN OrderedBySplit OB
	ON OB.InvoiceSplitID=INS.InvoiceSplitID
	AND OB.OrderedBy=PT.OrderBy
WHERE PT.TransactionDate BETWEEN @StartTransactionDateToPull AND @EndTransactionDate

SELECT @TempStartNewInvoiceNumber=MAX(InvoiceID) FROM @ProductsOnInvoice
IF (@TempStartNewInvoiceNumber IS NOT NULL)
BEGIN
	SELECT @StartNewInvoiceNumber=@TempStartNewInvoiceNumber
END


--Insert into Temp Table (No Split)
INSERT INTO @ProductsOnInvoice
(SplitBy, InvoiceID, ClientID, OriginalClientID, ProductID, ProductTransactionID, 
ProductPrice, OrderBy, Reference, ProductName, ProductDescription, ProductType, FileNum, 
DateOrdered, FName, LName, MName, SSN, CoFName, CoLName, CoMName, CoSSN, ExternalInvoiceNumber, 
InvoiceSplitID,VendorID)
SELECT 1 as SplitBy, DENSE_RANK() OVER (ORDER BY CT.ClientID) + @StartNewInvoiceNumber,
CT.ClientID,PT.ClientID,PT.ProductID,PT.ProductTransactionID,PT.ProductPrice,PT.OrderBy,
PT.Reference,PT.ProductName,
PT.ProductDescription,PT.ProductType,PT.FileNum,PT.DateOrdered,PT.FName,
PT.LName,PT.MName,PT.SSN,PT.CoFName,
PT.CoLName,PT.CoMName,PT.CoSSN,PT.ExternalInvoiceNumber,
NULL AS InvoiceSplitID,PT.VendorID
FROM (
SELECT PT2.ProductTransactionID,
PT2.ProductID, PT2.ClientID, PT2.VendorID, PT2.TransactionDate, PT2.DateOrdered,
PT2.OrderBy, PT2.Reference, PT2.FileNum, PT2.FName, PT2.LName, PT2.MName, PT2.SSN,
PT2.ProductName, PT2.ProductDescription, PT2.ProductType, PT2.CoLName, PT2.CoFName,
PT2.CoMName, PT2.CoSSN,
(CASE WHEN CP.ImportsAtBaseOrSales=0 THEN CP.SalesPrice ELSE PT2.ProductPrice END)
AS ProductPrice,
PT2.SalesRep,PT2.ExternalInvoiceNumber
FROM ProductTransactions PT2
INNER JOIN Clients C
	ON PT2.ClientID=C.ClientID
INNER JOIN ClientProducts CP
	ON PT2.ClientID=CP.ClientID
	AND PT2.ProductID=CP.ProductID
WHERE PT2.TransactionDate BETWEEN @StartTransactionDateToPull AND @EndTransactionDate  
AND PT2.Invoiced=0
AND C.DoNotInvoice=0
AND (C.BillingGroup=@BillingGroup OR @BillingGroup=0)
AND CP.IncludeOnInvoice<>2
AND (CP.IncludeOnInvoice<>1 OR PT2.ProductPrice<>0)
/*AND NOT EXISTS (SELECT 1 FROM ProductsOnInvoice POI
	INNER JOIN Invoices I
		ON POI.InvoiceID=I.InvoiceID
	WHERE POI.ProductTransactionID=PT2.ProductTransactionID AND I.VoidedOn IS NULL)
	*/
	) PT
INNER JOIN @ClientsTemp CT
	ON PT.ClientID=CT.OriginalClientID
WHERE PT.TransactionDate BETWEEN @StartTransactionDateToPull AND @EndTransactionDate
AND PT.ProductTransactionID NOT IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)


--SELECT * FROM @ProductsOnInvoice



--SELECT * FROM @ProductsOnInvoice

--SELECT * FROM @ClientsTemp

--Mising or improperly configured ClientInvoiceSettings
SELECT DISTINCT 'Missing ClientInvoiceSettings' as DataSetName, 
PT.ClientID, C.ClientName, 0 as ProductID, '' as ProductName
FROM ProductTransactions PT
INNER JOIN Clients C
	ON C.ClientID=PT.ClientID
INNER JOIN ClientProducts CP
	ON PT.ClientID=CP.ClientID
	AND PT.ProductID=CP.ProductID
WHERE NOT EXISTS (SELECT 1 FROM @ClientsTemp CT
	WHERE CT.ClientID=PT.ClientID)
AND PT.TransactionDate BETWEEN @StartTransactionDateToPull AND @EndTransactionDate
AND PT.Invoiced=0
AND (C.BillingGroup=@BillingGroup OR @BillingGroup=0)
AND C.DoNotInvoice=0
AND CP.IncludeOnInvoice<>2
AND (CP.IncludeOnInvoice<>1 OR PT.ProductPrice<>0)
AND NOT EXISTS (SELECT 1 FROM ClientInvoiceSettings CIS2 
WHERE CIS2.ClientID=C.ParentClientID AND CIS2.SplitByMode=2)

UNION ALL

--Missing ClientProducts setup
SELECT DISTINCT 'Missing ClientProducts' as DataSetName, 
POI.ClientID,C.ClientName,P.ProductID,P.ProductName
FROM @ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
INNER JOIN VendorProducts VP
	ON VP.ProductID=P.ProductID
INNER JOIN Clients C
	ON C.ClientID=POI.ClientID	
WHERE NOT EXISTS (SELECT 1 FROM ClientProducts CP WHERE CP.ClientID=POI.ClientID
AND CP.ProductID=POI.ProductID)

UNION ALL

--Missing BillingContacts
SELECT DISTINCT 'Missing BillingContacts' as DataSetName, 
POI.ClientID, C.ClientName, 0 as ProductID, '' as ProductName 
FROM @ProductsOnInvoice POI 
INNER JOIN Clients C
	ON C.ClientID=POI.ClientID
WHERE NOT EXISTS
(SELECT 1 FROM ClientContacts CC INNER JOIN BillingContacts BC 
	ON CC.ClientContactID=BC.ClientContactID
	WHERE BC.IsPrimaryBillingContact=1 
	AND BC.ClientID=POI.ClientID)

UNION ALL

--Missing Reference in ReferenceSplit
SELECT DISTINCT 'Missing Reference in ReferenceSplit' as DataSetName, 
POI.ClientID, C.ClientName, 0, POI.Reference as ProductName
FROM @ProductsOnInvoice POI
INNER JOIN Clients C
	ON C.ClientID=POI.ClientID
LEFT JOIN (SELECT DISTINCT INS.ClientID, RS.ReferenceText 
FROM InvoiceSplit INS
INNER JOIN ReferenceSplit RS
	ON INS.InvoiceSplitID=RS.InvoiceSplitID) A
	ON A.ClientID=POI.ClientID
	AND POI.Reference=A.ReferenceText
WHERE POI.ClientID IN (SELECT DISTINCT INS.ClientID 
FROM InvoiceSplit INS
INNER JOIN ReferenceSplit RS
	ON INS.InvoiceSplitID=RS.InvoiceSplitID
)
AND A.ReferenceText IS NULL
--AND POI.ProductTransactionID BETWEEN @StartTransactionDateToPull AND @EndTransactionDate

UNION ALL

SELECT DISTINCT 'Missing OrderBy in OrderBySplit' as DataSetName, 
POI.ClientID, C.ClientName, 0, POI.OrderBy as ProductName
FROM @ProductsOnInvoice POI
INNER JOIN Clients C
	ON C.ClientID=POI.ClientID
LEFT JOIN 
(SELECT DISTINCT INS.ClientID, OS.OrderedBy
	FROM InvoiceSplit INS
	INNER JOIN OrderedBySplit OS
		ON INS.InvoiceSplitID=OS.InvoiceSplitID) A
ON A.ClientID=POI.ClientID
	AND POI.OrderBy=A.OrderedBy
WHERE POI.ClientID IN (SELECT DISTINCT INS.ClientID 
FROM InvoiceSplit INS
INNER JOIN OrderedBySplit OS
	ON INS.InvoiceSplitID=OS.InvoiceSplitID
)
AND A.OrderedBy IS NULL


/*
SELECT DISTINCT PT.ClientID, Reference
FROM ProductTransactions PT
LEFT JOIN (SELECT DISTINCT INS.ClientID, RS.ReferenceText 
FROM InvoiceSplit INS
INNER JOIN ReferenceSplit RS
	ON INS.InvoiceSplitID=RS.InvoiceSplitID) A
	ON A.ClientID=PT.ClientID
	AND PT.Reference=A.ReferenceText
WHERE PT.ClientID IN (SELECT DISTINCT INS.ClientID 
FROM InvoiceSplit INS
INNER JOIN ReferenceSplit RS
	ON INS.InvoiceSplitID=RS.InvoiceSplitID
)
ORDER BY ClientID, Reference

SELECT DISTINCT PT.ClientID, OrderBy
FROM ProductTransactions PT
LEFT JOIN (SELECT DISTINCT INS.ClientID, OS.OrderedBy
FROM InvoiceSplit INS
INNER JOIN OrderedBySplit OS
	ON INS.InvoiceSplitID=OS.InvoiceSplitID) A
	ON A.ClientID=PT.ClientID
	AND PT.OrderBy=A.OrderedBy
WHERE PT.ClientID IN (SELECT DISTINCT INS.ClientID 
FROM InvoiceSplit INS
INNER JOIN OrderedBySplit OS
	ON INS.InvoiceSplitID=OS.InvoiceSplitID
)
ORDER BY ClientID, OrderBy
*/

/*
SELECT *
FROM ProductTransactions PT
WHERE PT.TransactionDate BETWEEN @StartTransactionDate AND @EndTransactionDate
AND PT.ProductTransactionID NOT IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
*/


GO
