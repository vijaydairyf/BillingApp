/****** Object:  StoredProcedure [dbo].[S1_ProductTransactions_GetProductTransactions]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--S1_ProductTransactions_GetProductTransactions 2, 1

CREATE PROCEDURE [dbo].[S1_ProductTransactions_GetProductTransactions]
(
	@Status int,
	@ClientID int
)
AS
	SET NOCOUNT ON;
	
IF (@Status=0)
BEGIN

--All Transactions
SELECT PT.ProductTransactionID, PT.FileNum, PT.OrderBy, PT.Reference, PT.TransactionDate, PT.DateOrdered, 
PT.FName, PT.LName, PT.MName, PT.ProductID, PT.ProductDescription, PT.ProductType, 
P.ProductName, 
(CASE WHEN CP.ImportsAtBaseOrSales=0 THEN CP.SalesPrice ELSE PT.ProductPrice END) 
	AS ProductPrice, PT.ExternalInvoiceNumber, PT.SalesRep, PT.ClientID,
C.ClientName,CP.IncludeOnInvoice
FROM ProductTransactions PT
INNER JOIN Products P
	ON PT.ProductID=P.ProductID
INNER JOIN Clients C
	ON C.ClientID=PT.ClientID
INNER JOIN ClientProducts CP
		ON CP.ClientID=PT.ClientID
		AND CP.ProductID=PT.ProductID
WHERE (@ClientID=0 OR C.ClientID=@ClientID)

END
ELSE IF (@Status=1)
BEGIN

--New Transactions
SELECT PT.ProductTransactionID, PT.FileNum, PT.OrderBy, PT.Reference, PT.TransactionDate, PT.DateOrdered, 
PT.FName, PT.LName, PT.MName, PT.ProductID, PT.ProductDescription, PT.ProductType, 
P.ProductName, 
(CASE WHEN CP.ImportsAtBaseOrSales=0 THEN CP.SalesPrice ELSE PT.ProductPrice END) 
	AS ProductPrice, PT.ExternalInvoiceNumber, PT.SalesRep, PT.ClientID,
C.ClientName,CP.IncludeOnInvoice
FROM ProductTransactions PT
INNER JOIN ProductsOnInvoice POI
	ON PT.ProductTransactionID=POI.ProductTransactionID
INNER JOIN Invoices I
	ON POI.InvoiceID=I.InvoiceID
INNER JOIN Products P
	ON PT.ProductID=P.ProductID
INNER JOIN Clients C
	ON C.ClientID=PT.ClientID
INNER JOIN ClientProducts CP
		ON CP.ClientID=PT.ClientID
		AND CP.ProductID=PT.ProductID	
WHERE I.VoidedOn IS NOT NULL
AND (@ClientID=0 OR C.ClientID=@ClientID)
UNION ALL
SELECT PT.ProductTransactionID, PT.FileNum, PT.OrderBy, PT.Reference, PT.TransactionDate, PT.DateOrdered, 
PT.FName, PT.LName, PT.MName, PT.ProductID, PT.ProductDescription, PT.ProductType, 
P.ProductName, 
(CASE WHEN CP.ImportsAtBaseOrSales=0 THEN CP.SalesPrice ELSE PT.ProductPrice END) 
	AS ProductPrice, PT.ExternalInvoiceNumber, PT.SalesRep, PT.ClientID,
C.ClientName,CP.IncludeOnInvoice
FROM ProductTransactions PT
INNER JOIN Products P
	ON PT.ProductID=P.ProductID
INNER JOIN Clients C
	ON C.ClientID=PT.ClientID	
INNER JOIN ClientProducts CP
		ON CP.ClientID=PT.ClientID
		AND CP.ProductID=PT.ProductID	
WHERE NOT EXISTS (SELECT 1 FROM ProductsOnInvoice POI WHERE POI.ProductTransactionID=PT.ProductTransactionID)
AND (@ClientID=0 OR C.ClientID=@ClientID)

END
ELSE IF (@Status=2)
BEGIN

--Invoiced Transactions
SELECT PT.ProductTransactionID, PT.FileNum, PT.OrderBy, PT.Reference, PT.TransactionDate, PT.DateOrdered, 
PT.FName, PT.LName, PT.MName, PT.ProductID, PT.ProductDescription, PT.ProductType, 
P.ProductName, 
(CASE WHEN CP.ImportsAtBaseOrSales=0 THEN CP.SalesPrice ELSE PT.ProductPrice END) 
	AS ProductPrice, PT.ExternalInvoiceNumber, PT.SalesRep, PT.ClientID,
C.ClientName,CP.IncludeOnInvoice
FROM ProductTransactions PT
INNER JOIN ProductsOnInvoice POI
	ON PT.ProductTransactionID=POI.ProductTransactionID
INNER JOIN Invoices I
	ON POI.InvoiceID=I.InvoiceID
INNER JOIN Products P
	ON PT.ProductID=P.ProductID
INNER JOIN Clients C
	ON C.ClientID=PT.ClientID
INNER JOIN ClientProducts CP
		ON CP.ClientID=PT.ClientID
		AND CP.ProductID=PT.ProductID
WHERE I.VoidedOn IS NULL
AND (@ClientID=0 OR C.ClientID=@ClientID)
END
ELSE IF (@Status=3)
BEGIN

--UnInvoiced Transactions
SELECT PT.ProductTransactionID, PT.FileNum, PT.OrderBy, PT.Reference, PT.TransactionDate, PT.DateOrdered, 
PT.FName, PT.LName, PT.MName, PT.ProductID, PT.ProductDescription, PT.ProductType, 
P.ProductName, 
(CASE WHEN CP.ImportsAtBaseOrSales=0 THEN CP.SalesPrice ELSE PT.ProductPrice END) 
	AS ProductPrice, PT.ExternalInvoiceNumber, PT.SalesRep, PT.ClientID,
C.ClientName,CP.IncludeOnInvoice
FROM ProductTransactions PT
LEFT JOIN ProductsOnInvoice POI
	ON PT.ProductTransactionID=POI.ProductTransactionID
INNER JOIN Products P
	ON PT.ProductID=P.ProductID
INNER JOIN Clients C
	ON C.ClientID=PT.ClientID
INNER JOIN ClientProducts CP
		ON CP.ClientID=PT.ClientID
		AND CP.ProductID=PT.ProductID
WHERE (@ClientID=0 OR C.ClientID=@ClientID)
AND PT.Invoiced=0
AND (CASE
	WHEN CP.IncludeOnInvoice = 2 AND ((CP.ImportsAtBaseOrSales=0 AND ISNULL(CP.SalesPrice,0) = 0) OR (CP.ImportsAtBaseOrSales=1 AND ISNULL(PT.ProductPrice,0) = 0)) THEN 0
	WHEN CP.IncludeOnInvoice = 2 AND ((CP.ImportsAtBaseOrSales=0 AND ISNULL(CP.SalesPrice,0) > 0) OR (CP.ImportsAtBaseOrSales=1 AND ISNULL(PT.ProductPrice,0) > 0)) THEN 1
	WHEN CP.IncludeOnInvoice = 0 THEN 1 
	WHEN (CP.IncludeOnInvoice = 1 AND CP.ImportsAtBaseOrSales=0 AND ISNULL(CP.SalesPrice,0) > 0) THEN 1 
    WHEN (CP.IncludeOnInvoice = 1 AND CP.ImportsAtBaseOrSales=1 AND ISNULL(PT.ProductPrice,0) > 0) THEN 1
    ELSE 0 END = 1)
END
GO
