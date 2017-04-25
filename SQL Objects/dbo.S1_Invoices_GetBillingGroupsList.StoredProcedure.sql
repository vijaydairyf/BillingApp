/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetBillingGroupsList]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Invoices_GetBillingGroupsList]
AS
	SET NOCOUNT ON;

SELECT 0 as BillingGroupID, '[All Clients]' as BillingGroupName
UNION ALL
SELECT BillingGroupID, BillingGroupName
FROM BillingGroups
ORDER BY BillingGroupID

GO
