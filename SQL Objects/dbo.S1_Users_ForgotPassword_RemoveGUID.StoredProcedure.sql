/****** Object:  StoredProcedure [dbo].[S1_Users_ForgotPassword_RemoveGUID]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC S1_Users_ForgotPassword_RemoveGUID '1B7240DC-27EB-47BB-8D23-FFF1D96C6B17'

CREATE PROCEDURE [dbo].[S1_Users_ForgotPassword_RemoveGUID]
(
	@ForgotPasswordGuid nvarchar(max)
)
    
AS
SET NOCOUNT ON;

BEGIN
	DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    DECLARE @ErrorCode   int
    SET @ErrorCode = 0
	
	
    BEGIN
    
		DELETE FROM ForgotPassword WHERE ForgotPasswordGuid=@ForgotPasswordGuid
		
		SELECT @ErrorCode = @@ERROR

		IF( @ErrorCode <> 0 )
		GOTO Cleanup

	End
    
    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:
    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
	    ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END


GO
