/****** Object:  StoredProcedure [dbo].[S1_Clients_GetClientListBySplitMode]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/************************************************
Test Script
DECLARE @SplitMode int
DECLARE @StartDate datetime
DECLARE @EndDate datetime
SELECT @SplitMode = 1
SET @StartDate = '03/01/2012'
SET @EndDate = '03/31/2012'

EXEC S1_Clients_GetClientListBySplitMode @SplitMode,@StartDate,@EndDate
*************************************************/
CREATE PROCEDURE [dbo].[S1_Clients_GetClientListBySplitMode]
	@SplitMode int,
	@StartDate datetime,
	@EndDate datetime
	
AS
	SET NOCOUNT ON;
   


DECLARE @tmp_Clients TABLE
(
	ClientID int
)

BEGIN



;with generalProductTransactionData as (
select PT.TransactionDate,
       ISNULL(PT.ProductPrice,0) as ProductPrice,
	   PT.ProductID,
	   PT.ClientID,
	   PT.Invoiced
  FROM ProductTransactions PT
  where PT.TransactionDate BETWEEN @StartDate AND @EndDate and
        PT.Invoiced=0
)
,generalClientProductTransactionData as (
select gPTD.*
  from generalProductTransactionData gPTD
       inner join Clients C on C.ClientID = gPTD.ClientID
  WHERE C.ClientID not in (select ClientID from InvoiceSplit)
        AND (C.ParentClientID is null or C.ParentClientID not in (select ClientID from ClientInvoiceSettings where SplitByMode = 2))
)
,generalClientProductsData as (
select CP.ClientID,
       CP.IncludeOnInvoice,
       CP.ImportsAtBaseOrSales,
       ISNULL(CP.SalesPrice,0) as SalesPrice,
	   PT.ProductPrice
  from generalClientProductTransactionData PT
	   INNER JOIN ClientProducts CP ON CP.ClientID=PT.ClientID
		                               AND CP.ProductID=PT.ProductID
  where not (CP.IncludeOnInvoice = 2 AND ((CP.ImportsAtBaseOrSales=0 AND ISNULL(CP.SalesPrice,0) = 0) OR (CP.ImportsAtBaseOrSales=1 AND PT.ProductPrice = 0)))
)
INSERT INTO @tmp_Clients
SELECT distinct CP.ClientID
	FROM generalClientProductsData CP
	WHERE (CP.IncludeOnInvoice = 2 AND ((CP.ImportsAtBaseOrSales=0 AND CP.SalesPrice > 0) OR (CP.ImportsAtBaseOrSales=1 AND CP.ProductPrice > 0))) 
	      or (CP.IncludeOnInvoice = 0) 
		  or (CP.IncludeOnInvoice = 1 AND CP.ImportsAtBaseOrSales=0 AND CP.SalesPrice > 0) 
		  or (CP.IncludeOnInvoice = 1 AND CP.ImportsAtBaseOrSales=1 AND CP.ProductPrice > 0)

	
SELECT C.ClientID,
CASE c.DoNotInvoice when 1 
	then C.ClientName + ' *' 
	else C.ClientName 
end as ClientName
FROM dbo.Clients C
--INNER JOIN BillingGroups BG
--	ON C.BillingGroup=BG.BillingGroupID
--INNER JOIN ProductTransactions PT 
--	ON PT.ClientID=C.ClientID
WHERE --PT.Invoiced = 0
/*AND*/ C.ClientID in (select ClientID from @tmp_Clients)
GROUP BY c.clientname, C.ClientID, C.DoNotInvoice
ORDER BY ClientName


/* Replacing with query above until we can come back and address special splits.
INSERT INTO @tmp_Clients
SELECT distinct C.ClientID
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
	WHERE PT.Invoiced=0
	AND PT.TransactionDate BETWEEN @StartDate AND @EndDate
	AND C.DoNotInvoice = 0
	AND (CASE
		WHEN CP.IncludeOnInvoice = 2 AND ((CP.ImportsAtBaseOrSales=0 AND ISNULL(CP.SalesPrice,0) = 0) OR (CP.ImportsAtBaseOrSales=1 AND ISNULL(PT.ProductPrice,0) = 0)) THEN 0
		WHEN CP.IncludeOnInvoice = 2 AND ((CP.ImportsAtBaseOrSales=0 AND ISNULL(CP.SalesPrice,0) > 0) OR (CP.ImportsAtBaseOrSales=1 AND ISNULL(PT.ProductPrice,0) > 0)) THEN 1
		WHEN CP.IncludeOnInvoice = 0 THEN 1 
		WHEN (CP.IncludeOnInvoice = 1 AND CP.ImportsAtBaseOrSales=0 AND ISNULL(CP.SalesPrice,0) > 0) THEN 1 
		WHEN (CP.IncludeOnInvoice = 1 AND CP.ImportsAtBaseOrSales=1 AND ISNULL(PT.ProductPrice,0) > 0) THEN 1
		ELSE 0 END = 1)
		
SELECT C.ClientID,C.ClientName,C.Address1,C.Address2,c.City, c.[State], c.ZipCode, 
c.ParentClientID, ISNULL(C2.ClientName,'') as ParentClientName,
C.BillAsClientName,BG.BillingGroupID,BG.BillingGroupName,C.[Status], case when sum(ClientBalances.TotalAmount) is null then 0 else sum(ClientBalances.TotalAmount) end as CurrentBalance
FROM dbo.Clients C
INNER JOIN BillingGroups BG
	ON C.BillingGroup=BG.BillingGroupID
INNER JOIN ClientInvoiceSettings CIS
	ON (C.ClientID=CIS.ClientID OR C.ParentClientID=CIS.ClientID)
INNER JOIN Clients C2
	ON C2.ClientID=C.ParentClientID
INNER JOIN (
	SELECT ClientID, SUM(Amount) as TotalAmount
	FROM (
	SELECT C.ClientID, BC.BillingContactID, InvoiceDate as [Date], IT.InvoiceTypeDesc as [Type], InvoiceNumber, 
	(CASE WHEN I.InvoiceTypeID=3 THEN 0 - Amount ELSE Amount END) as Amount,
	(CASE WHEN InvoiceDate>'7/31/2010' THEN 
		  (CASE WHEN I.InvoiceTypeID IN (3,5) THEN 0 ELSE I.InvoiceID END)
	ELSE 0 END) as LinkID
	FROM Invoices I INNER JOIN InvoiceTypes IT ON I.InvoiceTypeID=IT.InvoiceTypeID
	INNER JOIN InvoiceBillingContacts IBC 
		  ON IBC.InvoiceID=I.InvoiceID
	INNER JOIN BillingContacts BC 
		  ON BC.BillingContactID=IBC.BillingContactID AND IBC.IsPrimaryBillingContact=1
	INNER JOIN ClientContacts CC 
		  ON CC.ClientContactID=BC.ClientContactID
	INNER JOIN Clients C 
		  ON I.ClientID=C.ClientID
	WHERE VoidedOn IS NULL AND I.InvoiceTypeID<>2
	AND I.Released>0
	AND BC.HideFromClient=0
	 
	UNION ALL
	 
	SELECT C.ClientID, BC.BillingContactID, I.InvoiceDate as [Date], IT.InvoiceTypeDesc as [Type], ISNULL(I.InvoiceNumber,''), I.Amount,
	0 as LinkID
	FROM Invoices I 
	INNER JOIN InvoiceTypes IT 
		  ON I.InvoiceTypeID=IT.InvoiceTypeID
	INNER JOIN InvoiceBillingContacts IBC 
		  ON IBC.InvoiceID=I.InvoiceID
	INNER JOIN BillingContacts BC 
		  ON BC.BillingContactID=IBC.BillingContactID AND IBC.IsPrimaryBillingContact=1
	INNER JOIN ClientContacts CC 
		  ON CC.ClientContactID=BC.ClientContactID
	INNER JOIN Clients C 
		  ON I.ClientID=C.ClientID
	LEFT JOIN Invoices I2
		 ON I2.InvoiceID=I.RelatedInvoiceID
	WHERE I.VoidedOn IS NULL AND I.InvoiceTypeID=2
	AND I.Released>0
	AND BC.HideFromClient=0
	 
	UNION ALL
	 
	SELECT C.ClientID, BC.BillingContactID, P.[Date], 'Payment' as [Type], '' as InvoiceNumber, 0 - P.TotalAmount, 0 as LinkID 
	FROM Payments P
	INNER JOIN BillingContacts BC ON 
		  BC.BillingContactID=P.BillingContactID
	INNER JOIN ClientContacts CC 
		  ON CC.ClientContactID=BC.ClientContactID
	INNER JOIN Clients C 
		  ON CC.ClientID=C.ClientID
	WHERE BC.HideFromClient=0
	) A
	GROUP BY ClientID

) ClientBalances on ClientBalances.ClientID = C.ClientID
WHERE C.ClientID in (SELECT ClientID FROM @tmp_Clients)
GROUP BY C.ClientID,C.ClientName,C.Address1,C.Address2,c.City, c.[State], c.ZipCode, 
c.ParentClientID, C2.ClientName,C.BillAsClientName,BG.BillingGroupID,BG.BillingGroupName,C.[Status]
ORDER BY C.ClientName
*/
END





GO
