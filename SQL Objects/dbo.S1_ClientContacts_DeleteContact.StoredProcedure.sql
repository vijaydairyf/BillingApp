/****** Object:  StoredProcedure [dbo].[S1_ClientContacts_DeleteContact]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
Created By:		Rhonda Carey
Created On:		06/29/2011
Description:	Delete a client contact/billing contact

Modified By:	
Modified On:	
Description:

Test Script:

USE [ScreeningONE_Prod0623]	
DECLARE @billingcontactid int
DECLARE @clientcontactid int
DECLARE @userid int
DECLARE @clientid int

SET @billingcontactid = 2792
SET @clientcontactid = 2684
SET @userid = 2026
SET @clientid = 1

EXEC S1_ClientContacts_DeleteContact @billingcontactid,@clientcontactid,@userid,@clientid

***********************************************************************************/

CREATE PROCEDURE [dbo].[S1_ClientContacts_DeleteContact]
(
	@billingcontactid int,
	@clientcontactid int,
	@userid int,
	@clientid int
)
AS
SET NOCOUNT ON;
Begin

	DECLARE @error int
	DECLARE @ContactCnt int
		
	Set @error = 0
	
	SELECT @ContactCnt = COUNT(ClientContactID) FROM ClientContacts WHERE ClientID = @clientid
	
	if @ContactCnt = 1
	BEGIN
		--This is the only contact for the client so it can not be deleted.
		SET @error = -1
	END
	ELSE
	BEGIN
		if exists(select * from BillingContacts where IsPrimaryBillingContact = 1 and BillingContactID = @billingcontactid and ClientID = @clientid)
		BEGIN
			--Contact is billing contact primary - cannot delete them
			SET @error = -2
		END
		ELSE
		BEGIN
				DELETE FROM InvoiceBillingContacts WHERE BillingContactID = @billingcontactid
				
				DELETE FROM BillingContacts WHERE BillingContactID = @billingcontactid 
				
				DELETE FROM ClientContacts WHERE ClientContactID = @clientcontactid
							
				--write to the log table for tracking
				DECLARE @ActionTypeCode varchar(50)
				DECLARE @LogDescription varchar(max)
				SELECT @ActionTypeCode = 'ClientContact_Deleted'
				SELECT @LogDescription = 'A client contact has been deleted. Details: ClientID: ' + CAST(@clientID as varchar(15)) + '; UserID: ' + CAST(@userid as varchar(15))+ '; Deleted ContactID: ' + Cast(@clientcontactid as varchar(15)) + '; Deleted BillingContactID: ' + Cast(@billingcontactid as varchar(15))
				EXEC S1_Log_CreateAction @ActionTypeCode,@LogDescription
					
			END
				
	
	END
	

	SELECT @error as ErrorCode

END


GO
