/****** Object:  StoredProcedure [dbo].[S1_Invoices_SendCurrentInvoiceReminder]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_SendCurrentInvoiceReminder]
AS
BEGIN
    --Exec S1_Invoices_SendCurrentInvoiceReminder
	
	;declare @nPlease datetime,
			 @nPleaseWOTime datetime,
			 @InsertCount int
	;select @nPlease = getdate(),
			@InsertCount = 0
	;select @nPleaseWOTime = convert(datetime,convert(varchar(255),@nPlease,101),101)
	if not exists(select m.MessageID
					from [Messages] m
					where m.SentDate >= @nPleaseWOTime and
						  m.MessageType = 8 and
						  m.[Status] in (0,1))
	BEGIN
		;update ReminderEmailCurrentRun
		   set ReminderEmailCurrentRun.SentDate = @nPlease
		   where ReminderEmailCurrentRun.BadEmailAddress = 0 and
				 not exists(select m.MessageID
							  from [Messages] m 
							  where m.MessageGUID = ReminderEmailCurrentRun.MessageGUID)

		;insert into [Messages](MessageGUID,MessageType,MessageText,
								MessageTo,ToContactType,MessageFrom,
								FromContactType,SentDate,ReceivedDate,
								MessageSubject,[Status],BodyFormat)
		select recr.MessageGUID,
			   recr.MessageType,
			   recr.MessageText,
			   recr.MessageTo,
			   recr.ToContactType,
			   recr.MessageFrom,
			   recr.FromContactType,
			   recr.SentDate,
			   recr.ReceivedDate,
			   recr.MessageSubject,
			   recr.[Status],
			   recr.BodyFormat
		  from ReminderEmailCurrentRun recr
		  where recr.BadEmailAddress = 0 and
				not exists(select m.MessageID
							 from [Messages] m 
							 where m.MessageGUID = recr.MessageGUID)

		;select @InsertCount = @@ROWCOUNT

		if @InsertCount > 0
		BEGIN
			;truncate table ReminderEmailLastRun
			;insert into ReminderEmailLastRun(MessageGUID,MessageType,MessageText,MessageTo,ToContactType,MessageFrom,FromContactType,SentDate,ReceivedDate,MessageSubject,[Status],BodyFormat,ClientID,ClientName)
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
					fcecr.ClientID,
					fcecr.ClientName
				from ReminderEmailCurrentRun fcecr
			;truncate table ReminderEmailCurrentRun
		END
	END
	
	;select relr.MessageGUID,
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
			relr.ClientID,
			relr.ClientName
 	   from ReminderEmailLastRun relr
 	   where @InsertCount > 0

END


GO
