/****** Object:  StoredProcedure [dbo].[S1_Invoices_CurrentInvoiceRemindersSent]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_CurrentInvoiceRemindersSent]
AS
BEGIN

--Exec S1_Invoices_CurrentInvoiceRemindersSent

select relr.MessageGUID,
       relr.MessageType,
       relr.MessageText,
       relr.MessageTo,
       relr.ToContactType,
       relr.MessageFrom,
       relr.FromContactType,
       relr.SentDate,
       relr.ReceivedDate,
       relr.MessageSubject,
       relr.[Status],
       relr.BodyFormat,
       relr.BadEmailAddress,
       relr.ClientID,
       relr.ClientName,
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
  from ReminderEmailLastRun relr
       inner join Users fmu on fmu.UserID = relr.MessageFrom
       inner join Users tou on tou.UserID = relr.MessageTo
	   inner join aspnet_Membership fam on fam.UserId = fmu.UserGUID
	   inner join aspnet_Membership tam on tam.UserId = tou.UserGUID
  order by relr.ClientName

END


GO
