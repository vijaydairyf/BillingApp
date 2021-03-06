/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetPendingReleaseInvoiceGroup]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_Invoices_GetPendingReleaseInvoiceGroup 52288

CREATE PROCEDURE [dbo].[S1_Invoices_GetPendingReleaseInvoiceGroup]
(
	@InvoiceID int
)
AS
	SET NOCOUNT ON;
	
	SELECT DISTINCT IBC2.InvoiceID, I2.InvoiceNumber, 
	 C2.ClientName + '; ' + ISNULL(BC2.ContactName,'Attn: Accounts Payable') as Contact, 
	 RS2.ReleasedStatusText 
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
	INNER JOIN ReleasedStatus RS2
		ON RS2.ReleasedStatusID=I2.Released
	INNER JOIN Clients C2
		ON C2.ClientID=I2.ClientID
	WHERE I.InvoiceID=@InvoiceID AND I2.VoidedOn IS NULL
	AND I2.Released IN (0,4)
	AND I2.InvoiceTypeID=1
GO
