/****** Object:  StoredProcedure [dbo].[S1_Messages_SendEmails]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
0 = Draft
1 = Waiting to be Sent
2 = Sent
3 = Error
4 = Delivery Method not set to email
*/
--Exec S1_Messages_SendEmails

CREATE PROCEDURE [dbo].[S1_Messages_SendEmails]
AS

DECLARE @recipients varchar(max),
		@subject varchar(255),
		@body varchar(max),
		@MessageID int,
		@bodyformat varchar(50),
		@deliveryMethod int
		
DECLARE S1Emails CURSOR
FOR
SELECT TOP 50 Messageid, 
	CASE ToContactType 
	WHEN 1 
		THEN (SELECT loweredemail FROM aspnet_membership am inner join users u ON u.userguid = am.userid WHERE u.userid = MessageTo)
	WHEN 2 
		THEN (SELECT ContactEmail FROM ClientContacts WHERE ClientContactID = MessageTo)
	WHEN 3 -- Primary Billing Contact
		THEN (SELECT ContactEmail FROM BillingContacts WHERE BillingContactID = MessageTo)	
	END AS MessageTo,
	MessageSubject,
	MessageText,
	Bodyformat,
	'DeliveryMethod' = CASE WHEN ToContactType = 1 THEN ISNULL((SELECT TOP 1 ISNULL(BC.DeliveryMethod,0) FROM ClientUsers CU INNER JOIN ClientContacts CC ON CC.UserID = CU.UserID AND CC.ClientID = CU.ClientID INNER JOIN BillingContacts BC ON BC.ClientContactID = CC.ClientContactID WHERE CC.UserID = MessageTo AND CC.ContactStatus = 1),0)
							WHEN ToContactType = 2 THEN ISNULL((SELECT BC.DeliveryMethod FROM BillingContacts BC INNER JOIN ClientContacts CC ON BC.ClientContactID = CC.ClientContactID WHERE CC.ClientContactID = MessageTo AND CC.ContactStatus = 1),0)
							WHEN ToContactType = 3 THEN ISNULL((SELECT BC2.DeliveryMethod FROM BillingContacts BC2 INNER JOIN ClientContacts CC2 ON BC2.ClientContactID = CC2.ClientContactID WHERE BC2.BillingContactID = MessageTo AND BC2.IsPrimaryBillingContact = 1 AND CC2.ContactStatus = 1),0)
					   ELSE 0
					   END
FROM
[Messages]
WHERE Status = 1
  and ToContactType in (1, 2,3)

OPEN S1Emails
FETCH S1Emails INTO @MessageID, @recipients, @subject, @body, @bodyformat,@deliveryMethod

WHILE (@@FETCH_STATUS = 0)
BEGIN

	--select @messageid
	
	--IF(@deliveryMethod IN (1,2))  --Only send the email if the delivery method for the user is set to email auto or email manual
	--BEGIN
		EXEC msdb.dbo.sp_send_dbmail @profile_name='ScreeningONEBillingEmail',
		@recipients=@recipients,
		@blind_Copy_Recipients='billing@screeningonebilling.com',
		@subject=@subject,
		@body=@body,
		@body_format = @bodyformat
		

		IF (@@ERROR = 0)
		BEGIN
			UPDATE [Messages] SET Status = 2 WHERE MessageID = @MessageID
		END
		ELSE
		BEGIN
			INSERT INTO ActionLog (ActionTypeCode, LogDescription, LogDate)
			VALUES ('S1 DB SendMail Error', 'ErrorCode = ' + @@ERROR, GETDATE())
									
			UPDATE [Messages] SET Status = 3 WHERE MessageID = @MessageID
		END
	--END
	--ELSE
	--BEGIN
		--User was set to not receive emails so just update the email message status 4
	--	UPDATE [Messages] SET Status = 4 WHERE MessageID = @MessageID
	--END
	FETCH S1Emails INTO @MessageID, @recipients, @subject, @body, @bodyformat,@deliveryMethod

END

CLOSE S1Emails
DEALLOCATE S1Emails



GO
