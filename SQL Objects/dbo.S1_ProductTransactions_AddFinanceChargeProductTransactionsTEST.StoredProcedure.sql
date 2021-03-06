/****** Object:  StoredProcedure [dbo].[S1_ProductTransactions_AddFinanceChargeProductTransactionsTEST]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC S1_ProductTransactions_AddFinanceChargeProductTransactions '02/28/2014','03/01/2014'

CREATE PROCEDURE [dbo].[S1_ProductTransactions_AddFinanceChargeProductTransactionsTEST]
(
	@FinanceChargeDate datetime,
	@RunDate datetime
)
AS
	SET NOCOUNT ON;
	
		DECLARE @FinanceChargeAssessDate datetime
		
		Set @FinanceChargeAssessDate = 	DATEADD(DD, 30, DATEADD(MONTH, DATEDIFF(MONTH, 0, @RunDate)-1, 0))

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
		EXEC S1_Invoices_GetInvoicesToCreateFinanceChargeTransactionsFor @FinanceChargeAssessDate
		
		DECLARE @ProductID int = 372
		DECLARE @VendorID int = 6
		DECLARE @TransactionDate datetime = @FinanceChargeDate
		DECLARE @DateOrdered datetime  = @RunDate
		DECLARE @OrderBy varchar(50) = NULL
		DECLARE @FileNum varchar(50)
		DECLARE @FName varchar(50) = NULL
		DECLARE @LName varchar(50) = NULL
		DECLARE @MName varchar(50) = NULL
		DECLARE @SSN varchar(50) = NULL
		DECLARE @ProductType varchar(50) = NULL
		
	
		DECLARE @ClientID int
		DECLARE @Reference varchar(50) -- id of the invoice that created the FC
		DECLARE @ProductDescription varchar(max)
		DECLARE @ProductPrice money -- the amount of the FC
		
		----User for testing same qry that the cursor uses
		--SELECT FC.ClientID,FC.InvoiceID,
		--'ProductDescription' = 'For Overdue Balance on Invoice: ' + FC.InvoiceNumber + ' - $' + convert(varchar, FC.OriginalInvoiceAmount),
		--FC.FinanceChargeAmount,'FileNum' = FC.InvoiceID
		--FROM @tmp_FinanceChargeInvoices FC
		--LEFT OUTER JOIN @tmp_UnbalancedOverPaymentList UO
		--	ON FC.ClientID = UO.ClientID
		--WHERE UO.ClientID IS NULL
		
		
		--Get all finance charges except for those clients who are on the unbalanced and/or overpayment list
		--DECLARE curFinCharges CURSOR for
		SELECT FC.ClientID,'Invoice: ' + FC.InvoiceNumber,
		'ProductDescription' = 'For Overdue Balance on Invoice: ' + FC.InvoiceNumber + ' - $' + convert(varchar, FC.OriginalInvoiceAmount),
		FC.FinanceChargeAmount,'FileNum' = FC.InvoiceNumber
		FROM @tmp_FinanceChargeInvoices FC
		LEFT OUTER JOIN @tmp_UnbalancedOverPaymentList UO
			ON FC.ClientID = UO.ClientID
		WHERE UO.ClientID IS NULL
				

GO
