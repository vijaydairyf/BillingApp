/****** Object:  StoredProcedure [dbo].[S1_Clients_InvoiceToPaymentSearchByAmount]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_InvoiceToPaymentSearchByAmount]
@ClientID int,
@Amount varchar(4000)
AS
BEGIN

--execute S1_Clients_InvoiceToPaymentSearchByAmount 2827, '2'

;select top 10 i.*, 
		       case
		         when ISNUMERIC(@Amount) = 1 and
				      i.Amount = cast(@Amount as money) then 9999
		         when cast(i.Amount as varchar(4000)) like @Amount + '%' then 9998
		         when cast(i.Amount as varchar(4000)) like '%' + @Amount then 9997
		         when cast(i.Amount as varchar(4000)) like '%' + @Amount + '%' then 9996
		         else 1
		       end as RankNumber
  from Invoices i
  where i.ClientID = @ClientID and
        case
		  when ISNUMERIC(@Amount) = 1 and
			   i.Amount = cast(@Amount as money) then 9999
		  when cast(i.Amount as varchar(4000)) like @Amount + '%' then 9998
		  when cast(i.Amount as varchar(4000)) like '%' + @Amount then 9997
		  when cast(i.Amount as varchar(4000)) like '%' + @Amount + '%' then 9996
		  else 1
		end >= 1
  order by case
             when ISNUMERIC(@Amount) = 1 and
				  i.Amount = cast(@Amount as money) then 9999
		     when cast(i.Amount as varchar(4000)) like @Amount + '%' then 9998
		     when cast(i.Amount as varchar(4000)) like '%' + @Amount then 9997
		     when cast(i.Amount as varchar(4000)) like '%' + @Amount + '%' then 9996
		     else 1
		   end desc,
		   i.InvoiceDate desc,
		   i.InvoiceID desc
				 
END


GO
