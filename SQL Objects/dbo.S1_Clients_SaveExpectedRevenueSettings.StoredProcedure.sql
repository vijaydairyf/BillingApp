/****** Object:  StoredProcedure [dbo].[S1_Clients_SaveExpectedRevenueSettings]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_SaveExpectedRevenueSettings]
(
	@ClientID int,
	@ExpectedMonthlyRevenue money, 
	@AccountCreateDate datetime, 
	@AccountOwner varchar(500), 
	@AffiliateName varchar(500)
)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @CountOfClientExpectedRevenue INT;
	SELECT @CountOfClientExpectedRevenue = COUNT(*) FROM ClientExpectedRevenue WHERE ClientID=@ClientID
	
	IF (@CountOfClientExpectedRevenue < 1)
	BEGIN
	
		INSERT INTO ClientExpectedRevenue (ClientID, ExpectedMonthlyRevenue, AccountCreateDate, AccountOwner, AffiliateName)
		VALUES (@ClientID, @ExpectedMonthlyRevenue, @AccountCreateDate, @AccountOwner, @AffiliateName)
	
	END
	ELSE
	BEGIN
	
		UPDATE ClientExpectedRevenue
		SET ExpectedMonthlyRevenue = @ExpectedMonthlyRevenue,
		AccountCreateDate = @AccountCreateDate,
		AccountOwner = @AccountOwner,
		AffiliateName = @AffiliateName
		WHERE ClientID=@ClientID
	
	END

END

GO
