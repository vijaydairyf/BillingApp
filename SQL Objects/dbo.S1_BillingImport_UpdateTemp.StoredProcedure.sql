/****** Object:  StoredProcedure [dbo].[S1_BillingImport_UpdateTemp]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[S1_BillingImport_UpdateTemp]
@EDrugTempLoaded bit,
@ExperianTempLoaded bit,
@QuickbooksTempLoaded bit,
@TazWorksTempLoaded bit,
@TransUnionTempLoaded bit
AS
BEGIN

if (select count(QuickbooksTempLoaded) from TempLoaded) <= 0
begin

;insert into TempLoaded(EDrugTempLoaded,
                        ExperianTempLoaded,
                        QuickbooksTempLoaded,
                        TazWorksTempLoaded,
                        TransUnionTempLoaded)
values (0,0,0,0,0)

end

;update TempLoaded
   set EDrugTempLoaded = coalesce(@EDrugTempLoaded,EDrugTempLoaded)
       ,ExperianTempLoaded = coalesce(@ExperianTempLoaded,ExperianTempLoaded)
       ,QuickbooksTempLoaded = coalesce(@QuickbooksTempLoaded,QuickbooksTempLoaded)
       ,TazWorksTempLoaded = coalesce(@TazWorksTempLoaded,TazWorksTempLoaded)
       ,TransUnionTempLoaded = coalesce(@TransUnionTempLoaded,TransUnionTempLoaded)



END


GO
