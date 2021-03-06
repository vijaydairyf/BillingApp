/****** Object:  StoredProcedure [dbo].[S1_Clients_CreateClientInvoiceSettings]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_CreateClientInvoiceSettings]
	@ClientID int,
	@InvoiceTemplateID int,
	@SplitByMode int,
	@ReportGroupID int,
	@HideSSN bit,
	@ApplyFinanceCharges bit,
	@FinChargeDays int,
	@FinChargePct decimal(4,3),
	@SentToCollections bit,
	@ExcludeFromReminders bit
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @CountOfClientInvoiceSettings int
	
	SELECT @CountOfClientInvoiceSettings=COUNT(*) FROM ClientInvoiceSettings WHERE ClientID=@ClientID
	
	--Only insert the row if there isn't already one for this client
	IF (@CountOfClientInvoiceSettings = 0)
	BEGIN
		INSERT INTO ClientInvoiceSettings (ClientID, InvoiceTemplateID, SplitByMode, ReportGroupID, HideSSN, 
					ApplyFinanceCharge, FinanceChargeDays, FinanceChargePercent, SentToCollections, ExcludeFromReminders)
		VALUES (@ClientID, @InvoiceTemplateID, @SplitByMode, @ReportGroupID, @HideSSN,
				@ApplyFinanceCharges, @FinChargeDays, @FinChargePct, @SentToCollections, @ExcludeFromReminders)
	END

END


GO
