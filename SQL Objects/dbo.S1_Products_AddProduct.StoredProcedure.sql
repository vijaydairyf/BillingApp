/****** Object:  StoredProcedure [dbo].[S1_Products_AddProduct]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		overridepro - Justin Tabb
-- Description:	Add Product
-- =============================================
CREATE PROCEDURE [dbo].[S1_Products_AddProduct]
	-- Add the parameters for the stored procedure here
	@ProductCode varchar(50), @ProductName varchar(255), @BaseCost money, 
	@BaseCommission money, @IncludeOnInvoice tinyint, @Employment smallmoney, 
	@Tenant smallmoney, @Business smallmoney, @Volunteer smallmoney, 
	@Other smallmoney
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	If Not Exists (select * from Products where ProductCode = @ProductCode)
	BEGIN
		-- Insert statements for procedure here
		INSERT INTO Products(ProductCode, ProductName, BaseCost, BaseCommission, IncludeOnInvoice, 
		Employment, Tenant, Business, Volunteer, Other)
		VALUES(@ProductCode, @ProductName, @BaseCost, @BaseCommission, @IncludeOnInvoice, @Employment, 
		@Tenant, @Business, @Volunteer, @Other)
		
		DECLARE @product_id int
		
		SELECT @product_id=SCOPE_IDENTITY()
		
		SELECT @product_id productID
		
	END
	ELSE
	BEGIN
		SELECT 0 productID
	END

END

GO
