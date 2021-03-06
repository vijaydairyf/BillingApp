/****** Object:  StoredProcedure [dbo].[S1_Invoices_SQLJobCreateInvoices]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_SQLJobCreateInvoices]
(
	@StartTransactionDate datetime,
	@EndTransactionDate datetime,
	@InvoiceDate datetime,
	@BillingGroup int,
	@UserId int
)
AS
BEGIN

;with jobSchedule as (
select @StartTransactionDate as StartTransactionDate,
	   @EndTransactionDate as EndTransactionDate,
	   @InvoiceDate as InvoiceDate,
	   @BillingGroup as BillingGroup,
	   0 as [Started],
	   0 as Done,
	   @UserId as UserId,
	   convert(datetime,convert(varchar(255),getdate(),100),100) as DateEntered --Code 100 = Date Per Minute
)
insert into SQLJobCreateInvoices(StartTransactionDate,
                                 EndTransactionDate,
								 InvoiceDate,
								 BillingGroup,
								 [Started],
								 Done,
								 UserId,
								 DateEntered)
select js.StartTransactionDate,
       js.EndTransactionDate,
	   js.InvoiceDate,
	   js.BillingGroup,
	   js.[Started],
	   js.Done,
	   js.UserId,
	   js.DateEntered
  from jobSchedule js
  where not exists(select sci.Done
                     from SQLJobCreateInvoices sci
					 where sci.StartTransactionDate = js.StartTransactionDate and
					       sci.EndTransactionDate = js.EndTransactionDate and
						   sci.InvoiceDate = js.InvoiceDate and
						   sci.BillingGroup = js.BillingGroup and
						   sci.DateEntered = js.DateEntered)

--IF (@@ROWCOUNT > 0)
--BEGIN
--EXEC msdb.dbo.sp_start_job N'Run S1_Invoices_SQLJobCreateInvoicesDOWORK';
--END

END


GO
