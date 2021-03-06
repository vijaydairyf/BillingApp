/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetExportInvoicesWithNullBillAsClientName]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_GetExportInvoicesWithNullBillAsClientName]
AS
	SET NOCOUNT ON;
	
	SELECT C.ClientName, C.BillAsClientName, I.InvoiceNumber 
	FROM Invoices I
	INNER JOIN Clients C
		ON I.ClientID=C.ClientID
	WHERE (C.BillAsClientName IS NULL OR C.BillAsClientName='') AND I.InvoiceExported=0
	AND I.VoidedOn IS NULL
	AND I.InvoiceTypeID=1

GO
