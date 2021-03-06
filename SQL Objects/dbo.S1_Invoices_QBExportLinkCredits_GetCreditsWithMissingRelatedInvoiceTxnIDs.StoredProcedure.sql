/****** Object:  StoredProcedure [dbo].[S1_Invoices_QBExportLinkCredits_GetCreditsWithMissingRelatedInvoiceTxnIDs]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_QBExportLinkCredits_GetCreditsWithMissingRelatedInvoiceTxnIDs]
AS
SET NOCOUNT ON;

SELECT DISTINCT I2.InvoiceID,I2.InvoiceNumber
FROM Invoices I INNER JOIN Invoices I2 ON I.RelatedInvoiceID=I2.InvoiceID
WHERE I.InvoiceID IN (SELECT CreditInvoiceID FROM QBExportLinkCredits WHERE Linked=0)
AND I2.QBTransactionID IS NULL
GO
