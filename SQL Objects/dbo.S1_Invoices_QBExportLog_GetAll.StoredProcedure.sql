/****** Object:  StoredProcedure [dbo].[S1_Invoices_QBExportLog_GetAll]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec S1_Invoices_QBExportLog_GetAll

CREATE PROCEDURE [dbo].[S1_Invoices_QBExportLog_GetAll]
AS
SET NOCOUNT ON;

SELECT QBExportLogID, ExportStep, ExportTime, 
CONVERT(char(10),ExportTime,101) + ' ' + CONVERT(char(10),ExportTime,108) as ExportTimeString 
FROM QBExportLog 
WHERE ExportTime >= Convert(datetime, DATEDIFF(dd, 5, getdate()))
ORDER BY QBExportLogID DESC
GO
