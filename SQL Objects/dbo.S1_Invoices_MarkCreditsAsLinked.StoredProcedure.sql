/****** Object:  StoredProcedure [dbo].[S1_Invoices_MarkCreditsAsLinked]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_MarkCreditsAsLinked

CREATE PROCEDURE [dbo].[S1_Invoices_MarkCreditsAsLinked]
AS
	SET NOCOUNT ON;

UPDATE QBLC 
SET Linked=1 
FROM QBExportLinkCredits QBLC INNER JOIN Invoices I ON I.InvoiceID=QBLC.CreditInvoiceID
WHERE Linked=0 AND I.RelatedInvoiceID IS NOT NULL
GO
