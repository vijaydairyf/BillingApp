/****** Object:  StoredProcedure [dbo].[S1_Clients_PaymentToInvoiceSearchByID]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_PaymentToInvoiceSearchByID]
@ClientID int,
@PaymentID varchar(4000)
AS
BEGIN

--execute S1_Clients_PaymentToInvoiceSearchByID 2827, '2'

;select distinct
        top 10 p.*, 
		       case
		         when cast(p.PaymentID as varchar(4000)) = @PaymentID then 9999
		         when cast(p.PaymentID as varchar(4000)) like @PaymentID + '%' then 9998
		         when cast(p.PaymentID as varchar(4000)) like '%' + @PaymentID then 9997
		         when cast(p.PaymentID as varchar(4000)) like '%' + @PaymentID + '%' then 9996
		         else 1
		       end as RankNumber,
		rtrim(coalesce(cc.ContactFirstName,'') + ' ' + coalesce(cc.ContactLastName,'')) as ContactName
  from Payments p
       inner join BillingContacts bc on bc.BillingContactID = p.BillingContactID
	   left join ClientContacts cc on cc.ClientContactID = bc.ClientContactID
  where bc.ClientID = @ClientID and
        case
		  when cast(p.PaymentID as varchar(4000)) = @PaymentID then 9999
		  when cast(p.PaymentID as varchar(4000)) like @PaymentID + '%' then 9998
		  when cast(p.PaymentID as varchar(4000)) like '%' + @PaymentID then 9997
		  when cast(p.PaymentID as varchar(4000)) like '%' + @PaymentID + '%' then 9996
		  else 1
		end >= 1
  order by case
		     when cast(p.PaymentID as varchar(4000)) = @PaymentID then 9999
		     when cast(p.PaymentID as varchar(4000)) like @PaymentID + '%' then 9998
		     when cast(p.PaymentID as varchar(4000)) like '%' + @PaymentID then 9997
		     when cast(p.PaymentID as varchar(4000)) like '%' + @PaymentID + '%' then 9996
		     else 1
		   end desc,
		   p.[Date] desc,
		   p.PaymentID desc
				 
END


GO
