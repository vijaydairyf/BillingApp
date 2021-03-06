/****** Object:  StoredProcedure [dbo].[S1_Products_UpdateClientProductsInfo]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[S1_Products_UpdateClientProductsInfo]
(
	@ClientProductsID int,
	@SalesPrice money,
	@IncludeOnInvoice int,
	@ImportsAtBaseOrSales bit
)
AS
	SET NOCOUNT ON;
	
	DECLARE @errormsg int
	SET @errormsg = 0
	
	BEGIN TRANSACTION
				
	IF (@ClientProductsID <> 0)
	BEGIN
		
		UPDATE ClientProducts
		SET SalesPrice = @SalesPrice, IncludeOnInvoice = @IncludeOnInvoice, ImportsAtBaseOrSales = @ImportsAtBaseOrSales
		WHERE ClientProductsID = @ClientProductsID			
	
	END
	ELSE
	BEGIN
		
		SET @errormsg = -1
		Goto Cleanup
		
	END

	if(@@ERROR <> 0)
	Begin
		SET @errormsg = -1
		Goto Cleanup
	End	
	Else
	Begin
	
		COMMIT TRANSACTION
		Return @errormsg
	End

	
Cleanup:

    BEGIN
    	ROLLBACK TRANSACTION
    END

    RETURN @errormsg
GO
