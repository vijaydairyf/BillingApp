/****** Object:  StoredProcedure [dbo].[S1_Users_GetUserByEmail]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[S1_Users_GetUserByEmail]
(
    @email varchar(max)
)
AS

select u.UserID, u.UserGUID, u.UserFirstName, u.UserLastName, u.Status
from Users u
inner join aspnet_Membership AM on AM.UserId = u.UserGUID
inner join aspnet_Users AU on AU.UserId = u.UserGUID
WHERE AM.Email = @email

GO
