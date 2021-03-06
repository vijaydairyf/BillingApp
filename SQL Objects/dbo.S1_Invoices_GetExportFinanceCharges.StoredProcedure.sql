/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetExportFinanceCharges]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[S1_Invoices_GetExportFinanceCharges]
AS
	SET NOCOUNT ON;

SELECT C.BillAsClientName, I.InvoiceNumber, I.InvoiceDate, I.Amount
FROM Invoices I
INNER JOIN Clients C
	ON I.ClientID=C.ClientID
WHERE I.InvoiceExported=0 AND C.BillAsClientName IS NOT NULL
AND I.VoidedOn IS NULL
AND I.Released>0
AND I.InvoiceTypeID=2

GO
