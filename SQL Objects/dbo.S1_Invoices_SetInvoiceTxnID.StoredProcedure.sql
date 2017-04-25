/****** Object:  StoredProcedure [dbo].[S1_Invoices_SetInvoiceTxnID]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_SetInvoiceTxnID]
(
	@InvoiceNumber varchar(50),
	@QBTransactionID varchar(50)
)
AS
SET NOCOUNT ON;

UPDATE Invoices SET QBTransactionID=@QBTransactionID WHERE InvoiceNumber=@InvoiceNumber
GO
