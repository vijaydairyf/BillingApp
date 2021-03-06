/****** Object:  StoredProcedure [dbo].[S1_BillingStatement_GetStatementEmail]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_BillingStatement_GetStatementEmail 146

CREATE PROCEDURE [dbo].[S1_BillingStatement_GetStatementEmail]
(
	@BillingContactID int
)
AS
	SET NOCOUNT ON;

SELECT c.ClientName, am.LoweredEmail, u.UserID
FROM Clients c 
inner join ClientContacts cc on cc.ClientID = c.clientid
inner join BillingContacts bc on bc.clientcontactid = cc.ClientContactID
inner join Users u on u.UserID = cc.UserID
inner join aspnet_Membership am on am.UserId = u.UserGUID
WHERE bc.BillingContactID = @billingcontactid


GO
