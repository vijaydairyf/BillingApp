/****** Object:  StoredProcedure [dbo].[S1_BillingStatement_AddBillingPackagePrinted]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_BillingStatement_AddBillingPackagePrinted 

CREATE PROCEDURE [dbo].[S1_BillingStatement_AddBillingPackagePrinted]
(
	@BillingContactID int,
	@PackageEndDate datetime,
	@PrintedByUser int
)
AS
	SET NOCOUNT ON;
	
	INSERT INTO BillingPackagePrinted (BillingContactID, PackageEndDate, PrintedOn, PrintedByUser)
	VALUES (@BillingContactID, @PackageEndDate, GETDATE(), @PrintedByUser)
GO
