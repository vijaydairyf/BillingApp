/****** Object:  StoredProcedure [dbo].[S1_Invoices_QBExportLog_GetLastStep]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_QBExportLog_GetLastStep]
AS
SET NOCOUNT ON;

SELECT TOP 1 ExportStep, ExportTime FROM QBExportLog
ORDER BY ExportTime DESC
GO
