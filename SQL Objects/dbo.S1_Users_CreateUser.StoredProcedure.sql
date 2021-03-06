/****** Object:  StoredProcedure [dbo].[S1_Users_CreateUser]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Users_CreateUser 'tonkin6', 1, 1, 'john', 'doe'

CREATE PROCEDURE [dbo].[S1_Users_CreateUser]
(
	@username nvarchar(256),
	@clientid int,
	@isprimaryclient tinyint,
	@userfirstname varchar(30) = null,
	@userlastname varchar(40) = null
	
)
AS

SET NOCOUNT ON;
Begin

	Declare @userguid uniqueidentifier,
			@errorcode int,
			@userid int
			
	Set @userguid = null
	Set @errorcode = 0

	Select @userguid = userid from aspnet_Users where LoweredUserName = @username

	BEGIN TRANSACTION
	
	insert into dbo.Users (UserGUID, LanguageCode, UserFirstName, UserLastName, Status) values (@userguid, 'en-us', @userfirstname, @userlastname, 'Active')

	select @userid = @@IDENTITY

	if(@@ERROR <> 0)
	Begin
		Set @errorcode = -1
		Goto Cleanup
	End
	Else
	Begin

		insert into dbo.ClientUsers (UserID, ClientID, IsPrimaryClient) values (SCOPE_IDENTITY(), @clientid, @isprimaryclient)
		
		if(@@ERROR <> 0)
		Begin
			set @errorcode = -1
			Goto Cleanup
		End	
		Else
		Begin
		
			COMMIT TRANSACTION
			select @userid as UserID
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
