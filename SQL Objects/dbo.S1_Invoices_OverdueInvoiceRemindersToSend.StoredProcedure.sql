/****** Object:  StoredProcedure [dbo].[S1_Invoices_OverdueInvoiceRemindersToSend]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_OverdueInvoiceRemindersToSend]
AS
BEGIN

--Exec S1_Invoices_OverdueInvoiceRemindersToSend

select fcecr.MessageGUID,
       fcecr.MessageType,
       fcecr.MessageText,
       fcecr.MessageTo,
       fcecr.ToContactType,
       fcecr.MessageFrom,
       fcecr.FromContactType,
       fcecr.SentDate,
       fcecr.ReceivedDate,
       fcecr.MessageSubject,
       fcecr.[Status],
       fcecr.BodyFormat,
       fcecr.BadEmailAddress,
       fcecr.ClientID,
       fcecr.ClientName,
       fam.LoweredEmail as FromUserEmail,
	   fmu.UserFirstName as FromUserFirstName,
	   fmu.UserLastName as FromUserLastName,
	   fmu.UserMiddleInit as FromMiddleInit,
	   ltrim(rtrim(rtrim(coalesce(fmu.UserFirstName,'') + ' ' + coalesce(fmu.UserMiddleInit,'')) + ' ' + coalesce(fmu.UserLastName,''))) as FromFullName,
	   tam.LoweredEmail as ToUserEmail,
	   tou.UserFirstName as ToUserFirstName,
	   tou.UserLastName as ToUserLastName,
	   tou.UserMiddleInit as ToMiddleInit,
	   ltrim(rtrim(rtrim(coalesce(tou.UserFirstName,'') + ' ' + coalesce(tou.UserMiddleInit,'')) + ' ' + coalesce(tou.UserLastName,''))) as ToFullName
  from FinanceChargeEmailCurrentRun fcecr
       left join Users fmu on fmu.UserID = fcecr.MessageFrom
       inner join BillingContacts bc on bc.BillingContactID = fcecr.MessageTo
       inner join ClientContacts cc on cc.ClientContactID = bc.ClientContactID
       inner join Users tou on tou.UserID = cc.userid
	   left join aspnet_Membership fam on fam.UserId = fmu.UserGUID
	   inner join aspnet_Membership tam on tam.UserId = tou.UserGUID
	   where fcecr.ToContactType = 3
  order by fcecr.ClientName

END


GO
