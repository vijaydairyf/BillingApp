/****** Object:  StoredProcedure [dbo].[aspnet_GetUserInfoForFPCustomSP]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[aspnet_GetUserInfoForFPCustomSP]
@UserName nvarchar(256)
AS
BEGIN
       select am.Email,
              u.UserId
        from aspnet_Users au
		     inner join aspnet_Membership am on am.UserId = au.UserId
			 inner join Users u on u.UserGUID = au.UserId
        where au.UserName = @UserName
END


GO
