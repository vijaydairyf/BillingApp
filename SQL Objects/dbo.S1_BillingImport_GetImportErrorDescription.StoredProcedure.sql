/****** Object:  StoredProcedure [dbo].[S1_BillingImport_GetImportErrorDescription]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec S1_BillingImport_GetImportErrorDescription 123456

CREATE PROCEDURE [dbo].[S1_BillingImport_GetImportErrorDescription]
(
	@importid int
)
AS
SET NOCOUNT ON;
		
Begin

SELECT ProductDesc
FROM TazworksImport
WHERE ImportID = @importid

End





GO
