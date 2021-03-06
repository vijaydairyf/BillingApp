/****** Object:  StoredProcedure [dbo].[S1_BillingStatement_GetBillingStatementListFromUser]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_BillingStatement_GetBillingStatementListFromUser 3343, '11/02/2013', '12/01/2013'

CREATE PROCEDURE [dbo].[S1_BillingStatement_GetBillingStatementListFromUser]
(
	@UserID int,
	@StartDate datetime,
	@EndDate datetime	
)
AS
	SET NOCOUNT ON;
	
SELECT A.ClientContactID, A.ClientName, A.ContactName, SUM(Amount) as Amount, PrimaryBillingContact,
@EndDate as StatementDate, A.BillingContactID
FROM
(

--Invoices, Finance Charges, Refunds - Current Period
SELECT CC.ClientContactID, C.ClientName, ISNULL(BC.ContactName,BC.ContactAddress1) as ContactName,
(CASE WHEN I.InvoiceTypeID=3 THEN 0 - I.Amount ELSE I.Amount END) as Amount, 
BC.IsPrimaryBillingContact as PrimaryBillingContact, BC.BillingContactID
FROM Invoices I INNER JOIN InvoiceTypes IT ON I.InvoiceTypeID=IT.InvoiceTypeID
INNER JOIN InvoiceBillingContacts IBC ON IBC.InvoiceID=I.InvoiceID
INNER JOIN BillingContacts BC ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ClientContacts CC ON CC.ClientContactID=BC.ClientContactID
INNER JOIN Clients C ON I.ClientID=C.ClientID
WHERE VoidedOn IS NULL AND I.InvoiceTypeID IN (5)
AND InvoiceDate BETWEEN @StartDate AND @EndDate
AND CC.UserID=@UserID
AND BC.HideFromClient=0
AND BC.OnlyShowInvoices=0
AND I.Released>0

UNION ALL
/*
--Payments - Current Period
SELECT CC.ClientContactID, C.ClientName, ISNULL(BC.ContactName,BC.ContactAddress1) as ContactName,
0 - IP.Amount as Amount ,BC.IsPrimaryBillingContact as PrimaryBillingContact, BC.BillingContactID
FROM Payments P INNER JOIN InvoicePayments IP ON P.PaymentID=IP.PaymentID
INNER JOIN Invoices I ON IP.InvoiceID=I.InvoiceID
INNER JOIN InvoiceBillingContacts IBC ON IBC.InvoiceID=I.InvoiceID
INNER JOIN BillingContacts BC ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ClientContacts CC ON CC.ClientContactID=BC.ClientContactID
INNER JOIN Clients C ON I.ClientID=C.ClientID
WHERE VoidedOn IS NULL
AND P.[Date] BETWEEN @StartDate AND @EndDate
AND CC.UserID=@UserID
AND BC.HideFromClient=0
AND BC.OnlyShowInvoices=0
AND I.Released>0
AND I.InvoiceTypeID<>4

UNION ALL

--Credits - Unrelated - Current Period
SELECT CC.ClientContactID, C.ClientName, ISNULL(BC.ContactName,BC.ContactAddress1) as ContactName,  
0 - I.Amount as Amount, BC.IsPrimaryBillingContact as PrimaryBillingContact, 
BC.BillingContactID
FROM Invoices I 
INNER JOIN InvoiceTypes IT 
	ON I.InvoiceTypeID=IT.InvoiceTypeID
INNER JOIN InvoiceBillingContacts IBC 
	ON IBC.InvoiceID=I.InvoiceID
INNER JOIN BillingContacts BC ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ClientContacts CC ON CC.ClientContactID=BC.ClientContactID
INNER JOIN Clients C ON I.ClientID=C.ClientID
WHERE I.VoidedOn IS NULL AND I.InvoiceTypeID=3
AND I.InvoiceDate BETWEEN @StartDate AND @EndDate
AND I.Released>0 
AND I.DontShowOnStatement=0
AND (I.RelatedInvoiceID=0 OR I.RelatedInvoiceID IS NULL)
AND CC.UserID=@UserID

UNION ALL

--Credits - Related - Current Period
SELECT CC.ClientContactID, C.ClientName, ISNULL(BC.ContactName,BC.ContactAddress1) as ContactName,  
0 - I.Amount as Amount, BC.IsPrimaryBillingContact as PrimaryBillingContact, 
BC.BillingContactID
FROM Invoices I 
INNER JOIN InvoiceTypes IT 
	ON I.InvoiceTypeID=IT.InvoiceTypeID
INNER JOIN InvoiceBillingContacts IBC 
	ON IBC.InvoiceID=I.InvoiceID
INNER JOIN BillingContacts BC 
	ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN Invoices I2
	ON I2.InvoiceID=I.RelatedInvoiceID
INNER JOIN ClientContacts CC ON CC.ClientContactID=BC.ClientContactID
INNER JOIN Clients C ON I.ClientID=C.ClientID
WHERE I.VoidedOn IS NULL AND I.InvoiceTypeID=3
AND (I2.InvoiceDate BETWEEN @StartDate AND @EndDate
OR I.InvoiceDate BETWEEN @StartDate AND @EndDate)
AND I.Released>0 
AND I.DontShowOnStatement=0
AND CC.UserID=@UserID

UNION ALL*/

--Invoices, Credits, and Finance Charges - Only show ones that aren't fully paid - Previous Period
SELECT ClientContactID, ClientName, ContactName, sum(Amount), PrimaryBillingContact, BillingContactID
from 
(
SELECT distinct a.InvoiceID, CC.ClientContactID, C.ClientName, ISNULL(A.ContactName,A.ContactAddress1) as ContactName,
A.Amount /*- A.CreditsAmount - SUM(ISNULL(B.PaymentsAmount,0))*/ as Amount, 
A.IsPrimaryBillingContact as PrimaryBillingContact, 
A.BillingContactID
FROM 
(
SELECT I.InvoiceID, I.InvoiceNumber, IT.InvoiceTypeDesc, 
I.Amount + 
	(select ISNULL(sum(amount), 0) from Invoices where RelatedInvoiceID = I.InvoiceID and InvoiceTypeID = 3 and VoidedOn Is NUll) -
	(select ISNULL(Sum(amount), 0) from InvoicePayments where InvoiceID = I.InvoiceID) as Amount , 
I.InvoiceTypeID,
I.InvoiceDate, BC.IsPrimaryBillingContact, BC.BillingContactID, BC.ContactName, BC.ContactAddress1,
BC.ClientContactID, BC.ClientID
FROM Invoices I 
INNER JOIN InvoiceTypes IT 
	ON I.InvoiceTypeID=IT.InvoiceTypeID
INNER JOIN InvoiceBillingContacts IBC 
	ON IBC.InvoiceID=I.InvoiceID
INNER JOIN BillingContacts BC 
	ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ClientContacts CC ON CC.ClientContactID=BC.ClientContactID
/*--Replaced these joins to fix unbalance issue on account activity screen 12/23/2013 DJT
LEFT JOIN 
	(SELECT I2.InvoiceID, I2.RelatedInvoiceID, I2.Amount, I2.InvoiceDate
		FROM Invoices I2
		WHERE I2.InvoiceDate < @EndDate --Only include payments in the previous period to lower the amount due
		AND I2.InvoiceTypeID=3
		) CR
		ON CR.RelatedInvoiceID=I.InvoiceID
LEFT JOIN (select I5.InvoiceID, SUM(i5.Amount) as SumAmount from InvoicePayments i5 group by i5.InvoiceID) pym on pym.InvoiceID = I.InvoiceID and I.Amount = pym.SumAmount and I.RelatedInvoiceID is null and I.InvoiceTypeID not in (2,3,4,5)
*/
WHERE CC.UserID=@UserID AND I.VoidedOn IS NULL
AND I.InvoiceDate <= @EndDate
AND I.Released>0
AND I.InvoiceTypeID IN (1, 5) --Don't include Credits as postive amounts
AND I.DontShowOnStatement=0
--AND pym.InvoiceID is null --12/23/2013 DJT
AND I.Amount <> (
(select isnull(sum(Amount), 0) from InvoicePayments where Invoiceid = I.InvoiceID) + (Select isnull(SUM(Amount), 0) from Invoices where relatedinvoiceid = I.InvoiceID and voidedon is null and invoicetypeid = 3)
)
GROUP BY I.InvoiceID, I.InvoiceNumber, I.InvoiceDate, I.InvoiceTypeID, IT.InvoiceTypeDesc, I.Amount,
BC.IsPrimaryBillingContact, BC.BillingContactID, BC.ContactName, BC.ContactAddress1,
BC.ClientContactID, BC.ClientID
) A
/* --12/23/2013 DJT Removed to fix balance issues
LEFT JOIN 
	(SELECT IP2.InvoiceID, IP2.Amount as PaymentsAmount, P2.[Date] 
		FROM InvoicePayments IP2
		INNER JOIN Payments P2 
			ON P2.PaymentID=IP2.PaymentID 
		WHERE [Date] >= @StartDate --Only include payments in the previous period to lower the amount due
	) B
	ON B.InvoiceID=A.InvoiceID
	*/
INNER JOIN ClientContacts CC ON CC.ClientContactID=A.ClientContactID
INNER JOIN Clients C ON A.ClientID=C.ClientID
GROUP BY A.InvoiceID, A.InvoiceNumber, A.InvoiceDate, A.InvoiceTypeID, A.InvoiceTypeDesc, A.Amount, 
/*A.CreditsAmount,*/ CC.ClientContactID, C.ClientName, A.ContactName, A.ContactAddress1, 
A.IsPrimaryBillingContact, A.BillingContactID
) B
Group By ClientContactID, ClientName, ContactName, PrimaryBillingContact, BillingContactID



UNION ALL 

--Overpayment Credit
SELECT CC.ClientContactID, C.ClientName, ISNULL(BC.ContactName,BC.ContactAddress1) as ContactName,
0 - (TotalAmount - (SELECT ISNULL(SUM(IP.Amount),0) FROM InvoicePayments IP WHERE IP.PaymentID=P.PaymentID)) 
as [Amount], 
BC.IsPrimaryBillingContact as PrimaryBillingContact, BC.BillingContactID
FROM Payments P
INNER JOIN BillingContacts BC ON BC.BillingContactID=P.BillingContactID
INNER JOIN ClientContacts CC ON CC.ClientContactID=BC.ClientContactID
INNER JOIN Clients C ON CC.ClientID=C.ClientID
WHERE CC.UserID=@UserID
AND BC.HideFromClient=0
AND BC.OnlyShowInvoices=0
AND TotalAmount - (SELECT ISNULL(SUM(IP.Amount),0) FROM InvoicePayments IP WHERE IP.PaymentID=P.PaymentID) > 0
AND NOT EXISTS (SELECT 1 FROM Invoices I INNER JOIN InvoiceBillingContacts IBC 
	ON IBC.InvoiceID=I.InvoiceID
	WHERE I.InvoiceTypeID=4 AND IBC.BillingContactID=BC.BillingContactID)
	
UNION ALL

--Credits - Unrelated - Previous Period
SELECT CC.ClientContactID, C.ClientName, ISNULL(BC.ContactName,BC.ContactAddress1) as ContactName,  
0 - I.Amount as Amount, BC.IsPrimaryBillingContact as PrimaryBillingContact, 
BC.BillingContactID
FROM Invoices I 
INNER JOIN InvoiceTypes IT 
	ON I.InvoiceTypeID=IT.InvoiceTypeID
INNER JOIN InvoiceBillingContacts IBC 
	ON IBC.InvoiceID=I.InvoiceID
INNER JOIN BillingContacts BC ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ClientContacts CC ON CC.ClientContactID=BC.ClientContactID
INNER JOIN Clients C ON I.ClientID=C.ClientID
WHERE I.VoidedOn IS NULL AND I.InvoiceTypeID=3
AND I.InvoiceDate < @StartDate
AND I.Released>0 
AND I.DontShowOnStatement=0
AND (I.RelatedInvoiceID=0 OR I.RelatedInvoiceID IS NULL)
AND NOT EXISTS (SELECT 1 FROM Invoices I INNER JOIN InvoiceBillingContacts IBC 
	ON IBC.InvoiceID=I.InvoiceID
	WHERE I.InvoiceTypeID=4 AND IBC.BillingContactID=BC.BillingContactID)
AND CC.UserID=@UserID

UNION ALL

--Beginning Balance
SELECT CC.ClientContactID, C.ClientName, ISNULL(BC.ContactName,BC.ContactAddress1) as ContactName,
MAX(I.Amount) - SUM(ISNULL(IP.Amount,0)) as Amount,
BC.IsPrimaryBillingContact as PrimaryBillingContact, BC.BillingContactID
FROM Invoices I INNER JOIN InvoiceTypes IT ON I.InvoiceTypeID=IT.InvoiceTypeID
INNER JOIN InvoiceBillingContacts IBC ON IBC.InvoiceID=I.InvoiceID
INNER JOIN BillingContacts BC ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ClientContacts CC ON CC.ClientContactID=BC.ClientContactID
INNER JOIN Clients C ON CC.ClientID=C.ClientID
LEFT JOIN (SELECT ISNULL(
	(TotalAmount - ISNULL((SELECT SUM(IP2.Amount) FROM InvoicePayments IP2 WHERE IP2.PaymentID=P2.PaymentID),0)) 
	,0) as Amount, P2.BillingContactID
	FROM Payments P2
	) IP
	ON IP.BillingContactID=BC.BillingContactID
WHERE VoidedOn IS NULL 
AND BC.HideFromClient=0
AND CC.UserID=@UserID
AND BC.OnlyShowInvoices=0
AND I.InvoiceTypeID=4
AND I.Released>0
GROUP BY CC.ClientContactID, C.ClientName, BC.ContactName,BC.ContactAddress1, 
BC.IsPrimaryBillingContact, BC.BillingContactID



) A
WHERE A.PrimaryBillingContact=1
GROUP BY A.ClientContactID, A.ClientName, A.ContactName, A.PrimaryBillingContact, A.BillingContactID
ORDER BY ClientName, ContactName
GO
