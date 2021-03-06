/****** Object:  StoredProcedure [dbo].[S1_Clients_CreateApplicantONEClient]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_CreateApplicantONEClient]
(
		@clientname varchar(100),
		@address1 varchar(100),
		@address2 varchar(100),
		@city varchar(100),
		@state varchar(2),
		@zipcode varchar(10),
		@username varchar(255),
		@userfirstname varchar(255),
		@userlastname varchar(255),
		@useremail varchar(255),
		@phone varchar(255),
		@productprice money,
		@QBName varchar(255) OUTPUT,
		@BillingContactOut int OUTPUT,
		@S1BillingUserID int OUTPUT
)
AS
SET NOCOUNT ON;

Begin
-- password for new accounts in aspnet_membership is 7A5B0A40F9134A76AEAD7510FB6A22E9

Declare @clientid int,
		@userid uniqueidentifier,
		@newuserid int,
		@clientcontactid int,
		@billingcontactid int,
		@combinedname varchar(255),
		@servicestartdate datetime,
		@serviceenddate datetime,
		@servicedates varchar(255),
		@currentdate datetime

Create Table #tmp (
	ClientID int
)

Insert into #tmp Exec S1_Clients_CreateClient @clientname, @address1, @address2, @city, @state, @zipcode, 0, 0, 1

If exists (select * from #tmp where ClientID is not null)
BEGIN
select @clientid = MAX(clientid) from Clients where ClientName = @clientname

update Clients set ParentClientID = 5161, BillAsClientName = replace(@clientname, '''', ''), BillingGroup = 1
where ClientID = @clientid

Insert into ClientProducts (ClientID, ProductID, IncludeOnInvoice, ImportsAtBaseOrSales, SalesPrice)
select @clientid, ProductID, IncludeOnInvoice, ImportsAtBaseOrSales, SalesPrice
from ClientProducts
where ClientID = 5161

Insert into ClientVendors  (ClientID, VendorID, VendorClientNumber)
select @clientid, vendorid, 'A1' + CONVERT(varchar, vendorid) + CONVERT(varchar, @clientid)
from ClientVendors
where ClientID = 5161
and ClientID <> 6

insert into ImportClientSplit (FromClientID, ToClientID, SplitText)
values (5161, @clientid, @clientname)

Exec S1_Clients_CreateClientInvoiceSettings @ClientID, 8, 1, 4, 0, 1, 45, 0.015, 0

set @currentdate = GETDATE()
set @servicestartdate = Convert(datetime, convert(varchar, month(DATEADD(m, 1, getdate()))) + '/01/' + convert(varchar, YEAR(getdate())))
set @serviceenddate = dateadd(d, -1, Convert(datetime, Convert(varchar, Month(DATEADD(m, 2, getdate()))) + '/01/' + CONVERT(varchar, Year(getdate()))))
set @servicedates = 'SERVICE DATES: ' + CONVERT(varchar, @servicestartdate, 101) + ' TO ' + CONVERT(varchar, @serviceenddate, 101)

Exec S1_ProductTransactions_CreateProductTransaction 251, @ClientID, 7, @currentdate, @currentdate, @combinedname, 'applicantONE Software Fee', '', '', @clientname, '', '', @servicedates, 'FEE', @productprice 

set @userid = NEWID()

if not exists (select * from aspnet_Users where UserName = @useremail)
BEGIN
	Insert into aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, MobileAlias, IsAnonymous, LastActivityDate)
	select ApplicationId, @userid, @useremail, lower(@useremail), null, 0, GETDATE()
	from aspnet_Users
	where userid = 'B1B117AB-9B06-40C7-BEF7-398107E60CEC'

	Insert into aspnet_UsersInRoles (UserId, RoleId)
	select @userid, roleid
	from aspnet_UsersInRoles where UserId =  'B1B117AB-9B06-40C7-BEF7-398107E60CEC'

	insert into aspnet_Membership (ApplicationId, UserId, Password, PasswordFormat, PasswordSalt, MobilePIN, Email, LoweredEmail, PasswordQuestion, PasswordAnswer, IsApproved, IsLockedOut, CreateDate, LastLoginDate, LastPasswordChangedDate, LastLockoutDate, FailedPasswordAttemptCount, FailedPasswordAttemptWindowStart, FailedPasswordAnswerAttemptCount, FailedPasswordAnswerAttemptWindowStart, Comment)
	select ApplicationId, @userid, Password, PasswordFormat, PasswordSalt, MobilePIN, @useremail, @useremail, PasswordQuestion, PasswordAnswer, IsApproved, IsLockedOut, GETDATE(), GETDATE(), GETDATE(), LastLockoutDate, FailedPasswordAttemptCount, FailedPasswordAttemptWindowStart, FailedPasswordAnswerAttemptCount, FailedPasswordAnswerAttemptWindowStart, Comment
	from aspnet_Membership
	where UserId =  'B1B117AB-9B06-40C7-BEF7-398107E60CEC'

	Insert into #tmp EXEC S1_Users_CreateUser @useremail, 1, 1, @userfirstname, @userlastname

	select @newuserid = userid from Users where UserGUID = @userid

	Insert into #tmp Exec S1_ClientContacts_CreateClientContact @newuserid, @clientid, @userfirstname, @userlastname, '', @address1, @address2, @city, @state, @zipcode, @phone, '', @useremail

	select @clientcontactid = clientcontactid from ClientContacts where UserID = @newuserid

	set @combinedname = @userfirstname + ' ' + @userlastname

	Insert into #tmp Exec S1_ClientContacts_CreateBillingContact @clientid, @clientcontactid, 1, @combinedname, @address1, @address2, @city, @state, @zipcode, @phone,'', @useremail, 1, '', '', '', 0

	Select @billingcontactid = billingcontactid from BillingContacts where ClientID = @clientid and IsPrimaryBillingContact = 1
																														
    ;set @S1BillingUserID = @newuserid
		
END

END
Drop table #tmp

select @QBName = BillAsClientName, @BillingContactOut = BillingContactID
from Clients c 
inner join BillingContacts bc on bc.ClientID = c.ClientID and bc.IsPrimaryBillingContact = 1
where c.ClientID = @clientid

END



GO
