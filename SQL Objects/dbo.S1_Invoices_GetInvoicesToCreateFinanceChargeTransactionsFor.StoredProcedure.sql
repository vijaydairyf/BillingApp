/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetInvoicesToCreateFinanceChargeTransactionsFor]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--EXEC S1_Invoices_GetInvoicesToCreateFinanceChargeTransactionsFor '01/31/2012'

CREATE PROCEDURE [dbo].[S1_Invoices_GetInvoicesToCreateFinanceChargeTransactionsFor]
(
	@FinanceChargeDate datetime
)
AS
	SET NOCOUNT ON;

SELECT A1.InvoiceID, A1.InvoiceNumber, A1.ClientID, A1.ClientName, A1.InvoiceDate, A1.OriginalInvoiceAmount,
A1.OriginalInvoiceAmount - A1.CreditAmount - SUM(ISNULL(B1.PaymentsAmount,0)) as InvoiceAmountDue, 
A1.CreditAmount, SUM(ISNULL(B1.PaymentsAmount,0)) as PaymentAmount,
CASE WHEN ROUND((A1.OriginalInvoiceAmount - A1.CreditAmount - SUM(ISNULL(B1.PaymentsAmount,0))) * A1.FinanceChargePercent,2) < 1 THEN
1
ELSE
ROUND((A1.OriginalInvoiceAmount - A1.CreditAmount - SUM(ISNULL(B1.PaymentsAmount,0))) * A1.FinanceChargePercent,2)
END
as FinanceChargeAmount
FROM
(
SELECT I.InvoiceID, I.InvoiceNumber as InvoiceNumber, C.ClientID, C.ClientName, I.InvoiceDate, 
I.Amount as OriginalInvoiceAmount, 
SUM(ISNULL(I2.Amount,0)) as CreditAmount,
CIS.FinanceChargePercent
FROM Invoices I 
INNER JOIN Clients C 
	ON I.ClientID=C.ClientID
INNER JOIN ClientInvoiceSettings CIS
	ON I.ClientID=CIS.ClientID
LEFT JOIN Invoices I2
	ON I2.RelatedInvoiceID=I.InvoiceID
	AND I2.InvoiceTypeID=3
	--AND I2.Amount < I.Amount
WHERE I.InvoiceTypeID=1 --Only pull invoices
AND I.VoidedOn IS NULL
AND I.Amount>0
AND CIS.ApplyFinanceCharge=1
AND CIS.SentToCollections=0
AND I.InvoiceDate<=DateAdd(day,0 - CIS.FinanceChargeDays,@FinanceChargeDate)
AND I.InvoiceDate>DateAdd(day,(0 - CIS.FinanceChargeDays) - 90,@FinanceChargeDate)
AND NOT EXISTS (SELECT 1 FROM Invoices FI WHERE FI.InvoiceTypeID=2 
	AND FI.RelatedInvoiceID=I.InvoiceID
	AND FI.InvoiceDate = @FinanceChargeDate 
	)
AND I.InvoiceID NOT IN (SELECT CAST(Reference as int) as InvoiceID 
						FROM ProductTransactions 
						WHERE ProductID=372 --Finance Charges
							AND TransactionDate=@FinanceChargeDate
							AND ClientID = C.ClientID)
GROUP BY I.InvoiceID, I.InvoiceNumber, C.ClientID, C.ClientName, I.InvoiceDate, 
I.Amount, CIS.FinanceChargePercent
) A1
LEFT JOIN 
	(SELECT IP2.InvoiceID, IP2.Amount as PaymentsAmount, P2.[Date] 
		FROM InvoicePayments IP2
		INNER JOIN Payments P2 
			ON P2.PaymentID=IP2.PaymentID 
		WHERE [Date] <= @FinanceChargeDate --Only include payments made before or on the Finance Charge date 
	) B1
	ON B1.InvoiceID=A1.InvoiceID
	
GROUP BY A1.InvoiceID, A1.InvoiceNumber, A1.ClientID, A1.ClientName, A1.InvoiceDate, 
A1.OriginalInvoiceAmount, A1.CreditAmount, A1.FinanceChargePercent
HAVING A1.OriginalInvoiceAmount - A1.CreditAmount - SUM(ISNULL(B1.PaymentsAmount,0))>0
ORDER BY A1.ClientName,A1.ClientID



GO
