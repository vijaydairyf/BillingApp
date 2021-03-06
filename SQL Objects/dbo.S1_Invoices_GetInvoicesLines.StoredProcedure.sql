/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetInvoicesLines]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_GetInvoicesLines 2

CREATE PROCEDURE [dbo].[S1_Invoices_GetInvoicesLines]
(
	@InvoiceID int
)
AS
	SET NOCOUNT ON;

SELECT IL.InvoiceLineNumber, IL.Col1Text, IL.Col2Text, IL.Col3Text, IL.Col4Text, IL.Col5Text, IL.Col6Text, 
IL.Col7Text, IL.Col8Text, IL.Amount
FROM InvoiceLines IL 
INNER JOIN Invoices I
	ON I.InvoiceID=IL.InvoiceID
WHERE I.InvoiceID=@InvoiceID
ORDER BY IL.InvoiceLineNumber
GO
