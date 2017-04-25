/****** Object:  StoredProcedure [dbo].[S1_Clients_RemoveParentRelationship]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[S1_Clients_RemoveParentRelationship]
(
	@ClientID int
)
AS
	SET NOCOUNT ON;
	
	UPDATE Clients SET ParentClientID = null WHERE ClientID = @ClientID
GO
