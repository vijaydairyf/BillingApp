/****** Object:  StoredProcedure [dbo].[S1_Clients_GetClientsWithInvoices]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_Clients_GetClientsWithInvoices 

CREATE PROCEDURE [dbo].[S1_Clients_GetClientsWithInvoices]

AS
	SET NOCOUNT ON;
	
SELECT DISTINCT C.ClientID,C.ClientName,C.Address1,C.Address2,c.City, c.[State], c.ZipCode, 
c.ParentClientID, ISNULL(C2.ClientName,'') as ParentClientName,
C.BillAsClientName,BG.BillingGroupID,BG.BillingGroupName,C.[Status]
FROM dbo.Clients C
INNER JOIN BillingGroups BG
	ON C.BillingGroup=BG.BillingGroupID
INNER JOIN Invoices I
	ON I.ClientID=C.ClientID
	AND I.VoidedOn IS NULL
LEFT JOIN Clients C2
	ON C2.ClientID=C.ParentClientID
ORDER BY C.ClientName

GO
