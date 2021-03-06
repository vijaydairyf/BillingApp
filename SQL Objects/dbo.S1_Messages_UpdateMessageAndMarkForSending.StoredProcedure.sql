/****** Object:  StoredProcedure [dbo].[S1_Messages_UpdateMessageAndMarkForSending]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Messages_UpdateMessageAndMarkForSending]
	@MessageID int,
	@MessageSubject varchar(255),
	@MessageText varchar(max)
AS
BEGIN
	/*
	0 = Draft
	1 = Waiting to be Sent
	2 = Sent
	3 = Error
	*/
	SET NOCOUNT ON;

	UPDATE [Messages] SET 
	MessageSubject = @MessageSubject,
	MessageText = @MessageText,
	[Status] = 1
	WHERE MessageID = @MessageID;

	UPDATE MessageAction SET IsActive = 1 WHERE MessageID = @MessageID;

END



GO
