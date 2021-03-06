/****** Object:  StoredProcedure [dbo].[S1_Clients_GetClientVendorsList]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[S1_Clients_GetClientVendorsList]
(
	@ClientID int
)
AS
	SET NOCOUNT ON;
	
SELECT v.VendorID, v.VendorName
from Vendors v
inner join ClientVendors cv on cv.VendorID = v.VendorID
Where cv.ClientID = @ClientID


GO
