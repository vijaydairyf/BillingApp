/****** Object:  StoredProcedure [dbo].[S1_Clients_GetClientInvoiceSettings]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_GetClientInvoiceSettings]
	@ClientID int
AS
BEGIN
	SET NOCOUNT ON;
    --EXEC S1_Clients_GetClientInvoiceSettings 2

SELECT ClientInvoiceSettingsID, ClientID, InvoiceTemplateID, SplitByMode, ReportGroupID, HideSSN, ApplyFinanceCharge,
       FinanceChargeDays, FinanceChargePercent, SentToCollections, ExcludeFromReminders
FROM ClientInvoiceSettings
WHERE ClientID=@ClientID

END


GO
