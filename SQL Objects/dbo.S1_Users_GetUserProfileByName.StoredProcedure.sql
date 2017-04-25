/****** Object:  StoredProcedure [dbo].[S1_Users_GetUserProfileByName]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--EXEC S1_Users_GetUserProfileByName 'test'

CREATE PROCEDURE [dbo].[S1_Users_GetUserProfileByName]
(
    @UserName nvarchar(256)
)
AS

SELECT U.*,M.*
FROM dbo.aspnet_Users U
INNER JOIN dbo.aspnet_Membership M
ON U.UserId=M.UserId
WHERE U.UserName=@UserName

GO
