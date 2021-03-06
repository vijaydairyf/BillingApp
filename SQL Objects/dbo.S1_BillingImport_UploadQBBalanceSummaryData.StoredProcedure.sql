/****** Object:  StoredProcedure [dbo].[S1_BillingImport_UploadQBBalanceSummaryData]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[S1_BillingImport_UploadQBBalanceSummaryData]
(
	@BillAsClientName varchar(255),
	@Amount money

)
AS
SET NOCOUNT ON;
Begin

	Declare @errorcode int
			
	Set @errorcode = 0
	

	BEGIN TRANSACTION
	
	if (@BillAsClientName in (select Replace(BillAsClientName, 'Community Options:', '') from Clients where ParentClientID = 1979))
	BEGIN
		set @BillAsClientName = 'Community Options:' + @BillAsClientName
	END
	
	If (@Amount is not null)
	BEGIN
		INSERT INTO QBBalanceSummary 
			(Client, Amount, BalanceDate)
		VALUES (@BillAsClientName, @Amount, GETDATE())
    END
           
	
	if(@@ERROR <> 0)
	Begin
		set @errorcode = -1
		Goto Cleanup
	End	
	Else
	Begin
	
		COMMIT TRANSACTION
		Return @errorcode
	End

	
Cleanup:

    BEGIN
    	ROLLBACK TRANSACTION
    END

    RETURN @errorcode

End

GO
