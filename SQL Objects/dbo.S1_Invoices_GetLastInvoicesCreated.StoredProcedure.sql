/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetLastInvoicesCreated]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Invoices_GetLastInvoicesCreated

CREATE PROCEDURE [dbo].[S1_Invoices_GetLastInvoicesCreated]
AS
	SET NOCOUNT ON;	


SELECT C.ClientName, I.InvoiceNumber
from Invoices I
inner join Clients c on c.ClientID = I.ClientID
where i.CreateInvoicesBatchID = (select MAX(CreateInvoicesBatchID) from CreateInvoicesBatch)
and I.VoidedOn is null
GO
