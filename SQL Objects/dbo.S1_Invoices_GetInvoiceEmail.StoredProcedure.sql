/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetInvoiceEmail]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_Invoices_GetInvoiceEmail 49215

CREATE PROCEDURE [dbo].[S1_Invoices_GetInvoiceEmail]
(
	@InvoiceID int
)
AS
	SET NOCOUNT ON;

SELECT c.ClientName, am.LoweredEmail, i.InvoiceDate, u.UserID
FROM Invoices i
inner join Clients c on c.ClientID = i.ClientID
inner join ClientContacts cc on cc.ClientID = c.clientid
inner join BillingContacts bc on bc.clientcontactid = cc.ClientContactID
inner join InvoiceBillingContacts ibc on ibc.InvoiceID = i.InvoiceID and ibc.BillingContactID = bc.BillingContactID
inner join Users u on u.UserID = cc.UserID
inner join aspnet_Membership am on am.UserId = u.UserGUID
WHERE i.InvoiceID = @invoiceid
  AND bc.DeliveryMethod = 0
  AND bc.BillingContactStatus = 1
  AND am.IsApproved = 1

  
 
  

GO
