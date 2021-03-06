/****** Object:  StoredProcedure [dbo].[S1_Invoices_CreateInvoices_Old]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_CreateInvoices '4/1/2010','4/30/2010'
--EXEC S1_Invoices_CreateInvoices '5/1/2010','5/31/2010'

CREATE PROCEDURE [dbo].[S1_Invoices_CreateInvoices_Old]
(
	@StartTransactionDate datetime,
	@EndTransactionDate datetime
)
AS
	SET NOCOUNT ON;

DECLARE @StartNewInvoiceNumber int
SELECT @StartNewInvoiceNumber=IDENT_CURRENT('Invoices')

DECLARE @ProductsOnInvoice TABLE (
	[ProductsOnInvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[SplitBy] [int] NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
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
	[FName] [varchar](50) NULL,
	[LName] [varchar](50) NULL,
	[MName] [varchar](50) NULL,
	[SSN] [varchar](50) NULL,
	[ExternalInvoiceNumber] [varchar](50) NULL
)

DECLARE @InvoiceID int
SET @InvoiceID=1

/* Split By = 1 */

--Insert into Temp Table (Split by Individual Client)
INSERT INTO @ProductsOnInvoice
(SplitBy, InvoiceID, ClientID, ProductID, ProductTransactionID, ProductPrice, 
OrderBy, Reference, ProductName, ProductDescription, ProductType, FileNum, DateOrdered, 
FName, LName, MName, SSN, ExternalInvoiceNumber)
SELECT 1 as SplitBy, DENSE_RANK() OVER (ORDER BY PT.ClientID) + @StartNewInvoiceNumber,
PT.ClientID,PT.ProductID,PT.ProductTransactionID,PT.ProductPrice,PT.OrderBy,
PT.Reference,PT.ProductName,
PT.ProductDescription,PT.ProductType,PT.FileNum,PT.DateOrdered,PT.FName,
PT.LName,PT.MName,PT.SSN,PT.ExternalInvoiceNumber
FROM ProductTransactions PT
INNER JOIN ClientInvoiceSettings CIS
	ON PT.ClientID=CIS.ClientID
WHERE CIS.SplitByMode=1
AND PT.TransactionDate BETWEEN @StartTransactionDate AND @EndTransactionDate

--Insert Invoices
SET IDENTITY_INSERT Invoices ON

INSERT INTO Invoices (InvoiceID, ClientID, InvoiceTypeID, InvoiceNumber, InvoiceDate, BillingContactID, VoidedOn, 
VoidedByUser, Amount, NumberOfColumns, Col1Header, Col2Header, Col3Header, Col4Header, Col5Header, Col6Header, 
Col7Header, Col8Header, CreateInvoicesBatchID)
SELECT InvoiceID,ClientID,1 as InvoiceTypeID,'' as InvoiceNumber,GETDATE() as InvoiceDate,
1 as BillingContactID,null,null,SUM(ProductPrice) as Amount, 0 as NumberOfColumns,'','','','','','','','',0
FROM @ProductsOnInvoice
WHERE SplitBy=1
GROUP BY InvoiceID,ClientID

SET IDENTITY_INSERT Invoices OFF


/* Split By = 2 */
SELECT @StartNewInvoiceNumber=IDENT_CURRENT('Invoices')

--Split By Product
	DECLARE @tmp_ProductSplit TABLE (
		ClientID int,
		BillingContactID int,
		InvoiceSplitID int,
		ProductID int
	)

	INSERT INTO @tmp_ProductSplit (ClientID, BillingContactID, InvoiceSplitID, ProductID)
	SELECT INS.ClientID, INS.BillingContactID, INS.InvoiceSplitID, PS.ProductID
	FROM InvoiceSplit INS
	INNER JOIN ProductSplit PS
		ON PS.InvoiceSplitID=INS.InvoiceSplitID
	WHERE PS.ProductID>0

	INSERT INTO @tmp_ProductSplit (ClientID, BillingContactID, InvoiceSplitID, ProductID)
	SELECT INS.ClientID, INS.BillingContactID, INS.InvoiceSplitID, P.ProductID
	FROM InvoiceSplit INS
	INNER JOIN ProductSplit PS
		ON PS.InvoiceSplitID=INS.InvoiceSplitID
	CROSS JOIN Products P
	WHERE PS.ProductID=0 AND P.ProductID NOT IN 
	(SELECT ProductID FROM @tmp_ProductSplit PS2 WHERE PS2.ClientID=INS.ClientID
	AND PS2.ProductID=PS2.ProductID)
--End Split By Product

--Insert into Temp Table (Split by Parent Client and include Sub-Clients)
INSERT INTO @ProductsOnInvoice
(SplitBy, InvoiceID, ClientID, ProductID, ProductTransactionID, ProductPrice, 
OrderBy, Reference, ProductName, ProductDescription, ProductType, FileNum, DateOrdered, 
FName, LName, MName, SSN, ExternalInvoiceNumber)
SELECT 2 as SplitBy, DENSE_RANK() OVER (ORDER BY 
CASE WHEN C.ParentClientID IS NULL THEN C.ClientID ELSE C.ParentClientID END, 
INS.InvoiceSplitID
) + @StartNewInvoiceNumber,
PT.ClientID,PT.ProductID,PT.ProductTransactionID,PT.ProductPrice,PT.OrderBy,
PT.Reference,PT.ProductName,
PT.ProductDescription,PT.ProductType,PT.FileNum,PT.DateOrdered,PT.FName,
PT.LName,PT.MName,PT.SSN,PT.ExternalInvoiceNumber
FROM ProductTransactions PT
INNER JOIN Clients C
	ON PT.ClientID=C.ClientID
INNER JOIN ClientInvoiceSettings CIS
	ON (PT.ClientID=CIS.ClientID OR C.ParentClientID=CIS.ClientID)
LEFT JOIN InvoiceSplit INS
	ON PT.ClientID=INS.ClientID
LEFT JOIN @tmp_ProductSplit PS
	ON PS.InvoiceSplitID=INS.InvoiceSplitID
	AND PT.ProductID=PS.ProductID
WHERE CIS.SplitByMode=2
AND PT.TransactionDate BETWEEN @StartTransactionDate AND @EndTransactionDate

--Insert Invoices
SET IDENTITY_INSERT Invoices ON

INSERT INTO Invoices (InvoiceID, ClientID, InvoiceTypeID, InvoiceNumber, InvoiceDate, BillingContactID, VoidedOn, 
VoidedByUser, Amount, NumberOfColumns, Col1Header, Col2Header, Col3Header, Col4Header, Col5Header, Col6Header, 
Col7Header, Col8Header, CreateInvoicesBatchID)
SELECT InvoiceID,
CASE WHEN MAX(C.ParentClientID) IS NULL THEN MAX(C.ClientID) ELSE MAX(C.ParentClientID) END,
1 as InvoiceTypeID,'' as InvoiceNumber,GETDATE() as InvoiceDate,
1 as BillingContactID,null,null,SUM(ProductPrice) as Amount, 0 as NumberOfColumns,'','','','','','','','',0
FROM @ProductsOnInvoice POI
INNER JOIN Clients C
	ON POI.ClientID=C.ClientID
WHERE SplitBy=2
GROUP BY InvoiceID

SET IDENTITY_INSERT Invoices OFF



--Insert ProductsOnInvoice
INSERT INTO ProductsOnInvoice (InvoiceID, ProductID, ProductTransactionID, ProductPrice, 
OrderBy, Reference, ProductName, ProductDescription, ProductType, FileNum, DateOrdered, 
FName, LName, MName, SSN, ExternalInvoiceNumber, OriginalClientID)
SELECT InvoiceID,ProductID,ProductTransactionID,ProductPrice,OrderBy,Reference,ProductName,
ProductDescription,ProductType,FileNum,DateOrdered,FName,LName,MName,SSN,
ExternalInvoiceNumber, ClientID
FROM @ProductsOnInvoice
ORDER BY InvoiceID,ClientID


/***** Create Standard Invoice 1.0 (InvoiceTemplateID = 1) *****/
UPDATE Invoices
SET Col1Header='Product',
Col2Header='Description',
NumberOfColumns=2
WHERE ClientID IN 
(SELECT DISTINCT CIS.ClientID FROM ClientInvoiceSettings CIS 
INNER JOIN @ProductsOnInvoice POI2 
	ON CIS.ClientID=POI2.ClientID 
WHERE CIS.InvoiceTemplateID=1)

INSERT INTO InvoiceLines (InvoiceID, InvoiceLineNumber, Col1Text, Col2Text, Col3Text, Col4Text, Col5Text, Col6Text, 
Col7Text, Col8Text, Amount)
SELECT A.InvoiceID, ROW_NUMBER() OVER (PARTITION BY A.InvoiceID ORDER BY A.InvoiceID, A.FileNum, A.Detail), Col1Text, 
Col2Text, '' as Col3Text, '' as Col4Text, '' as Col5Text, '' as Col6Text, '' as Col7Text, '' as Col8Text, A.Amount
FROM (
SELECT POI.FileNum,
POI.InvoiceID,
0 as Detail, 
POI.ProductType as Col1Text, 
CONVERT(varchar(10),POI.DateOrdered,101) + ' ' + POI.LName + ', ' + POI.FName + ' ' + POI.SSN 
+ ' ' + POI.OrderBy + ' ' + POI.FileNum + ' ' + POI.Reference as Col2Text,
POI.ProductPrice as Amount
FROM ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
INNER JOIN Invoices I
	ON I.InvoiceID=POI.InvoiceID
INNER JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=I.ClientID
WHERE POI.ProductTransactionID IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
AND P.ExcludeFromBill=0
AND POI.ProductPrice<>0
AND CIS.InvoiceTemplateID=1
) A


/***** Create Standard Invoice 1.0 [Improved] (InvoiceTemplateID = 2) *****/
UPDATE Invoices
SET Col1Header='Product',
Col2Header='Date Ordered',
Col3Header='Name',
Col4Header='SSN',
Col5Header='Ordered By',
Col6Header='File #',
Col7Header='Reference',
NumberOfColumns=7
WHERE ClientID IN 
(SELECT DISTINCT CIS.ClientID FROM ClientInvoiceSettings CIS 
INNER JOIN @ProductsOnInvoice POI2 
	ON CIS.ClientID=POI2.ClientID 
WHERE CIS.InvoiceTemplateID=2)

INSERT INTO InvoiceLines (InvoiceID, InvoiceLineNumber, Col1Text, Col2Text, Col3Text, Col4Text, Col5Text, Col6Text, 
Col7Text, Col8Text, Amount)
SELECT A.InvoiceID, ROW_NUMBER() OVER (PARTITION BY A.InvoiceID ORDER BY A.InvoiceID, A.FileNum, A.Detail), Col1Text, Col2Text, Col3Text, 
Col4Text, Col5Text, Col6Text, Col7Text, '', A.Amount
FROM (
SELECT POI.FileNum,
POI.InvoiceID,
0 as Detail, 
CASE 
	WHEN POI.ProductType = 'EMP' THEN 'EMPLOYMENT'
	WHEN POI.ProductType = 'TNT' THEN 'TENANT'
	ELSE ''
END
as Col1Text, 
CONVERT(varchar(10),POI.DateOrdered,101) as Col2Text, 
POI.LName + ', ' + POI.FName as Col3Text,
POI.SSN as Col4Text,
POI.OrderBy as Col5Text,
POI.FileNum as Col6Text,
POI.Reference as Col7Text,
POI.ProductPrice as Amount
FROM ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
INNER JOIN Invoices I
	ON I.InvoiceID=POI.InvoiceID
INNER JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=I.ClientID
WHERE POI.ProductTransactionID IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
AND P.ExcludeFromBill=0
AND POI.ProductPrice<>0
AND CIS.InvoiceTemplateID=2
) A




/***** Create Invoice with Quantity and Rate (InvoiceTemplateID = 3) *****/
UPDATE Invoices
SET Col1Header='Product',
Col2Header='Description',
Col3Header='Quantity',
Col4Header='Rate',
NumberOfColumns=4
WHERE ClientID IN 
(SELECT DISTINCT CIS.ClientID FROM ClientInvoiceSettings CIS 
INNER JOIN @ProductsOnInvoice POI2 
	ON CIS.ClientID=POI2.ClientID 
WHERE CIS.InvoiceTemplateID=3)

INSERT INTO InvoiceLines (InvoiceID, InvoiceLineNumber, Col1Text, Col2Text, Col3Text, Col4Text, Col5Text, Col6Text, 
Col7Text, Col8Text, Amount)
SELECT A.InvoiceID, ROW_NUMBER() OVER (PARTITION BY A.InvoiceID ORDER BY A.InvoiceID, A.Detail), Col1Text, 
Col2Text, Col3Text, Col4Text, '' as Col5Text, '' as Col6Text, '' as Col7Text, '' as Col8Text, A.Amount
FROM (
SELECT I.InvoiceID,0 as Detail, 
P.ProductCode as Col1Text, 
P.ProductName as Col2Text, 
COUNT(*) as Col3Text, 
POI.ProductPrice as Col4Text,
COUNT(*) * POI.ProductPrice as Amount
FROM ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
INNER JOIN Invoices I
	ON I.InvoiceID=POI.InvoiceID
INNER JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=I.ClientID
WHERE POI.ProductTransactionID IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
AND P.ExcludeFromBill=0
AND POI.ProductPrice<>0
AND CIS.InvoiceTemplateID=3
GROUP BY I.InvoiceID,P.ProductID,P.ProductCode,P.ProductName,POI.ProductPrice
) A



/***** Create Standard Invoice 2.0 (InvoiceTemplateID = 4) *****/
UPDATE Invoices
SET Col1Header='Product',
Col2Header='Description',
NumberOfColumns=2
WHERE ClientID IN 
(SELECT DISTINCT CIS.ClientID FROM ClientInvoiceSettings CIS 
INNER JOIN @ProductsOnInvoice POI2 
	ON CIS.ClientID=POI2.ClientID 
WHERE CIS.InvoiceTemplateID=4)

INSERT INTO InvoiceLines (InvoiceID, InvoiceLineNumber, Col1Text, Col2Text, Col3Text, Col4Text, Col5Text, Col6Text, 
Col7Text, Col8Text, Amount)
SELECT A.InvoiceID, ROW_NUMBER() OVER (PARTITION BY A.InvoiceID ORDER BY A.InvoiceID, A.FileNum, A.Detail), Col1Text, 
Col2Text, '' as Col3Text, '' as Col4Text, '' as Col5Text, '' as Col6Text, '' as Col7Text, '' as Col8Text, A.Amount
FROM (
SELECT POI.FileNum,
POI.InvoiceID,
0 as Detail, 
CASE 
	WHEN POI.ProductType = 'employment' THEN 'EMPLOYMENT'
	WHEN POI.ProductType = 'tenant' THEN 'TENANT'
	ELSE ''
END as Col1Text, 
CONVERT(varchar(10),POI.DateOrdered,101) + ' ' + POI.LName + ', ' + POI.FName + ' ' + POI.SSN 
+ ' ' + POI.OrderBy + ' ' + POI.FileNum + ' ' + POI.Reference + ' ' + POI.ProductDescription as Col2Text,
POI.ProductPrice as Amount
FROM ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
INNER JOIN Invoices I
	ON I.InvoiceID=POI.InvoiceID
INNER JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=I.ClientID
WHERE POI.ProductTransactionID IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
AND P.ExcludeFromBill=0
AND POI.ProductPrice<>0
AND CIS.InvoiceTemplateID=4
) A



/***** Create Standard Invoice 2.0 [Improved] (InvoiceTemplateID = 5) *****/
UPDATE Invoices
SET Col1Header='Product',
Col2Header='Date Ordered',
Col3Header='Name / SSN',
Col4Header='Ordered By',
Col5Header='File #',
Col6Header='Reference',
Col7Header='Description',
NumberOfColumns=7
WHERE ClientID IN 
(SELECT DISTINCT CIS.ClientID FROM ClientInvoiceSettings CIS 
INNER JOIN @ProductsOnInvoice POI2 
	ON CIS.ClientID=POI2.ClientID 
WHERE CIS.InvoiceTemplateID=5)

INSERT INTO InvoiceLines (InvoiceID, InvoiceLineNumber, Col1Text, Col2Text, Col3Text, Col4Text, Col5Text, Col6Text, 
Col7Text, Col8Text, Amount)
SELECT A.InvoiceID, ROW_NUMBER() OVER (PARTITION BY A.InvoiceID ORDER BY A.InvoiceID, A.FileNum, A.Detail), Col1Text, 
Col2Text, Col3Text, Col4Text, Col5Text, Col6Text, Col7Text, '' as Col8Text, A.Amount
FROM (
SELECT POI.FileNum,
POI.InvoiceID,
0 as Detail, 
CASE 
	WHEN POI.ProductType = 'employment' THEN 'EMPLOYMENT'
	WHEN POI.ProductType = 'tenant' THEN 'TENANT'
	ELSE ''
END as Col1Text, 
CONVERT(varchar(10),POI.DateOrdered,101) as Col2Text,
POI.LName + ', ' + POI.FName + ' ' + POI.SSN as Col3Text,
POI.OrderBy as Col4Text,
POI.FileNum as Col5Text,
POI.Reference as Col6Text,
POI.ProductDescription as Col7Text,
POI.ProductPrice as Amount
FROM ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
INNER JOIN Invoices I
	ON I.InvoiceID=POI.InvoiceID
INNER JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=I.ClientID
WHERE POI.ProductTransactionID IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
AND P.ExcludeFromBill=0
AND POI.ProductPrice<>0
AND CIS.InvoiceTemplateID=5
) A



/***** Create Invoice with See Attached Detail (InvoiceTemplateID = 6) *****/
UPDATE Invoices
SET Col1Header='Product',
Col2Header='Description',
NumberOfColumns=2
WHERE ClientID IN 
(SELECT DISTINCT CIS.ClientID FROM ClientInvoiceSettings CIS 
INNER JOIN @ProductsOnInvoice POI2 
	ON CIS.ClientID=POI2.ClientID 
WHERE CIS.InvoiceTemplateID=6)

INSERT INTO InvoiceLines (InvoiceID, InvoiceLineNumber, Col1Text, Col2Text, Col3Text, Col4Text, Col5Text, Col6Text, 
Col7Text, Col8Text, Amount)
SELECT A.InvoiceID, ROW_NUMBER() OVER (PARTITION BY A.InvoiceID ORDER BY A.InvoiceID, A.Detail), Col1Text, 
Col2Text, '' as Col3Text, '' as Col4Text, '' as Col5Text, '' as Col6Text, '' as Col7Text, '' as Col8Text, A.Amount
FROM (
SELECT I.InvoiceID,0 as Detail, 
'DETAIL' as Col1Text, 
'SEE ATTACHED DETAIL' as Col2Text, 
SUM(POI.ProductPrice) as Amount
FROM ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
INNER JOIN Invoices I
	ON I.InvoiceID=POI.InvoiceID
INNER JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=I.ClientID
WHERE POI.ProductTransactionID IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
AND P.ExcludeFromBill=0
AND POI.ProductPrice<>0
AND CIS.InvoiceTemplateID=6
GROUP BY I.InvoiceID
) A



/***** Create Invoice with Subtotal by Sub-client (InvoiceTemplateID = 7) *****/
UPDATE Invoices
SET Col1Header='Product',
Col2Header='Description',
NumberOfColumns=2
WHERE ClientID IN 
(SELECT DISTINCT CIS.ClientID 
FROM ClientInvoiceSettings CIS 
INNER JOIN Clients C
	ON C.ParentClientID=CIS.ClientID
INNER JOIN @ProductsOnInvoice POI2
	ON C.ClientID=POI2.ClientID
WHERE CIS.InvoiceTemplateID=7)

INSERT INTO InvoiceLines (InvoiceID, InvoiceLineNumber, Col1Text, Col2Text, Col3Text, Col4Text, Col5Text, Col6Text, 
Col7Text, Col8Text, Amount)
SELECT A.InvoiceID, ROW_NUMBER() OVER (PARTITION BY A.InvoiceID ORDER BY A.InvoiceID, A.Detail), Col1Text, 
Col2Text, '' as Col3Text, '' as Col4Text, '' as Col5Text, '' as Col6Text, '' as Col7Text, '' as Col8Text, A.Amount
FROM (
SELECT I.InvoiceID,0 as Detail, 
'DETAIL' as Col1Text, 
OC.ClientName + ' - SEE ATTACHED DETAIL' as Col2Text, 
SUM(POI.ProductPrice) as Amount
FROM ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
INNER JOIN Invoices I
	ON I.InvoiceID=POI.InvoiceID
INNER JOIN ClientInvoiceSettings CIS
	ON CIS.ClientID=I.ClientID
INNER JOIN Clients OC --OriginalClient
	ON OC.ClientID=POI.OriginalClientID
WHERE POI.ProductTransactionID IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
AND P.ExcludeFromBill=0
AND POI.ProductPrice<>0
AND CIS.InvoiceTemplateID=7
GROUP BY I.InvoiceID, POI.OriginalClientID, OC.ClientName
) A


/*
INSERT INTO InvoiceLines (InvoiceID, InvoiceLineNumber, Col1Text, Col2Text, Col3Text, Col4Text, Col5Text, Col6Text, 
Col7Text, Col8Text, Amount)
SELECT A.InvoiceID, ROW_NUMBER() OVER (ORDER BY A.InvoiceID, A.FileNum, A.Detail), Col1Text, Col2Text, '', '', '', '', '', '', A.Amount
FROM (
SELECT POI.FileNum,POI.InvoiceID,0 as Detail, 
'Date Ordered: ' + CONVERT(varchar(10),MAX(POI.DateOrdered),101) as Col1Text, 
'Name: ' + MAX(POI.LName) + ', ' + MAX(POI.FName) + ' ' + MAX(POI.SSN) as Col2Text, 
SUM(POI.ProductPrice) as Amount
FROM ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
WHERE POI.ProductTransactionID IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
AND P.ExcludeFromBill=0
AND POI.ProductPrice<>0
GROUP BY POI.InvoiceID,POI.FileNum
UNION ALL
SELECT POI.FileNum,POI.InvoiceID,1 as Detail,
'- ' + P.ProductName as Col1Text, 
'- ' + POI.ProductDescription + ' ~ $' + CONVERT(varchar(20),POI.ProductPrice) as Col2Text, 
0 as Amount
FROM ProductsOnInvoice POI
INNER JOIN Products P
	ON P.ProductID=POI.ProductID
WHERE POI.ProductTransactionID IN (SELECT ProductTransactionID FROM @ProductsOnInvoice)
AND P.ExcludeFromBill=0
AND POI.ProductPrice<>0
) A*/
GO
