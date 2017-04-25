/****** Object:  StoredProcedure [dbo].[S1_Messages_GetMessageTemplateList]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC S1_Messages_GetMessageTemplateList 0

CREATE PROCEDURE [dbo].[S1_Messages_GetMessageTemplateList]
(
	@ClientID int
)
AS
SET NOCOUNT ON;
Begin

	
	SELECT MessageName, IsPlainText 
	FROM MessageTemplates
	WHERE ClientID = @ClientID

	
End





GO
