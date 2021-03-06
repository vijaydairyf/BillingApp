/****** Object:  StoredProcedure [dbo].[S1_BillingImport_GetVendorProducts]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec S1_BillingImport_GetVendorProducts 2, 17045 --Vendorid, ImportID

CREATE PROCEDURE [dbo].[S1_BillingImport_GetVendorProducts]
(
	@vendorid int,
	@importid int
)
AS
SET NOCOUNT ON;
		
DECLARE @clientid int

if (@vendorid = 1)
BEGIN
select @clientid= (
	select clientid from ClientVendors
	where VendorID = @vendorid 
	  and VendorClientNumber = (select ClientNumber from TazworksImport where ImportID = @importid))
END

if (@vendorid = 2)
BEGIN
select @clientid= (
	select clientid from ClientVendors
	where VendorID = @vendorid 
	  and VendorClientNumber = (select ClientNumberOrdered from TazworksImport where ImportID = @importid))
END

if (@vendorid = 4)
BEGIN
	select @clientid= (
	select clientid from ClientVendors
	where VendorID = @vendorid 
	  and VendorClientNumber = (select TUSubscriberID from TransUnionImport where ImportID = @importid))
END

if (@vendorid = 5)
BEGIN
	select @clientid= (
	select clientid from ClientVendors
	where VendorID = @vendorid 
	  and VendorClientNumber = (select XPSubcode from ExperianImport where ImportID = @importid))
END
		
Begin

SELECT P.ProductCode, P.ProductName + ' - ' + P.ProductCode as ProductName
FROM Products P
INNER JOIN VendorProducts VP on P.ProductID = VP.ProductID
--INNER JOIN ClientProducts CP on CP.ClientID = @clientid and CP.ProductID = P.ProductID
WHERE VP.VendorID = @vendorid
ORDER BY ProductName


End








GO
