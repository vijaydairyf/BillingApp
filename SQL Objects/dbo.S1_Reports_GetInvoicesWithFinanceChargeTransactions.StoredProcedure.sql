/****** Object:  StoredProcedure [dbo].[S1_Reports_GetInvoicesWithFinanceChargeTransactions]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC S1_Reports_GetInvoicesWithFinanceChargeTransactions '12/01/2011','02/01/2012'

CREATE PROCEDURE [dbo].[S1_Reports_GetInvoicesWithFinanceChargeTransactions]
(
	@InvoiceDateStart datetime,
	@InvoiceDateEnd datetime
)
AS
	SET NOCOUNT ON;

SELECT I.InvoiceID, I.InvoiceNumber, C.ClientID, C.ClientName, I.InvoiceDate, 
'OriginalInvoiceAmount' = I.Amount,
'FinanceCharge' = IL.Amount,
'CreditAmount' = ISNULL((SELECT SUM(ISNULL(I2.Amount,0)) FROM Invoices I2 WHERE I2.RelatedInvoiceID=I.InvoiceID AND I2.InvoiceTypeID=3),0) ,
'Payments' = ISNULL((SELECT SUM(ISNULL(Amount,0)) FROM InvoicePayments WHERE InvoiceID = I.InvoiceID),0)
FROM Invoices I 
	INNER JOIN InvoiceLines IL
		ON I.InvoiceID = IL.InvoiceID
	INNER JOIN Clients C 
		ON I.ClientID=C.ClientID
WHERE I.InvoiceDate BETWEEN @InvoiceDateStart AND @InvoiceDateEnd
AND (Col1Text = 'FINANCE CHARGE' OR Col7Text LIKE ('For Overdue Balance on Invoice:%'))
GROUP BY I.InvoiceID, I.InvoiceNumber , C.ClientID, C.ClientName, I.InvoiceDate,I.Amount,IL.Amount



GO
