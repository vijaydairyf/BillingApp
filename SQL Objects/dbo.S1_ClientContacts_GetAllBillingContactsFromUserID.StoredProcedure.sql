/****** Object:  StoredProcedure [dbo].[S1_ClientContacts_GetAllBillingContactsFromUserID]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_ClientContacts_GetAllBillingContactsFromUserID 2

CREATE PROCEDURE [dbo].[S1_ClientContacts_GetAllBillingContactsFromUserID]
(
	@UserID int
)
AS
	SET NOCOUNT ON;
	
SELECT C.ClientName, CC.ClientContactID,
ISNULL(CC.ContactFirstName + ' ' + CC.ContactLastName,'[Accounts Payable]') as ClientContactName,
CC.ContactFirstName as ClientContactFirstName,
CC.ContactLastName as ClientContactLastName, 
CC.ContactTitle as ClientContactTitle,
CC.ContactAddr1 as ClientContactAddress1,
CC.ContactAddr2 as ClientContactAddress2,
CC.ContactCity as ClientContactCity,
CC.ContactStateCode as ClientContactStateCode,
CC.ContactZIP as ClientContactZIP,
CC.ContactBusinessPhone as ClientContactBusinessPhone,
CC.ContactCellPhone as ClientContactCellPhone,
CC.ContactFax as ClientContactFax,
CC.ContactEmail as ClientContactEmail,
ISNULL(BC.BillingContactID,0) as BillingContactID,
ISNULL(BC.ContactName,'') as BillingContactName,
ISNULL(BC.ContactAddress1,'') as BillingContactAddress1,
ISNULL(BC.ContactAddress2,'') as BillingContactAddress2,
ISNULL(BC.ContactCity,'') as BillingContactCity,
ISNULL(BC.ContactStateCode,'') as BillingContactStateCode,
ISNULL(BC.ContactZIP,'') as BillingContactZIP,
ISNULL(BC.ContactEmail, '') as BillingContactEmail,
ISNULL(BC.ContactPhone,'') as BillingContactBusinessPhone,
ISNULL(BC.ContactFax,'') as BillingContactFax,
ISNULL(BC.POName,'') as BillingContactPOName,
ISNULL(BC.PONumber,'') as BillingContactPONumber,
ISNULL(BC.Notes,'') as BillingContactNotes,
case BC.DeliveryMethod when 0 then 'Online' when 1 then 'Email-Auto' when 2 then 'Email-Manual' when 3 then 'Mail Only' else 'UnAssigned' end as BillingDeliveryMethod,
ISNULL(BC.IsPrimaryBillingContact,0) as IsPrimaryBillingContact1,
ISNULL(BC.OnlyShowInvoices, 1) as OnlyShowInvoices,
ISNULL(U.UserFirstName,'') as UserFirstName,
ISNULL(U.UserLastName,'') as UserLastName,
CC.ClientID,
CC.UserID,
ISNULL(convert(varchar, AM.LastLoginDate, 101), 'Never') as LastLoginDate
FROM ClientContacts CC
INNER JOIN Clients C
	ON C.ClientID=CC.ClientID
INNER JOIN  BillingContacts BC
	ON BC.ClientContactID=CC.ClientContactID
LEFT JOIN Users U
	ON CC.UserID=U.UserID
LEFT JOIN aspnet_Membership AM
	ON AM.UserId = U.UserGUID
WHERE CC.UserID=@UserID

GO
