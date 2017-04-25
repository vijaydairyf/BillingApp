/****** Object:  StoredProcedure [dbo].[S1_Invoices_QBExportLog_AddNextStep]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_QBExportLog_AddNextStep]
(
	@NextExportStep int
)
AS
SET NOCOUNT ON;

INSERT INTO QBExportLog (ExportStep, ExportTime) VALUES (@NextExportStep, GETDATE())
GO
