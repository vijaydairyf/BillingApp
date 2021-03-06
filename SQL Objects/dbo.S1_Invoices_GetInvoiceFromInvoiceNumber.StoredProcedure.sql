/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetInvoiceFromInvoiceNumber]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_GetInvoiceFromInvoiceNumber]
(
	@InvoiceNumber varchar(50),
	@BillingContactID int
)
AS
	SET NOCOUNT ON;
	
	SELECT TOP 1 I.InvoiceID, ClientID, InvoiceTypeID, InvoiceNumber, InvoiceDate, VoidedOn, VoidedByUser, Amount, NumberOfColumns, 
	Col1Header, Col2Header, Col3Header, Col4Header, Col5Header, Col6Header, Col7Header, Col8Header, CreateInvoicesBatchID, BillTo, 
	POName, PONumber, BillingReportGroupID, InvoiceExported, InvoiceExportedOn, DueText, RelatedInvoiceID, Released, 
	DontShowOnStatement
	FROM Invoices I INNER JOIN InvoiceBillingContacts IBC ON IBC.InvoiceID=I.InvoiceID
	WHERE InvoiceNumber=@InvoiceNumber
	AND IBC.BillingContactID=@BillingContactID
GO
