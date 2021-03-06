/****** Object:  StoredProcedure [dbo].[S1_BillingStatement_GetBillingActivitywEmailLink]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_BillingStatement_GetBillingActivitywEmailLink 2924, 0
--EXEC S1_BillingStatement_GetBillingActivitywEmailLink 0, 21

CREATE PROCEDURE [dbo].[S1_BillingStatement_GetBillingActivitywEmailLink]
(
	@BillingContactID int,
	@UserID int
)
AS
	SET NOCOUNT ON;
	
DECLARE @tmp_BillingContacts TABLE
(
	BillingContactID int
)
	
IF (@BillingContactID=0)
BEGIN
	INSERT INTO @tmp_BillingContacts (BillingContactID)
	SELECT BC.BillingContactID
	FROM BillingContacts BC
	INNER JOIN ClientContacts CC
		ON BC.ClientContactID=CC.ClientContactID
	WHERE CC.UserID=@UserID
END
ELSE
BEGIN
	INSERT INTO @tmp_BillingContacts (BillingContactID) VALUES (@BillingContactID)
END

SELECT InvoiceDate as [Date], IT.InvoiceTypeDesc as [Type], InvoiceNumber, 
(CASE WHEN I.InvoiceTypeID=3 THEN 0 - Amount ELSE Amount END) as Amount,
(select top 1 'https://www.screeningone.com/BillingStatement/PrintPackageToPDF_Public/' + Convert(varchar(255), EmailGUID)
 from BillingPackagePrinted where BillingContactID = BC.BillingContactID and PackageEndDate = I.InvoiceDate)  as Link
FROM Invoices I INNER JOIN InvoiceTypes IT ON I.InvoiceTypeID=IT.InvoiceTypeID
INNER JOIN InvoiceBillingContacts IBC 
	ON IBC.InvoiceID=I.InvoiceID
INNER JOIN BillingContacts BC 
	ON BC.BillingContactID=IBC.BillingContactID
WHERE BC.BillingContactID IN (SELECT BillingContactID FROM @tmp_BillingContacts) 
AND VoidedOn IS NULL AND I.InvoiceTypeID<>2
AND I.Released>0
AND BC.HideFromClient=0

UNION ALL

SELECT I.InvoiceDate as [Date], IT.InvoiceTypeDesc as [Type], ISNULL(I2.InvoiceNumber,''), I.Amount,
'' as Link
FROM Invoices I 
INNER JOIN InvoiceTypes IT 
	ON I.InvoiceTypeID=IT.InvoiceTypeID
INNER JOIN InvoiceBillingContacts IBC 
	ON IBC.InvoiceID=I.InvoiceID
INNER JOIN BillingContacts BC 
	ON BC.BillingContactID=IBC.BillingContactID
LEFT JOIN Invoices I2
	ON I2.InvoiceID=I.RelatedInvoiceID
WHERE BC.BillingContactID IN (SELECT BillingContactID FROM @tmp_BillingContacts) 
AND I.VoidedOn IS NULL AND I.InvoiceTypeID=2
AND I.Released>0
AND BC.HideFromClient=0

UNION ALL

SELECT P.[Date] , 'Payment' as [Type], '' as InvoiceNumber, 0 - P.TotalAmount, '' as Link 
FROM Payments P
INNER JOIN BillingContacts BC ON BC.BillingContactID=P.BillingContactID
WHERE P.BillingContactID IN (SELECT BillingContactID FROM @tmp_BillingContacts) 
AND BC.HideFromClient=0

ORDER BY [Date] DESC, InvoiceNumber DESC


GO
