/****** Object:  StoredProcedure [dbo].[S1_Invoices_ModifyCredit]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_ModifyCredit]
(
	@InvoiceID int, --CreditID
	@InvoiceDate datetime,
	@InvoiceAmount money,
	@PublicDescription varchar(100),
	@PrivateDescription varchar(100),
	@BillingContactID int,
	@RelatedInvoiceID int
)
AS
	SET NOCOUNT ON;

UPDATE Invoices 
SET InvoiceDate=@InvoiceDate,
Amount=@InvoiceAmount,
Col1Header=@PublicDescription,
Col2Header=@PrivateDescription,
RelatedInvoiceID=@RelatedInvoiceID
WHERE InvoiceID=@InvoiceID

IF (@BillingContactID<>0)
BEGIN

UPDATE InvoiceBillingContacts
SET BillingContactID=@BillingContactID
WHERE InvoiceID=@InvoiceID
AND IsPrimaryBillingContact=1

END
GO
