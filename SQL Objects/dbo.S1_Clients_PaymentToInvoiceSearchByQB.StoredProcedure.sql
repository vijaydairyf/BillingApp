/****** Object:  StoredProcedure [dbo].[S1_Clients_PaymentToInvoiceSearchByQB]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_PaymentToInvoiceSearchByQB]
@ClientID int,
@QBTransactionID varchar(4000)
AS
BEGIN

--execute S1_Clients_PaymentToInvoiceSearchByQB 2827, '29B'

;select distinct
        top 10 p.*, 
		       case
		         when p.QBTransactionID = @QBTransactionID then 9999
		         when p.QBTransactionID like @QBTransactionID + '%' then 9998
		         when p.QBTransactionID like '%' + @QBTransactionID then 9997
		         when p.QBTransactionID like '%' + @QBTransactionID + '%' then 9996
		         else 1
		       end as RankNumber,
		rtrim(coalesce(cc.ContactFirstName,'') + ' ' + coalesce(cc.ContactLastName,'')) as ContactName
  from Payments p
       inner join BillingContacts bc on bc.BillingContactID = p.BillingContactID
	   left join ClientContacts cc on cc.ClientContactID = bc.ClientContactID
  where bc.ClientID = @ClientID and
        case 
		  when p.QBTransactionID = @QBTransactionID then 9999
		  when p.QBTransactionID like @QBTransactionID + '%' then 9998
		  when p.QBTransactionID like '%' + @QBTransactionID then 9997
		  when p.QBTransactionID like '%' + @QBTransactionID + '%' then 9996
		  else 1
		end >= 1
  order by case
		     when p.QBTransactionID = @QBTransactionID then 9999
		     when p.QBTransactionID like @QBTransactionID + '%' then 9998
		     when p.QBTransactionID like '%' + @QBTransactionID then 9997
		     when p.QBTransactionID like '%' + @QBTransactionID + '%' then 9996
		     else 1
		   end desc,
		   p.[Date] desc,
		   p.PaymentID desc
				 
END


GO
