/****** Object:  View [dbo].[vw_S1_Users]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





  CREATE VIEW [dbo].[vw_S1_Users]
  AS SELECT 
	u.UserID, 
	u.UserGUID, 
	a.UserName, 
	u.UserFirstName, 
	u.UserLastName, 
	u.UserMiddleInit,
	u.Status,
	m.Email, 
	m.IsApproved, 
	m.IsLockedOut, 
	m.CreateDate, 
	m.LastLoginDate 
FROM USERS u
inner join aspnet_Users a ON u.UserGUID = a.UserId
inner join aspnet_Membership m ON a.UserId = m.UserId



  




GO
