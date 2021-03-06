/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetReleaseInvoiceGroup]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_Invoices_GetReleaseInvoiceGroup 40200

CREATE PROCEDURE [dbo].[S1_Invoices_GetReleaseInvoiceGroup]
(
	@InvoiceID int
)
AS
	SET NOCOUNT ON;
	
	SELECT IBC2.InvoiceID, I2.Released 
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
	AND BC2.DeliveryMethod IN (0)
	AND I2.VoidedOn IS NULL
	AND I2.Released IN (0,4)
	AND I2.InvoiceTypeID=1
	
	

GO
