/****** Object:  StoredProcedure [dbo].[S1_BillingImport_UpdateTaz2StateMVRAccessFees]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec S1_BillingImport_UpdateTaz2StateMVRAccessFees 

CREATE PROCEDURE [dbo].[S1_BillingImport_UpdateTaz2StateMVRAccessFees]

AS
SET NOCOUNT ON;
Begin

Declare @errorcode int

Set @errorcode = 0

UPDATE PT1
SET ProductID=P.ProductID, 
ProductDescription=P.ProductName
FROM ProductTransactions PT1
INNER JOIN Products P
ON P.ProductCode='STMVRS_' + Right(LEFT(PT1.ProductDescription, 31), 2)
WHERE ClientID in (4404, 289)
AND ImportBatchID = (select max(ImportBatchID) from ImportBatch where ImportBatchVendorID = 2 and ImportSuccess = 1)
AND PT1.ProductID = 156

UPDATE PT1
SET ProductID=P.ProductID, 
ProductDescription=P.ProductName,
ProductType = 'STATE FEE'
FROM ProductTransactions PT1
INNER JOIN Products P
ON P.ProductCode='STMVRA_' + Right(LEFT(PT1.ProductDescription, 31), 2)
WHERE ClientID in (4404, 289)
AND ImportBatchID = (select max(ImportBatchID) from ImportBatch where ImportBatchVendorID = 2 and ImportSuccess = 1)
AND PT1.ProductID = 158





/*---Replaced these cursors with code above on 5/08/2015 - Eric Bostrom
Declare @statecode varchar(2), @producttransactionid int, @productid int, @productname varchar(max), @errorcode int


Declare statesearch cursor for
select ProductTransactionID, Right(LEFT(ProductDescription, 31), 2) from ProductTransactions
where ClientID in (4404, 289)
and ImportBatchID = (select max(ImportBatchID) from ImportBatch where ImportBatchVendorID = 2 and ImportSuccess = 1)
and ProductID = 156

Open statesearch
fetch statesearch into @producttransactionid, @statecode

While (@@FETCH_STATUS = 0)
BEGIN

--select @statecode, @producttransactionid, * from Products where ProductCode = 'STMVRS_' + @statecode
select @productid = productid, @productname = productname from Products where ProductCode = 'STMVRS_' + @statecode

select @productid, @productname, @producttransactionid

--update ProductTransactions
--set ProductID = @productid, ProductDescription = @productname
--where ProductTransactionID = @producttransactionid

fetch statesearch into @producttransactionid, @statecode

END

Close statesearch
deallocate statesearch

Set @producttransactionid = 0
Set @productid = 0
Set @productname = null
set @statecode = null


Declare statefee cursor for
select ProductTransactionID, Right(LEFT(ProductDescription, 31), 2) from ProductTransactions
where ClientID in (4404, 289)
and ImportBatchID = (select max(ImportBatchID) from ImportBatch where ImportBatchVendorID = 2 and ImportSuccess = 1)
and ProductID = 158

Open statefee
fetch statefee into @producttransactionid, @statecode

While (@@FETCH_STATUS = 0)
BEGIN

--select @statecode, @producttransactionid, * from Products where ProductCode = 'STMVRA_' + @statecode
select @productid = productid, @productname = productname from Products where ProductCode = 'STMVRA_' + @statecode

select @productid, @productname, @producttransactionid

--update ProductTransactions
--set ProductID = @productid, ProductDescription = @productname, ProductType = 'STATE FEE'
--where ProductTransactionID = @producttransactionid

fetch statefee into @producttransactionid, @statecode

END

Close statefee
deallocate statefee

*/
  
	if(@@ERROR <> 0)
	Begin
		set @errorcode = -1
	End	

	
    return @errorcode

END	







GO
