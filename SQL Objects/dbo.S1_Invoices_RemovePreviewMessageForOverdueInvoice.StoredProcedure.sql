/****** Object:  StoredProcedure [dbo].[S1_Invoices_RemovePreviewMessageForOverdueInvoice]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_RemovePreviewMessageForOverdueInvoice]
@MessageGuid uniqueidentifier
AS
BEGIN

;delete from FinanceChargeEmailCurrentRun where MessageGUID = @MessageGuid

END


GO
