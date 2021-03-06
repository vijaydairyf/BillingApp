/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetInvoices_DateRange]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_GetInvoices_DateRange '1/1/2010', '12/31/2010', NULL, NULL, NULL

CREATE PROCEDURE [dbo].[S1_Invoices_GetInvoices_DateRange]
(
	@StartDate datetime,
	@EndDate datetime,
	@ClientIDFilter int,
	@BillingContactIDFilter int,
	@BillingContactAnyClient bit
)
AS
	SET NOCOUNT ON;	


SELECT I.InvoiceID, I.InvoiceNumber, I.InvoiceDate, I.InvoiceTypeID, IT.InvoiceTypeDesc,
I.Amount - ISNULL(P.PaymentAmount,0) - ISNULL(CreditAmount,0) as Amount, I.Amount as OriginalAmount, BC.BillingContactID, BC.ClientContactID, BC.ContactName,
C.ClientName, 
(CASE WHEN RS.ReleasedStatusID = 0 THEN RS.ReleasedStatusText
+ (CASE WHEN BC.DeliveryMethod=0 THEN '-Online'
WHEN BC.DeliveryMethod=1 THEN '-Email-Auto'
WHEN BC.DeliveryMethod=2 THEN '-Email-Manual'
WHEN BC.DeliveryMethod=3 THEN '-Mail'
ELSE '' END)
ELSE RS.ReleasedStatusText END) as ReleasedStatusText
FROM Invoices I
INNER JOIN InvoiceTypes IT
	ON IT.InvoiceTypeID=I.InvoiceTypeID
INNER JOIN Clients C
	ON I.ClientID=C.ClientID
INNER JOIN InvoiceBillingContacts IBC
	ON IBC.InvoiceID=I.InvoiceID
	AND IBC.IsPrimaryBillingContact=1
INNER JOIN BillingContacts BC
	ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ReleasedStatus RS
	ON I.Released=RS.ReleasedStatusID
LEFT JOIN (SELECT P1.InvoiceID, SUM(ISNULL(P1.Amount,0)) as PaymentAmount FROM InvoicePayments P1 GROUP BY P1.InvoiceID) P
	 ON I.InvoiceID=P.InvoiceID
LEFT JOIN (SELECT I1.RelatedInvoiceID, SUM(ISNULL(I1.Amount,0)) as CreditAmount FROM Invoices I1 WHERE I1.InvoiceTypeID=3 and I1.VoidedOn is null GROUP BY I1.RelatedInvoiceID) CR
	 ON I.InvoiceID=CR.RelatedInvoiceID
WHERE I.InvoiceDate BETWEEN @StartDate AND @EndDate
AND I.VoidedOn IS NULL
--If @BillingContactAnyClient = 1 Then don't filter by client
AND (C.ClientID=@ClientIDFilter OR @ClientIDFilter IS NULL OR @BillingContactAnyClient=1) 
AND (BC.BillingContactID=@BillingContactIDFilter OR @BillingContactIDFilter IS NULL)

UNION ALL

SELECT I.InvoiceID, I.InvoiceNumber, I.InvoiceDate, 0 as InvoiceTypeID, 'Void' as InvoiceTypeDesc,
0 as Amount, I.Amount as OriginalAmount, BC.BillingContactID, BC.ClientContactID, BC.ContactName,
C.ClientName, RS.ReleasedStatusText
FROM Invoices I
INNER JOIN InvoiceTypes IT
	ON IT.InvoiceTypeID=I.InvoiceTypeID
INNER JOIN Clients C
	ON I.ClientID=C.ClientID
INNER JOIN InvoiceBillingContacts IBC
	ON IBC.InvoiceID=I.InvoiceID
	AND IBC.IsPrimaryBillingContact=1
INNER JOIN BillingContacts BC
	ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ReleasedStatus RS
	ON I.Released=RS.ReleasedStatusID
WHERE I.InvoiceDate BETWEEN @StartDate AND @EndDate
AND I.VoidedOn IS NOT NULL
--If @BillingContactAnyClient = 1 Then don't filter by client
AND (C.ClientID=@ClientIDFilter OR @ClientIDFilter IS NULL OR @BillingContactAnyClient=1) 
AND (BC.BillingContactID=@BillingContactIDFilter OR @BillingContactIDFilter IS NULL)
GO
