/****** Object:  StoredProcedure [dbo].[S1_Commissions_RemovePackageCommissions]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[S1_Commissions_RemovePackageCommissions]
@PackageCommissionID int
AS
BEGIN

--Exec S1_Commissions_RemovePackageCommissions -1

;delete from PackageCommissions
   output DELETED.PackageCommissionID,
          DELETED.ClientID,
          DELETED.ClientName,
          DELETED.PackageName,
          DELETED.PackageProducts,
          DELETED.PackageCommissionRate,
          DELETED.BillingClientID
   where PackageCommissionID = @PackageCommissionID       

END

GO
