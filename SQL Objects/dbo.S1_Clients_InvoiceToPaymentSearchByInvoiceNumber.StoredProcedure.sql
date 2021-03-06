/****** Object:  StoredProcedure [dbo].[S1_Clients_InvoiceToPaymentSearchByInvoiceNumber]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_InvoiceToPaymentSearchByInvoiceNumber]
@ClientID int,
@InvoiceNumber varchar(4000)
AS
BEGIN

--execute S1_Clients_InvoiceToPaymentSearchByInvoiceNumber 2827, '2'

;select top 10 i.*, 
		       case
		         when i.InvoiceNumber = @InvoiceNumber then 9999
		         when i.InvoiceNumber like @InvoiceNumber + '%' then 9998
		         when i.InvoiceNumber like '%' + @InvoiceNumber then 9997
		         when i.InvoiceNumber like '%' + @InvoiceNumber + '%' then 9996
		         else 1
		       end as RankNumber
  from Invoices i
  where i.ClientID = @ClientID and
        case
		  when i.InvoiceNumber = @InvoiceNumber then 9999
		  when i.InvoiceNumber like @InvoiceNumber + '%' then 9998
		  when i.InvoiceNumber like '%' + @InvoiceNumber then 9997
		  when i.InvoiceNumber like '%' + @InvoiceNumber + '%' then 9996
		  else 1
		end >= 1
  order by case
		     when i.InvoiceNumber = @InvoiceNumber then 9999
		     when i.InvoiceNumber like @InvoiceNumber + '%' then 9998
		     when i.InvoiceNumber like '%' + @InvoiceNumber then 9997
		     when i.InvoiceNumber like '%' + @InvoiceNumber + '%' then 9996
		     else 1
		   end desc,
		   i.InvoiceDate desc,
		   i.InvoiceNumber desc,
		   i.InvoiceID desc
				 
END


GO
