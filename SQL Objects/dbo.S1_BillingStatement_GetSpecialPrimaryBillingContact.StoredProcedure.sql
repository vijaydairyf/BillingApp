/****** Object:  StoredProcedure [dbo].[S1_BillingStatement_GetSpecialPrimaryBillingContact]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC S1_BillingStatement_GetSpecialPrimaryBillingContact 

CREATE PROCEDURE [dbo].[S1_BillingStatement_GetSpecialPrimaryBillingContact]
(
	@billingcontactid int
)
AS
	SET NOCOUNT ON;

SELECT DISTINCT BillingContactID 
FROM InvoiceSplitBillingContacts 
WHERE IsPrimaryBillingContact=1 
  and BillingContactID = @billingcontactid


GO
