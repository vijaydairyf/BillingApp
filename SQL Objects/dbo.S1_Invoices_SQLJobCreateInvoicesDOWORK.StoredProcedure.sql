/****** Object:  StoredProcedure [dbo].[S1_Invoices_SQLJobCreateInvoicesDOWORK]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_SQLJobCreateInvoicesDOWORK]
AS
BEGIN

;declare @StartTransactionDate datetime,
 	     @EndTransactionDate datetime,
	     @InvoiceDate datetime,
	     @BillingGroup int,
		 @UserId int

;declare @users table(UserId int)

declare mycursor scroll cursor
for
select distinct
       sci.StartTransactionDate,
       sci.EndTransactionDate,
       sci.InvoiceDate,
       sci.BillingGroup,
	   sci.UserId
  from SQLJobCreateInvoices sci
  where sci.[Started] = 0

open mycursor
fetch mycursor into @StartTransactionDate,
	                @EndTransactionDate,
	                @InvoiceDate,
	                @BillingGroup,
					@UserId

while (@@FETCH_STATUS = 0)
BEGIN

;update SQLJobCreateInvoices
   set [Started] = 1
   where StartTransactionDate = @StartTransactionDate and
	     EndTransactionDate = @EndTransactionDate and
	     InvoiceDate = @InvoiceDate and
         BillingGroup = @BillingGroup

fetch mycursor into @StartTransactionDate,
	                @EndTransactionDate,
	                @InvoiceDate,
	                @BillingGroup,
					@UserId

END

fetch first from mycursor into @StartTransactionDate,
	                           @EndTransactionDate,
	                           @InvoiceDate,
	                           @BillingGroup,
							   @UserId

while (@@FETCH_STATUS = 0)
BEGIN

insert into @users(UserId)
select @UserId as UserId
  where not exists(select u.UserId
                     from @users u
					 where u.UserId = @UserId)

fetch mycursor into @StartTransactionDate,
	                @EndTransactionDate,
	                @InvoiceDate,
	                @BillingGroup,
					@UserId

END

fetch first from mycursor into @StartTransactionDate,
	                           @EndTransactionDate,
	                           @InvoiceDate,
	                           @BillingGroup,
							   @UserId

while (@@FETCH_STATUS = 0)
BEGIN

;exec S1_Invoices_CreateInvoices @StartTransactionDate, @EndTransactionDate, @InvoiceDate, @BillingGroup

;update SQLJobCreateInvoices
   set [Started] = 1,
       Done = 1
   where StartTransactionDate = @StartTransactionDate and
	     EndTransactionDate = @EndTransactionDate and
	     InvoiceDate = @InvoiceDate and
         BillingGroup = @BillingGroup

fetch mycursor into @StartTransactionDate,
	                @EndTransactionDate,
	                @InvoiceDate,
	                @BillingGroup,
					@UserId

END

close mycursor
deallocate mycursor

IF (select count(u.UserId) from @users u) > 0
BEGIN

;declare @tempTable table(ClientName varchar(4000), InvoiceNumber varchar(255))
 
;insert into @tempTable
exec S1_Invoices_GetLastInvoicesCreated

;declare @messagebody varchar(max)
;declare @messagesubject varchar(max)
;declare @sentdate datetime

;select @messagebody = '<p>Your invoices have been created, you can now continue:</p>',
        @messagesubject = 'Create Invoices Complete',
		@sentdate = getdate()

;select @messagebody = @messagebody + '<br />' + tt.ClientName + ' - ' + tt.InvoiceNumber
   from @tempTable tt

;insert into [Messages](MessageGUID, MessageType, ToContactType, MessageTo, FromContactType, MessageFrom, MessageSubject, MessageText, [SentDate], [Status], [BodyFormat])
select newid() as MessageGUID,
       3 as MessageType,
       1 as ToContactType,
       u.UserId as MessageTo,
	   3 as FromContactType,
	   0 as MessageFrom,
       @messagesubject as MessageSubject,
       @messagebody as MessageText,
	   @sentdate as [SentDate],
	   1 as [Status],
	   'HTML' as [BodyFormat]
   from @users u
   
;Exec S1_Messages_SendEmails

END

END


GO
