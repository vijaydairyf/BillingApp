/****** Object:  StoredProcedure [dbo].[S1_Clients_GetClientParentWithOutput]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DECLARE @OutClientID int
EXEC GetClientParentWithOutput 7, @OutClientID OUTPUT
SELECT @OutClientID
*/

CREATE PROCEDURE [dbo].[S1_Clients_GetClientParentWithOutput]
(
	@ClientID int,
	@OutClientID int OUTPUT
)
AS
	SET NOCOUNT ON;
	
DECLARE @ParentID int
SELECT @ParentID=ParentClientID FROM Clients WHERE ClientID=@ClientID

IF (@ParentID IS NULL)
BEGIN
	SELECT @OutClientID=@ClientID
END
ELSE
BEGIN
	EXEC S1_Clients_GetClientParentWithOutput @ParentID, @OutClientID OUTPUT
END

GO
