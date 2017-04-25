/****** Object:  StoredProcedure [dbo].[S1_Invoices_QBExportLinkCredits_AddCredit]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_QBExportLinkCredits_AddCredit]
(
	@CreditInvoiceNumber varchar(50)
)
AS
SET NOCOUNT ON;

DECLARE @CreditInvoiceID int

SELECT TOP 1 @CreditInvoiceID=InvoiceID FROM Invoices WHERE InvoiceNumber=@CreditInvoiceNumber

INSERT INTO QBExportLinkCredits (CreditInvoiceID, Linked) VALUES (@CreditInvoiceID, 0)
GO
