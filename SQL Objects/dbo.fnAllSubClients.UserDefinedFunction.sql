/****** Object:  UserDefinedFunction [dbo].[fnAllSubClients]    Script Date: 11/21/2016 9:44:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--SELECT * FROM fnAllSubClients(140)

CREATE FUNCTION [dbo].[fnAllSubClients](
	@RootClientID int
)
RETURNS
@AllSubClients TABLE (
	ClientID int,
	ParentClientID int,
	TreeLevel int
)
AS
BEGIN

WITH AllSubClients(ClientID,ParentClientID,TreeLevel)
AS
(
	SELECT C.ClientID,C.ParentClientID,0 as TreeLevel 
	FROM dbo.Clients C
	WHERE C.ClientID=@RootClientID
	
	UNION ALL
	
	SELECT C.ClientID,C.ParentClientID,TreeLevel+1
	FROM dbo.Clients C
	INNER JOIN AllSubClients A
		ON A.ClientID=C.ParentClientID
)

INSERT INTO @AllSubClients (ClientID,ParentClientID,TreeLevel)
SELECT ClientID, ParentClientID, TreeLevel
FROM AllSubClients

RETURN

END


GO
