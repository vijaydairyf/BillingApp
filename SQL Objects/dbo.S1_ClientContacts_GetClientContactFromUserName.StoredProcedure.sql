/****** Object:  StoredProcedure [dbo].[S1_ClientContacts_GetClientContactFromUserName]    Script Date: 11/18/2016 5:02:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[S1_ClientContacts_GetClientContactFromUserName]
	@UserName varchar(max)
AS
BEGIN
--EXEC S1_ClientContacts_GetClientContactFromUserName ''
SET NOCOUNT ON;
	
SELECT TOP 1 CC.ClientContactID,
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
case when BillingContactID is null then 0 else 1 end as IsBillingContact,
ISNULL(convert(varchar, AM.LastLoginDate, 101), 'Never') as LastLoginDate,
C.BillAsClientName,
C.DueText,
CC.ContactStatus as ClientContactStatus,
ISNULL(BC.BillingContactStatus, 0) as BillingContactStatus,
AU.UserName as LoginUserName
FROM ClientContacts CC
INNER JOIN Clients C
	ON C.ClientID=CC.ClientID
INNER JOIN Users U
	ON CC.UserID=U.UserID
INNER JOIN aspnet_Membership AM
	ON AM.UserId = U.UserGUID
INNER JOIN aspnet_Users AU
	ON AU.UserId = U.UserGUID
LEFT JOIN  BillingContacts BC
	ON BC.ClientContactID=CC.ClientContactID
WHERE AU.UserName = @UserName

END