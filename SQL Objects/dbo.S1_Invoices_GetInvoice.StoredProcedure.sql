/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetInvoice]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_GetInvoice 121405

CREATE PROCEDURE [dbo].[S1_Invoices_GetInvoice]
(
	@InvoiceID int
)
AS
	SET NOCOUNT ON;


SELECT top 1 I.InvoiceID, I.ClientID, I.InvoiceNumber, I.InvoiceDate, I.Amount,
I.Col1Header, I.Col2Header, I.Col3Header, I.Col4Header, I.Col5Header, I.Col6Header, I.Col7Header, I.Col8Header, 
I.NumberOfColumns, I.BillTo, ISNULL(I.POName,'') as POName, ISNULL(I.PONumber,'') as PONumber,
I.BillingReportGroupID, I.DueText,
IT.InvoiceTypeDesc, BC.ContactName, BC.ContactAddress1, 
BC.ContactAddress2,
BC.ContactCity, BC.ContactStateCode, BC.ContactZIP, BC.ContactEmail, BC.ContactFax, 
BC.ContactPhone, BC.DeliveryMethod, C.ClientName,
C.ClientID, BC.BillingContactID, ISNULL(I.RelatedInvoiceID,0) as RelatedInvoiceID, C.BillingGroup
FROM Invoices I
INNER JOIN InvoiceBillingContacts IBC
	ON IBC.InvoiceID=I.InvoiceID
	AND IBC.IsPrimaryBillingContact=1
INNER JOIN BillingContacts BC
	ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN InvoiceTypes IT
	ON I.InvoiceTypeID=IT.InvoiceTypeID
INNER JOIN Clients C
	ON C.ClientID=I.ClientID
WHERE I.InvoiceID=@InvoiceID


GO
