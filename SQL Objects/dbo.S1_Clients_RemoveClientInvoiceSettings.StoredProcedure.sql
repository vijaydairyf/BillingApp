/****** Object:  StoredProcedure [dbo].[S1_Clients_RemoveClientInvoiceSettings]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[S1_Clients_RemoveClientInvoiceSettings]
(
	@ClientID int
)
AS
	SET NOCOUNT ON;
	
	DELETE FROM ClientInvoiceSettings WHERE ClientID=@ClientID

GO
