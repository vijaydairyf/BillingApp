/****** Object:  StoredProcedure [dbo].[S1_ProductTransactions_RemoveProductTransaction]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_ProductTransactions_RemoveProductTransaction]
(
	@ProductTransactionID int
)
AS
	SET NOCOUNT ON;
	
	DELETE FROM ProductTransactions
	WHERE ProductTransactionID=@ProductTransactionID
GO
