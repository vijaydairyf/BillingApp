/****** Object:  StoredProcedure [dbo].[S1_Clients_InvoiceToPaymentSearchByQB]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_InvoiceToPaymentSearchByQB]
@ClientID int,
@QBTransactionID varchar(4000)
AS
BEGIN

--execute S1_Clients_InvoiceToPaymentSearchByQB 2827, '29B'

;select top 10 i.*, 
		       case
		         when i.QBTransactionID = @QBTransactionID then 9999
		         when i.QBTransactionID like @QBTransactionID + '%' then 9998
		         when i.QBTransactionID like '%' + @QBTransactionID then 9997
		         when i.QBTransactionID like '%' + @QBTransactionID + '%' then 9996
		         else 1
		       end as RankNumber
  from Invoices i
  where i.ClientID = @ClientID and
        case
		  when i.QBTransactionID = @QBTransactionID then 9999
		  when i.QBTransactionID like @QBTransactionID + '%' then 9998
		  when i.QBTransactionID like '%' + @QBTransactionID then 9997
		  when i.QBTransactionID like '%' + @QBTransactionID + '%' then 9996
		  else 1
		end >= 1
  order by case
		     when i.QBTransactionID = @QBTransactionID then 9999
		     when i.QBTransactionID like @QBTransactionID + '%' then 9998
		     when i.QBTransactionID like '%' + @QBTransactionID then 9997
		     when i.QBTransactionID like '%' + @QBTransactionID + '%' then 9996
		     else 1
		   end desc,
		   i.InvoiceDate desc,
		   i.InvoiceNumber desc,
		   i.InvoiceID desc
				 
END


GO
