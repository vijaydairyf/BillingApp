/****** Object:  StoredProcedure [dbo].[S1_Invoices_SendOverdueInvoiceReminder]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_SendOverdueInvoiceReminder]
AS
BEGIN
    --Exec S1_Invoices_SendOverdueInvoiceReminder
	
	;declare @nPlease datetime,
			 @nPleaseWOTime datetime,
			 @InsertCount int
	;select @nPlease = getdate(),
	        @InsertCount = 0
	;select @nPleaseWOTime = convert(datetime,convert(varchar(255),@nPlease,101),101)
	if not exists(select m.MessageID
					from [Messages] m
					where m.SentDate >= @nPleaseWOTime and
						  m.MessageType = 6 and
						  m.[Status] = 1)
	BEGIN
		;update FinanceChargeEmailCurrentRun
		   set FinanceChargeEmailCurrentRun.SentDate = @nPlease
		   where FinanceChargeEmailCurrentRun.BadEmailAddress = 0 and
				 not exists(select m.MessageID
							  from [Messages] m 
							  where m.MessageGUID = FinanceChargeEmailCurrentRun.MessageGUID)

		;insert into [Messages](MessageGUID,MessageType,MessageText,
								MessageTo,ToContactType,MessageFrom,
								FromContactType,SentDate,ReceivedDate,
								MessageSubject,[Status],BodyFormat)
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
			   fcecr.BodyFormat
		  from FinanceChargeEmailCurrentRun fcecr
		  where fcecr.BadEmailAddress = 0 and
				not exists(select m.MessageID
							 from [Messages] m 
							 where m.MessageGUID = fcecr.MessageGUID)

		;select @InsertCount = @@ROWCOUNT

		if @InsertCount > 0
		BEGIN
			;truncate table FinanceChargeEmailLastRun
			;insert into FinanceChargeEmailLastRun(MessageGUID,MessageType,MessageText,MessageTo,ToContactType,MessageFrom,FromContactType,SentDate,ReceivedDate,MessageSubject,[Status],BodyFormat,ClientID,ClientName)
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
				from FinanceChargeEmailCurrentRun fcecr
			;truncate table FinanceChargeEmailCurrentRun
		END
	END
	
	;select fcelr.MessageGUID,
			fcelr.MessageType,
			fcelr.MessageText,
			fcelr.MessageTo,
			fcelr.ToContactType,
			fcelr.MessageFrom,
			fcelr.FromContactType,
			fcelr.SentDate,
			fcelr.ReceivedDate,
			fcelr.MessageSubject,
			fcelr.[Status],
			fcelr.BodyFormat,
			fcelr.ClientID,
			fcelr.ClientName
 	   from FinanceChargeEmailLastRun fcelr
 	   where @InsertCount > 0

END


GO
