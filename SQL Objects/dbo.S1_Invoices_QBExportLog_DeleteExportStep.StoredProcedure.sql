/****** Object:  StoredProcedure [dbo].[S1_Invoices_QBExportLog_DeleteExportStep]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_QBExportLog_DeleteExportStep]
(
	@ExportLogStepID int
)
AS
SET NOCOUNT ON;

DELETE FROM QBExportLog WHERE QBExportLogID = @ExportLogStepID
GO
