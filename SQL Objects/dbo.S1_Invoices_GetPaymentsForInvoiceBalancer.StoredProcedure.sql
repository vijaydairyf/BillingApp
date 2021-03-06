/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetPaymentsForInvoiceBalancer]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_GetPaymentsForInvoiceBalancer]
@ClientID int,
@StartDate datetime = null,
@EndDate datetime = null
AS
begin
--Exec S1_Invoices_GetPaymentsForInvoiceBalancer 2827 , '2013-07-01' , '2014-12-31'

;declare @filterStartDate datetime
;declare @filterEndDate datetime

;select @filterStartDate = null,
        @filterEndDate = null

if @StartDate is not null
begin
;select @filterStartDate = convert(datetime,convert(varchar(75),@StartDate,101),101)
end

if @EndDate is not null
begin
;select @filterEndDate = convert(datetime,convert(varchar(75),@EndDate,101),101)
;select @filterEndDate = DATEADD(day, 1, @filterEndDate)
end

;declare @clients table(clientID int)

;insert into @clients(clientId)
select ac.ClientID
  from fnAllSubClients(@ClientID) ac

;select @ClientID as RootParentClientID,
        c.ParentClientID,
		pc.ClientName as ParentClientName,
		sc.ClientID,
        c.ClientName,
		cast(case when p.BillingContactID is not null then 1 else 0 end as bit) as IsPaymentContact,
		cc.ClientContactID,
        cc.ContactLastName,
		cc.ContactFirstName,
        p.*,
		cast(case when ip.InvoicePaymentID is not null and
		               ip.InvoiceID = i.InvoiceID and
					   ip.PaymentID = p.PaymentID then 1 else 0 end as bit) as IsPaymentInvoice,
		i.InvoiceID,
		i.InvoiceNumber,
		i.InvoiceDate,
		i.InvoiceTypeID,
		i.BillTo,
		i.POName,
		i.PONumber,
		i.Amount,
		i.InvoiceExported,
		i.InvoiceExportedOn,
		i.RelatedInvoiceID,
		i.DontShowOnStatement,
		case when ip.InvoicePaymentID is not null and
		               ip.InvoiceID = i.InvoiceID and
					   ip.PaymentID = p.PaymentID then ip.InvoicePaymentID
			 else null
		end as InvoicePaymentID,
		case when ip.InvoicePaymentID is not null and
		               ip.InvoiceID = i.InvoiceID and
					   ip.PaymentID = p.PaymentID then ip.QBTransactionID
			 else null
		end as IpQBTransactionID,
		case when ip.InvoicePaymentID is not null and
		               ip.InvoiceID = i.InvoiceID and
					   ip.PaymentID = p.PaymentID then ip.Amount
			 else null
		end as IpAmount
  from @clients sc
	   inner join Clients c on c.clientID = sc.clientID
	   left join ClientContacts cc on cc.ClientID = sc.clientID
       left join BillingContacts bc on bc.ClientID = sc.clientID and
	                                   bc.ClientContactID = cc.ClientContactID
	   left join Payments p on p.BillingContactID = bc.BillingContactID and
	                           (p.[Date] >= @filterStartDate or @filterStartDate is null) and
                               (p.[Date] < @filterEndDate or @filterEndDate is null)
	   left join InvoicePayments ip on ip.PaymentID = p.PaymentID
	   left join Invoices i on i.ClientID = sc.clientID and
	                           (
							    (
								 (i.InvoiceDate >= @filterStartDate or @filterStartDate is null) and
							     (i.InvoiceDate < @filterEndDate or @filterEndDate is null) and
								 i.Released > 0
								) or
                                i.InvoiceID = ip.InvoiceID
							   )
	   left join Clients pc on pc.ClientID = c.ParentClientID
  order by case when c.ParentClientID is null then 0 else 1 end asc,
           case when c.ParentClientID = @ClientID then 0 else 1 end asc,
           pc.ClientName asc,
		   c.ClientName asc,
		   case when p.PaymentID is not null then 0 else 1 end asc,
		   case 
		     when i.InvoiceDate > p.[Date] then i.InvoiceDate
		     when i.InvoiceDate < p.[Date] then p.[Date]
			 else coalesce(p.[Date], i.InvoiceDate)
           end desc,		    
           p.[Date] desc,
		   i.InvoiceDate desc,
		   cc.ContactFirstName asc,
		   cc.ContactLastName asc

end


GO
