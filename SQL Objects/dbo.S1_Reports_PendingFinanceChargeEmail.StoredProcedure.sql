/****** Object:  StoredProcedure [dbo].[S1_Reports_PendingFinanceChargeEmail]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_Reports_PendingFinanceChargeEmail

CREATE PROCEDURE [dbo].[S1_Reports_PendingFinanceChargeEmail]

AS
	SET NOCOUNT ON;

	DECLARE @FinanceChargeDate datetime
	SET @FinanceChargeDate =  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)
	--SET @FinanceChargeDate = DATEADD(DD, 30, DateAdd(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))


	DECLARE @tmp_UnbalancedOverPaymentList TABLE
		(
			ClientID int,
			[Type] varchar(20)
		)
		
	INSERT INTO @tmp_UnbalancedOverPaymentList 
	EXEC S1_Invoices_GetClientsOnOverpaymentUnbalancedList
	
	
	DECLARE @tmp_FinanceChargeInvoices TABLE
	(
		InvoiceID int, 
		InvoiceNumber varchar(50),
		ClientID int,
		ClientName varchar(100),
		InvoiceDate datetime,
		OriginalInvoiceAmount money,
		InvoiceAmountDue money,
		CreditAmount money,
		PaymentAmount money,
		FinanceChargeAmount money
	)
		
	INSERT INTO @tmp_FinanceChargeInvoices
	EXEC S1_Invoices_GetInvoicesToCreateFinanceChargeTransactionsFor @FinanceChargeDate
	
	
	SELECT FC.*
	FROM @tmp_FinanceChargeInvoices FC
	INNER JOIN ClientInvoiceSettings CIS ON FC.ClientID = CIS.ClientID
	LEFT OUTER JOIN @tmp_UnbalancedOverPaymentList UO
		ON FC.ClientID = UO.ClientID
	WHERE UO.ClientID IS NULL
GO
