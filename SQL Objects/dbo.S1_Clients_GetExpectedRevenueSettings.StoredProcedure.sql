/****** Object:  StoredProcedure [dbo].[S1_Clients_GetExpectedRevenueSettings]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_GetExpectedRevenueSettings]
	@ClientID int
AS
BEGIN
	SET NOCOUNT ON;

SELECT CER.ClientExpectedRevenueID, CER.ClientID, CER.ExpectedMonthlyRevenue, CER.AccountCreateDate, CER.AccountOwner, CER.AffiliateName
FROM ClientExpectedRevenue CER
WHERE ClientID=@ClientID

END
GO
