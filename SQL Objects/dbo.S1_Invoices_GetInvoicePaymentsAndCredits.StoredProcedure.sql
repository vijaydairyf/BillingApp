/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetInvoicePaymentsAndCredits]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_GetInvoicePaymentsAndCredits 60319

CREATE PROCEDURE [dbo].[S1_Invoices_GetInvoicePaymentsAndCredits] (
	@InvoiceID int
)
AS
	SET NOCOUNT ON;

/*
SELECT 0 - (SUM(ISNULL(CR.Amount,0)) + SUM(ISNULL(IP.Amount,0)))
as PaymentsAndCredits
FROM Invoices I
LEFT JOIN InvoicePayments IP
	ON IP.InvoiceID=I.InvoiceID
LEFT JOIN Invoices CR
	ON I.InvoiceID=CR.RelatedInvoiceID
	AND CR.InvoiceTypeID=3
WHERE I.InvoiceID=@InvoiceID
*/

DECLARE @CreditsAmount money
DECLARE @PaymentsAmount money

SELECT @CreditsAmount = SUM(ISNULL(CR.Amount,0)) 
FROM Invoices I
LEFT JOIN Invoices CR
	ON I.InvoiceID=CR.RelatedInvoiceID
	AND CR.InvoiceTypeID=3
WHERE I.InvoiceID=@InvoiceID
  and CR.VoidedOn is null

SELECT @PaymentsAmount = SUM(ISNULL(IP.Amount,0))
FROM Invoices I
LEFT JOIN InvoicePayments IP
	ON IP.InvoiceID=I.InvoiceID
WHERE I.InvoiceID=@InvoiceID

--SELECT @CreditsAmount
--SELECT @PaymentsAmount
SELECT 0-(@CreditsAmount+@PaymentsAmount) as PaymentsAndCredits

GO
