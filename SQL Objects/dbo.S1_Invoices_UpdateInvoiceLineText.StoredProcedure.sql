/****** Object:  StoredProcedure [dbo].[S1_Invoices_UpdateInvoiceLineText]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_UpdateInvoiceLineText 2,1,'','','','','','','',''

CREATE PROCEDURE [dbo].[S1_Invoices_UpdateInvoiceLineText]
(
	@InvoiceID int,
	@InvoiceLineNumber int,
	@Col1Text varchar(max),
	@Col2Text varchar(max),
	@Col3Text varchar(max),
	@Col4Text varchar(max),
	@Col5Text varchar(max),
	@Col6Text varchar(max),
	@Col7Text varchar(max),
	@Col8Text varchar(max)
)
AS
	SET NOCOUNT ON;

UPDATE InvoiceLines 
SET Col1Text=@Col1Text,
Col2Text=@Col2Text,
Col3Text=@Col3Text,
Col4Text=@Col4Text,
Col5Text=@Col5Text,
Col6Text=@Col6Text,
Col7Text=@Col7Text,
Col8Text=@Col8Text
WHERE InvoiceID=@InvoiceID
AND InvoiceLineNumber=@InvoiceLineNumber


GO
