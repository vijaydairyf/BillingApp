/****** Object:  StoredProcedure [dbo].[S1_Clients_GetPrimaryBillingContactIDForClient]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_Clients_GetPrimaryBillingContactForClient

CREATE PROCEDURE [dbo].[S1_Clients_GetPrimaryBillingContactIDForClient]
(
	@ClientID int
)
AS
	SET NOCOUNT ON;
	
SELECT TOP 1 BillingContactID as BillingContactID
FROM BillingContacts BC
WHERE BC.ClientID=@ClientID
  AND BC.IsPrimaryBillingContact = 1


GO
