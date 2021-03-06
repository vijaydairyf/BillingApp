/****** Object:  StoredProcedure [dbo].[S1_Clients_GetBillingContactsForClient]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_Clients_GetBillingContactsForClient 

CREATE PROCEDURE [dbo].[S1_Clients_GetBillingContactsForClient]
(
	@ClientID int
)
AS
	SET NOCOUNT ON;
	
SELECT BillingContactID as Value, 
ISNULL(ISNULL(BC.ContactName, CC.ContactFirstName + ' ' + CC.ContactLastName),'[Accounts Payable]') 
+ '; ' + BC.ContactAddress1 as [Text] 
FROM ClientContacts CC
INNER JOIN BillingContacts BC
	ON CC.ClientContactID=BC.ClientContactID
WHERE CC.ClientID=@ClientID
ORDER BY BC.ContactName

GO
