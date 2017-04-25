/****** Object:  StoredProcedure [dbo].[S1_Users_ForgotPassword_GetUserName]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Users_ForgotPassword_GetUserName '1B7240DC-27EB-47BB-8D23-FFF1D96C6B17'

CREATE PROCEDURE [dbo].[S1_Users_ForgotPassword_GetUserName]
(
	@ForgotPasswordGuid nvarchar(MAX)
)
AS
	SET NOCOUNT ON;
	
--SELECT UserName as ForgotPasswordUserName, PasswordAnswer as ForgotPasswordAnswer FROM ForgotPassword	
	

DECLARE @UserName nvarchar(256), 
		@PasswordAnswer nvarchar(256)
SET @UserName = null
SET @PasswordAnswer = null
	
SELECT @UserName=UserName, @PasswordAnswer=PasswordAnswer FROM ForgotPassword
WHERE ForgotPasswordGuid=@ForgotPasswordGuid


IF (@UserName IS NOT NULL and @PasswordAnswer IS NOT NULL)
BEGIN
	SELECT @UserName as ForgotPasswordUserName, @PasswordAnswer as ForgotPasswordAnswer
END
ELSE
BEGIN
	SELECT null  as ForgotPasswordUserName , null as ForgotPasswordAnswer
END





GO
