/****** Object:  StoredProcedure [dbo].[S1_Clients_GetClientListForInvoiceBalancer]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Clients_GetClientListForInvoiceBalancer]
AS
BEGIN
    --EXEC S1_Clients_GetClientListForInvoiceBalancer
    
    select c.ClientID,
	       c.ClientName
	  from Clients c
	  where c.ParentClientID is null
	  order by c.ClientName
				 
END


GO
