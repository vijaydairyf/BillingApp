/****** Object:  StoredProcedure [dbo].[S1_Invoices_CreateQuickBooksExportError]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_CreateQuickBooksExportError 'Test'

CREATE PROCEDURE [dbo].[S1_Invoices_CreateQuickBooksExportError]
(
	@ExportErrorText varchar(max)
)
AS
	SET NOCOUNT ON;

	INSERT INTO QuickBooksExportErrors (ErrorDateTime, ErrorText)
	VALUES (GETDATE(), @ExportErrorText)

GO
