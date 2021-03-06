/****** Object:  StoredProcedure [dbo].[S1_Reports_BillingContactDeliveryReport]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[S1_Reports_BillingContactDeliveryReport]
AS
BEGIN

--Exec S1_Reports_BillingContactDeliveryReport
select c.ClientName, 
       (select clientname from Clients where ClientID = c.parentclientid) as Parent,
       case isprimarybillingcontact 
	     when 0 then 'Secondary' 
		 else 'Primary' 
	   end as IsPrimary, 
	   u.UserFirstName, 
	   u.UserLastName, 
	   au.UserName, 
	   am.Email, 
	   am.CreateDate, 
	   am.LastLoginDate,
       case bc.deliverymethod 
	     when 0 then 'Online' 
		 when 1 then 'Email Auto' 
		 when 2 then 'Email Manual' 
		 when 3 then 'Mail Only' 
		 else 'Unknown' 
	   end as DeliveryMethod,
       bc.ContactName, 
	   bc.ContactAddress1, 
	   bc.ContactAddress2, 
	   bc.ContactCity, 
	   bc.ContactStateCode, 
	   bc.ContactZIP, 
	   bc.ContactPhone
  from BillingContacts bc
       inner join Clients c on c.ClientID = bc.ClientID
       inner join ClientContacts cc on cc.ClientContactID = bc.ClientContactID
       inner join Users u on u.UserID = cc.UserID
       inner join aspnet_Users au on au.UserId = u.UserGUID
       inner join aspnet_Membership am on am.UserId = u.UserGUID
  order by Parent, clientname

END



GO
