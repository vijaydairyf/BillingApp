/****** Object:  StoredProcedure [dbo].[S1_BillingImport_ImportEmail]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_BillingImport_ImportEmail]
@VendorID int,
@Errors varchar(max) = '',
@Files varchar(max) = ''
AS
BEGIN

;declare @messagebody varchar(max)
;declare @messagesubject varchar(max)
;declare @sentdate datetime

;select @messagebody = '<p>Files have been imported and are ready for review:</p>',
        @messagesubject = 'Files Imported - Ready For Review',
		@sentdate = getdate()

;select @messagebody = @messagebody + '<br />' + '<a href="' + dbo.udf_GetApplicationURL() + '/BillingImport/VerifyImport?vendorid=' + cast(@VendorID as varchar(max)) + '">Click Here To Review</a>'

if rtrim(ltrim(@Errors)) != ''
begin
;select @messagebody = @messagebody + '<br />Errors:<br />' + rtrim(ltrim(@Errors))
end

if rtrim(ltrim(@Files)) != ''
begin
;select @messagebody = @messagebody + '<br />Files:<br />' + rtrim(ltrim(@Files))
end

;insert into [Messages](MessageGUID, MessageType, ToContactType, MessageTo, FromContactType, MessageFrom, MessageSubject, MessageText, [SentDate], [Status], [BodyFormat])
select newid() as MessageGUID,
       7 as MessageType,
       1 as ToContactType,
       u.UserID as MessageTo,
	   3 as FromContactType,
	   0 as MessageFrom,
       @messagesubject as MessageSubject,
       @messagebody as MessageText,
	   @sentdate as [SentDate],
	   1 as [Status],
	   'HTML' as [BodyFormat]
  from aspnet_Users au 
	   inner join aspnet_Membership am on am.UserId = au.UserId
	   inner join Users u on u.UserGUID = au.UserId
  where au.UserName in (
		        'screeningone'
--              ,
--		        'dtonkinadmin'
		)
				

END


GO
