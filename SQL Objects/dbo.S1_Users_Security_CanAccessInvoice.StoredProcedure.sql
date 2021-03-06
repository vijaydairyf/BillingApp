/****** Object:  StoredProcedure [dbo].[S1_Users_Security_CanAccessInvoice]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Users_Security_CanAccessInvoice]
(
	@UserID int,
	@InvoiceID int
)
AS
	SET NOCOUNT ON;	

SELECT 1 FROM ClientContacts CC INNER JOIN BillingContacts BC
ON CC.ClientContactID=BC.ClientContactID
INNER JOIN InvoiceBillingContacts IBC
ON BC.BillingContactID=IBC.BillingContactID
WHERE CC.UserID=@UserID AND IBC.InvoiceID=@InvoiceID
GO
