/****** Object:  StoredProcedure [dbo].[S1_Users_CreateMessageWithAction]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Users_CreateMessageWithAction

CREATE PROCEDURE [dbo].[S1_Users_CreateMessageWithAction]
(
	@messageactiontype int,
	@messagetext varchar(5000),
	@messageto int,  
	@tocontacttype int, --1 = User, 2 = Client Contact
	@messagefrom int,
	@fromcontacttype int, --1 = User, 3 = Automated
	@messageactionpath varchar(100),
	@sentdate datetime = null,
	@receiveddate datetime = null
)
AS
SET NOCOUNT ON;
Begin

	Declare @messageactionguid uniqueidentifier,
			@messageid int,
			@errorcode int
			
	Set @messageactionguid = null
	Set @errorcode = 0

	Select @messageactionguid = NEWID()
	
	
	BEGIN TRANSACTION
	
	insert into dbo.Messages (MessageType, MessageText, MessageTo, ToContactType, MessageFrom, FromContactType, SentDate, ReceivedDate) 
	values (@messageactiontype, @messagetext, @messageto, @tocontacttype, @messagefrom, @fromcontacttype, @sentdate, @receiveddate)
	
	select @messageid = @@IDENTITY

	if(@@ERROR <> 0)
	Begin
		Set @errorcode = -1
		Goto Cleanup
	End
	Else
	Begin

		insert into dbo.MessageAction (MessageID, MessageActionGUID, MessageActionType, MessageActionPath) 
		values (@messageid, @messageactionguid, @messageactiontype, @messageactionpath)
		
		if(@@ERROR <> 0)
		Begin
			set @errorcode = -1
			Goto Cleanup
		End	
		Else
		Begin
		
			COMMIT TRANSACTION
			
			select @messageactionguid as ActionGUID
			
			Return @errorcode
		End
	End
	
Cleanup:

    BEGIN
    	ROLLBACK TRANSACTION
    END

    RETURN @errorcode
	
End





GO
