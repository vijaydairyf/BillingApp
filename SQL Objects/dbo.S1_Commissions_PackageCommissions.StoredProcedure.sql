/****** Object:  StoredProcedure [dbo].[S1_Commissions_PackageCommissions]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[S1_Commissions_PackageCommissions]
AS
BEGIN

--Exec S1_Commissions_PackageCommissions

;select pc.PackageCommissionID
      ,pc.ClientID
      ,pc.ClientName
      ,pc.PackageName
      ,pc.PackageProducts
      ,pc.PackageCommissionRate
      ,pc.BillingClientID
  from PackageCommissions pc
  order by pc.ClientName,
           pc.PackageName

END



GO
