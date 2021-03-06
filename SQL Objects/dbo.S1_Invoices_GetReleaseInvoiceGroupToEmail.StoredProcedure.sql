/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetReleaseInvoiceGroupToEmail]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC S1_Invoices_GetReleaseInvoiceGroupToEmail 67493
EXEC S1_Invoices_GetReleaseInvoiceGroupToEmail 67494
EXEC S1_Invoices_GetReleaseInvoiceGroupToEmail 59717
60176	886
60179	1013
60191	1368
60192	1393
60208	2597
60213	2782

*/

CREATE PROCEDURE [dbo].[S1_Invoices_GetReleaseInvoiceGroupToEmail] (
	@InvoiceID int
)
AS
	SET NOCOUNT ON;
	
	DECLARE @tmp_Invoices TABLE (
	InvoiceID int
)

INSERT INTO @tmp_Invoices (InvoiceID) VALUES (@InvoiceID)

INSERT INTO @tmp_Invoices (InvoiceID)
SELECT DISTINCT IBC2.InvoiceID
	FROM Invoices I
	INNER JOIN InvoiceBillingContacts IBC
		ON I.InvoiceID=IBC.InvoiceID
	INNER JOIN BillingContacts BC
		ON BC.BillingContactID=IBC.BillingContactID
	INNER JOIN ClientContacts C
		ON C.ClientContactID=BC.ClientContactID
	INNER JOIN ClientContacts C2
		ON C2.UserID=C.UserID
	INNER JOIN BillingContacts BC2
		ON BC2.ClientContactID=C2.ClientContactID
	INNER JOIN InvoiceBillingContacts IBC2
		ON IBC2.BillingContactID=BC2.BillingContactID
	INNER JOIN Invoices I2
		ON I2.InvoiceID=IBC2.InvoiceID
	WHERE I.InvoiceID=@InvoiceID
	AND IBC2.InvoiceID<>@InvoiceID
	AND I2.Released IN (0,4)
	AND BC2.DeliveryMethod IN (0)
	AND I2.VoidedOn IS NULL	
	AND I2.InvoiceTypeID=1
	
	--SELECT * FROM @tmp_Invoices 
	
	DECLARE @ClientID int
	
	SELECT @ClientID=ClientID FROM Invoices WHERE InvoiceID=@InvoiceID
	
	SELECT DISTINCT CC.UserID, BC.ContactEmail, IBC.IsPrimaryBillingContact
	FROM @tmp_Invoices TI 
	INNER JOIN InvoiceBillingContacts IBC 
		ON TI.InvoiceID=IBC.InvoiceID
	INNER JOIN BillingContacts BC
		ON BC.BillingContactID=IBC.BillingContactID
	INNER JOIN ClientContacts CC
		ON CC.ClientContactID=BC.ClientContactID	
	WHERE BC.DeliveryMethod  = 0
	/*UNION
	SELECT DISTINCT CC.UserID, BC.ContactEmail
	FROM ClientContacts CC INNER JOIN
	BillingContacts BC
	ON CC.ClientContactID = BC.ClientContactID
	WHERE BC.ClientID = @ClientID
	AND BC.IsPrimaryBillingContact=0*/
	
	/*
	SELECT DISTINCT CC2.UserID, BC2.ContactEmail
	FROM Invoices I
	INNER JOIN InvoiceBillingContacts IBC
		ON I.InvoiceID=IBC.InvoiceID
	INNER JOIN BillingContacts BC
		ON BC.BillingContactID=IBC.BillingContactID
	INNER JOIN ClientContacts CC
		ON CC.ClientContactID=BC.ClientContactID
	INNER JOIN ClientContacts CC2
		ON CC2.UserID=CC.UserID
	INNER JOIN BillingContacts BC2
		ON BC2.ClientContactID=CC2.ClientContactID
	INNER JOIN InvoiceBillingContacts IBC2
		ON IBC2.BillingContactID=BC2.BillingContactID
	INNER JOIN Invoices I2
		ON I2.InvoiceID=IBC2.InvoiceID
	INNER JOIN Clients C2
		ON I2.ClientID=C2.ClientID
	INNER JOIN Users u 
		ON u.UserID = CC2.UserID
	INNER JOIN aspnet_Membership am 
		ON am.UserId = u.UserGUID
	WHERE I.InvoiceID=@InvoiceID
	--AND IBC2.InvoiceID<>@InvoiceID
	AND BC2.DeliveryMethod IN (0)
	AND I2.VoidedOn IS NULL
	AND I2.Released IN (0,4)
	AND I2.InvoiceTypeID=1
	AND BC2.BillingContactStatus = 1
	AND am.IsApproved = 1
	
*/



GO
