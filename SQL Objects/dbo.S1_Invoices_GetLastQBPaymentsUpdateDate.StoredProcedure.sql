/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetLastQBPaymentsUpdateDate]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_GetLastQBPaymentsUpdateDate 

CREATE PROCEDURE [dbo].[S1_Invoices_GetLastQBPaymentsUpdateDate]
AS
	SET NOCOUNT ON;

SELECT MAX(DateAdd(dd, -3, ExportTime)) as LastUpdateDate FROM QBExportLog
WHERE ExportStep=0

--SELECT Convert(datetime, '2012-01-27 00:00:00.003') as LastUpdateDate 


GO
