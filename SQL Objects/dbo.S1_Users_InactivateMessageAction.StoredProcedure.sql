/****** Object:  StoredProcedure [dbo].[S1_Users_InactivateMessageAction]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC S1_Users_InactivateMessageAction '825a6c72-4620-4263-b55d-aaeb1e29625b'

CREATE PROCEDURE [dbo].[S1_Users_InactivateMessageAction]
(
	@messageactionguid uniqueidentifier

)
AS
SET NOCOUNT ON;
Begin

	Declare @messageid int,
			@errorcode int
			
	Set @errorcode = 0

	
	BEGIN TRANSACTION

	update dbo.MessageAction 
	set IsActive = 1 
	where MessageActionGUID = @messageactionguid
	
	if(@@ERROR <> 0)
	Begin
		set @errorcode = -1
		Goto Cleanup
	End	
	Else
	Begin
	
		COMMIT TRANSACTION
		Return @errorcode
	End

	
Cleanup:

    BEGIN
    	ROLLBACK TRANSACTION
    END

    RETURN @errorcode
	
End






GO
