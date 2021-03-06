/****** Object:  StoredProcedure [dbo].[S1_ClientContacts_GetBillingContactsFromClientID]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[S1_ClientContacts_GetBillingContactsFromClientID]
(
	@ClientID int
)
AS
	SET NOCOUNT ON;
	
SELECT ISNULL(CC.ContactFirstName + ' ' + CC.ContactLastName,'[Accounts Payable]') as ClientContactName,
ISNULL(BC.BillingContactID, 0) as BillingContactID
FROM ClientContacts CC
INNER JOIN Clients C
	ON C.ClientID=CC.ClientID
INNER JOIN Users U
	ON CC.UserID=U.UserID
INNER JOIN aspnet_Membership AM
	ON AM.UserId = U.UserGUID
INNER JOIN  BillingContacts BC
	ON BC.ClientContactID=CC.ClientContactID
WHERE CC.ClientID=@ClientID
  AND BC.IsPrimaryBillingContact = 0

GO
