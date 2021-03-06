/****** Object:  StoredProcedure [dbo].[S1_ClientContacts_UpdateClientContact]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[S1_ClientContacts_UpdateClientContact]
(
	@clientcontactid int,
	@userid int,
	@clientid int,
	@contactfirstname varchar(max),
	@contactlastname varchar(max),
	@contacttitle varchar(max),
	@contactaddr1 varchar(max),
	@contactaddr2 varchar(max),
	@contactcity varchar(max),
	@contactstate varchar(2),
	@contactzip varchar(max),
	@contactbusinessphone varchar(50),
	@contactfax varchar(50),
	@contactemail varchar(max),
	@contactstatus bit
)
AS
SET NOCOUNT ON;
Begin

		
		UPDATE ClientContacts 
		SET
		ContactFirstName = @contactfirstname, 
		ContactLastName = @contactlastname, 
		ContactTitle = @contacttitle, 
		ContactAddr1 = @contactaddr1, 
		ContactAddr2 = @contactaddr2, 
		ContactCity = @contactcity,
		ContactStateCode = @contactstate,
		ContactZIP = @contactzip,
		ContactBusinessPhone = @contactbusinessphone,
	    ContactFax = @contactfax,
	    ContactEmail = @contactemail,
	    ContactStatus = @contactstatus
	    Where ClientContactID = @clientcontactid
	      and ClientID = @clientid
	      and UserID = @userid
	    
	
	
END

GO
