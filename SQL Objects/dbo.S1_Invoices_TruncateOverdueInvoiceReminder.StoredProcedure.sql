/****** Object:  StoredProcedure [dbo].[S1_Invoices_TruncateOverdueInvoiceReminder]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_TruncateOverdueInvoiceReminder]
AS
BEGIN
    --Exec S1_Invoices_TruncateOverdueInvoiceReminder
	;truncate table FinanceChargeEmailCurrentRun
END


GO
