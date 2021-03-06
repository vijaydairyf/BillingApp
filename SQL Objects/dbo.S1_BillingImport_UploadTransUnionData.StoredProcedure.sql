/****** Object:  StoredProcedure [dbo].[S1_BillingImport_UploadTransUnionData]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[S1_BillingImport_UploadTransUnionData]
(
	@ImportBatchID int, 
	@TUSubscriberID varchar(50), 
	@InquiryDate datetime, 
	@InquiryTime varchar(6), 
	@ECOA varchar(2), 
	@Surname varchar(255), 
	@FirstName varchar(255), 
	@Address varchar(max), 
	@City varchar(100), 
	@State varchar(50), 
	@Zip varchar(10), 
	@SSN varchar(20), 
	@SpouseFirstName varchar(255), 
	@NetPrice money, 
	@MMSSTo varchar(max), 
	@TimeZone varchar(100),
	@ProductCode varchar(7), 
	@ProductType varchar(1), 
	@Hit varchar(1), 
	@UserReference varchar(max)

)
AS
SET NOCOUNT ON;
Begin

	Declare @errorcode int
			
	Set @errorcode = 0
	
	
	BEGIN TRANSACTION

    INSERT INTO TransUnionImport 
		(ImportBatchID, TUSubscriberID, InquiryDate, InquiryTime, ECOA, Surname, FirstName, 
		Address, City, State, Zip, SSN, SpouseFirstName, NetPrice, MMSSTo, TimeZone,  
		ProductCode, ProductType, Hit, UserReference)
    VALUES (@ImportBatchID, @TUSubscriberID, @InquiryDate, @InquiryTime, @ECOA, @Surname, @FirstName, 
		@Address, @City, @State, @Zip, @SSN, @SpouseFirstName, @NetPrice, @MMSSTo, @TimeZone,  
		@ProductCode, @ProductType, @Hit, @UserReference)

	
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
