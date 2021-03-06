/****** Object:  StoredProcedure [dbo].[S1_Clients_PaymentToInvoiceSearchByAmount]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_PaymentToInvoiceSearchByAmount]
@ClientID int,
@TotalAmount varchar(4000)
AS
BEGIN

--execute S1_Clients_PaymentToInvoiceSearchByAmount 2827, '2'

;select distinct
        top 10 p.*, 
		       case
		         when ISNUMERIC(@TotalAmount) = 1 and
				      p.TotalAmount = cast(@TotalAmount as money) then 9999
		         when cast(p.TotalAmount as varchar(4000)) like @TotalAmount + '%' then 9998
		         when cast(p.TotalAmount as varchar(4000)) like '%' + @TotalAmount then 9997
		         when cast(p.TotalAmount as varchar(4000)) like '%' + @TotalAmount + '%' then 9996
		         else 1
		       end as RankNumber,
		rtrim(coalesce(cc.ContactFirstName,'') + ' ' + coalesce(cc.ContactLastName,'')) as ContactName
  from Payments p
       inner join BillingContacts bc on bc.BillingContactID = p.BillingContactID
	   left join ClientContacts cc on cc.ClientContactID = bc.ClientContactID
  where bc.ClientID = @ClientID and
        case
		  when ISNUMERIC(@TotalAmount) = 1 and
			   p.TotalAmount = cast(@TotalAmount as money) then 9999
		  when cast(p.TotalAmount as varchar(4000)) like @TotalAmount + '%' then 9998
		  when cast(p.TotalAmount as varchar(4000)) like '%' + @TotalAmount then 9997
		  when cast(p.TotalAmount as varchar(4000)) like '%' + @TotalAmount + '%' then 9996
		  else 1
		end >= 1
  order by case
		     when ISNUMERIC(@TotalAmount) = 1 and
				  p.TotalAmount = cast(@TotalAmount as money) then 9999
		     when cast(p.TotalAmount as varchar(4000)) like @TotalAmount + '%' then 9998
		     when cast(p.TotalAmount as varchar(4000)) like '%' + @TotalAmount then 9997
		     when cast(p.TotalAmount as varchar(4000)) like '%' + @TotalAmount + '%' then 9996
		     else 1
		   end desc,
		   p.[Date] desc,
		   p.PaymentID desc
				 
END


GO
