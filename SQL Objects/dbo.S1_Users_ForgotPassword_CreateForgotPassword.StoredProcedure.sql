/****** Object:  StoredProcedure [dbo].[S1_Users_ForgotPassword_CreateForgotPassword]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Users_ForgotPassword_CreateForgotPassword 2, '192.168.0.1'

CREATE PROCEDURE [dbo].[S1_Users_ForgotPassword_CreateForgotPassword]
(
	@UserName nvarchar(256),
	@PasswordAnswer nvarchar(256),
	@UserIP varchar(15)
)
AS
	SET NOCOUNT ON;
	
DECLARE @ForgotPasswordGuid as uniqueidentifier

SELECT @ForgotPasswordGuid = NEWID()
	
INSERT INTO dbo.ForgotPassword (ForgotPasswordGuid, UserName, PasswordAnswer, CreatedOn, UserIP)
VALUES (@ForgotPasswordGuid,@UserName,@PasswordAnswer,GETDATE(),@UserIP)

SELECT @ForgotPasswordGuid as ForgotPassword





GO
