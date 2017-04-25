/****** Object:  StoredProcedure [dbo].[S1_Messages_GetMessageTemplateRecord]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Messages_GetMessageTemplateRecord]
@ClientID int,
@MessageName varchar(50)
AS
BEGIN

--EXEC S1_Messages_GetMessageTemplateRecord 0, 'AutoEmail Release'

SET NOCOUNT ON;
	
	SELECT mat.MessageActionTypeID, mt.*
	FROM MessageTemplates mt
	     left join MessageActionTypes mat on mat.MessageActionTypeDesc = mt.MessageName
	WHERE mt.ClientID = @ClientID
	  AND mt.MessageName = @MessageName

	
END



GO
