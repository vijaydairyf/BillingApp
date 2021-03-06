/****** Object:  StoredProcedure [dbo].[S1_BillingImport_GetImportError]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		overridepro
-- Description:	Get Import Error
-- =============================================
CREATE PROCEDURE [dbo].[S1_BillingImport_GetImportError]
	-- Add the parameters for the stored procedure here
	@ImportID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP(1) ProductName, ProductType, ItemCode, ProductDesc FROM TazworksImport
	WHERE ImportID=@ImportID
END

GO
