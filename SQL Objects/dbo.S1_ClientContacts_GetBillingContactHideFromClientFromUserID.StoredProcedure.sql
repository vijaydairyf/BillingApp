/****** Object:  StoredProcedure [dbo].[S1_ClientContacts_GetBillingContactHideFromClientFromUserID]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_ClientContacts_GetBillingContactHideFromClientFromUserID 142

CREATE PROCEDURE [dbo].[S1_ClientContacts_GetBillingContactHideFromClientFromUserID]
(
	@UserID int
)
AS
	SET NOCOUNT ON;

SELECT TOP 1 BC.HideFromClient
FROM ClientContacts CC INNER JOIN BillingContacts BC ON CC.ClientContactID=BC.ClientContactID
WHERE CC.UserID=@UserID
ORDER BY BC.HideFromClient DESC

GO
