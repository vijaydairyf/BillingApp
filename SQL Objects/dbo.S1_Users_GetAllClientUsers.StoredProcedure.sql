/****** Object:  StoredProcedure [dbo].[S1_Users_GetAllClientUsers]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_Users_GetAllClientUsers

CREATE PROCEDURE [dbo].[S1_Users_GetAllClientUsers]

AS
	SET NOCOUNT ON;
	

SELECT cu.ClientUsersID, 
		u.UserID,
		u.UserName, 
		rtrim(u.UserLastName) + ', ' + u.UserFirstName as ShortName,
		u.IsApproved,
		c.ClientID, 
		c.ClientName,
		u.Status
FROM vw_S1_Users u
INNER JOIN ClientUsers cu on u.UserID = cu.UserID
INNER JOIN Clients c on cu.ClientID = c.ClientID
ORDER BY u.UserName

GO
