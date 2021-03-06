/****** Object:  StoredProcedure [dbo].[S1_Clients_CreateClient]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[S1_Clients_CreateClient]
(
		@clientname varchar(max),
		@address1 varchar(max),
		@address2 varchar(max),
		@city varchar(max),
		@state varchar(max),
		@zipcode varchar(max),
		@tazworks1client bit,
		@tazworks2client bit,
		@nontazworksclient bit

)
AS
SET NOCOUNT ON;
Begin

	Declare @errorcode int,
			@clientid int,
			@LastTazworksID varchar(50),
			@tazworks1ID varchar(50),
			@tazworks2ID varchar(50)
			
	set @errorcode = 0
			

	if not exists(select clientname from Clients where ClientName = @clientname and ZipCode = @zipcode)
	BEGIN

		if (@clientname is not null and @clientname <> '')
		BEGIN
			insert into Clients (ParentClientID, ClientName, Address1, Address2, City, State, ZipCode, DoNotInvoice, Status, 
			BillAsClientName, ImportClientSplitMode, DueText, BillingGroup)
			values (null, @clientname, @address1, @address2, @city, @state, @zipcode, 0, 'Active', null, 0, 'Due On Receipt', 1)

			set @clientid = @@IDENTITY
			
			INSERT INTO ClientVendors (ClientID, VendorID, VendorClientNumber)
			VALUES (@clientid, 6, @tazworks2ID)

			if (@tazworks1client = 1 or @tazworks2client = 1)
			BEGIN
			
				Update Clients set BillingGroup = 3 where ClientID = @clientid
				
				if (@tazworks1client = 1 and not exists(select * from ClientVendors where ClientID = @clientid and VendorID = 1))
				BEGIN

					SELECT @LastTazworksID = max(VendorClientNumber) from ClientVendors where VendorID in (1,2) and left(VendorClientNumber, 3) = 'S1_'
				
					--DJT 03/08/2015 - Per Angela, setting default vendorclientnumber to blank
					--SET @tazworks1ID = 'S1_' + RIGHT('00000' + CONVERT(varchar, CONVERT(int, right(@LastTazworksID, 5)) + 1), 5)
				
					INSERT INTO ClientVendors (ClientID, VendorID, VendorClientNumber)
					VALUES (@clientid, 1, '')
					
				END
				
				if (@tazworks2client = 1 and not exists(select * from ClientVendors where ClientID = @clientid and VendorID = 2))
				BEGIN

					SELECT @LastTazworksID = max(VendorClientNumber) from ClientVendors where VendorID in (1,2) and left(VendorClientNumber, 3) = 'S1_'

					--DJT 03/08/2015 - Per Angela, setting default vendorclientnumber to blank
					--SET @tazworks2ID = 'S1_' + RIGHT('00000' + CONVERT(varchar, CONVERT(int, right(@LastTazworksID, 5)) + 1), 5)
				
					INSERT INTO ClientVendors (ClientID, VendorID, VendorClientNumber)
					VALUES (@clientid, 2, '')
					
					
				END
		
			END
			ELSE
			BEGIN
				Update Clients set BillingGroup = 6 where ClientID = @clientid
			END

		END
	END
	ELSE
	BEGIN
		set @clientid = 0 
	END
	
	select @clientid as ClientID
	
END

GO
