/****** Object:  StoredProcedure [dbo].[S1_Vendors_GetVendorList]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC S1_Vendors_GetVendorList

CREATE PROCEDURE [dbo].[S1_Vendors_GetVendorList]
AS
	SET NOCOUNT ON;
	
SELECT VendorID, VendorName
FROM Vendors
ORDER BY VendorName
GO
