/****** Object:  StoredProcedure [dbo].[S1_BillingImport_UpdateTaz1StateMVRAccessFees]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec S1_BillingImport_UpdateTaz1StateMVRAccessFees 

CREATE PROCEDURE [dbo].[S1_BillingImport_UpdateTaz1StateMVRAccessFees]

AS
SET NOCOUNT ON;
Begin

	DECLARE @errorcode int,
			@productdesc varchar(max),
			@state varchar(2),
			@cost1 money,
			@cost2 money,
			@producttransactionid int
			
	DECLARE @tmp_TDI TABLE (
			ProductTransactionID int, 
			state varchar(2),
			cost1 money,
			cost2 money)
	
	Set @errorcode = 0
		
	DECLARE getcosts cursor for
	select case when charindex(' ', ltrim(rtrim(right(productdescription, len(productdescription) - (charindex('($', ProductDescription, 0)-3)))), 1) = 2 
				then left(ltrim(rtrim(right(productdescription, len(productdescription) - (charindex('($', ProductDescription, 0)-4)))), 2) + right(ltrim(rtrim(right(productdescription, len(productdescription) - (charindex('($', ProductDescription, 0)-4)))), len(ltrim(rtrim(right(productdescription, len(productdescription) - (charindex('($', ProductDescription, 0)-4))))) - 3)
				else ltrim(rtrim(right(productdescription, len(productdescription) - (charindex('($', ProductDescription, 0)-3))))
				end, ProductTransactionID
	from ProductTransactions PT
	inner join Clients C on C.ClientID = PT.ClientID
	where c.Clientid in (289)
	  and ImportBatchID = (select max(ImportBatchID) from ImportBatch where ImportBatchVendorID = 1 and ImportSuccess = 1)
	  and ProductDescription like ('%($%+%)%')
	  order by ltrim(rtrim(right(productdescription, len(productdescription) - (charindex('($', ProductDescription, 0)-3))))

	open getcosts
	fetch getcosts into @productdesc, @producttransactionid

	while (@@FETCH_STATUS = 0)
	BEGIN

		while (LEN(@productdesc) > 0)
		BEGIN

		set @state = SUBSTRING(@productdesc, 1, 2)
		set @cost1 = SUBSTRING(@productdesc, 5, (charindex('+', @productdesc, 5)-5))
		set @cost2 = SUBSTRING(@productdesc, charindex('+', @productdesc, 1) + 1, charindex(')', @productdesc, 5)- charindex('+', @productdesc, 5)-1)
		
		insert into @tmp_TDI (ProductTransactionID, state, Cost1, Cost2)
		values (@producttransactionid,  @state, @cost1, @cost2)
 
 		set @productdesc = case when CHARINDEX(', ', @productdesc, 1) = 0 then RIGHT(@productdesc, len(@productdesc) - CHARINDEX(')', @productdesc, 1)) else RIGHT(@productdesc, len(@productdesc) - CHARINDEX(', ', @productdesc, 1)-1) end 
	    
		if(CHARINDEX('($', @productdesc, 1) = 0)
		begin

			set @productdesc = ''
		end
	  
  		END
		
		fetch getcosts into @productdesc, @producttransactionid

	END

	close getcosts
	deallocate getcosts

	Declare @TransID int, @productid int, @productname varchar(max), @st varchar(2), @price money, @transid2 int = null


	Declare updateproduct cursor for
	select ProductTransactionID, P.ProductID, P.ProductName, [state], SUM(cost1+cost2) as Price
	from @tmp_TDI, Products P
	where P.ProductCode = 'STMVRA_' + [state]
	group by state, ProductTransactionID, ProductID, productname
	order by ProductTransactionID

	open updateproduct
	fetch updateproduct into @TransID, @productid, @productname, @st, @price

	While (@@FETCH_STATUS = 0)
	BEGIN

		if (@transid2 <> @TransID)
		BEGIN
		
			update ProductTransactions
			set ProductID = @productid, ProductName = @productname, ProductDescription = @productname, ProductType = 'STATE FEE', ProductPrice = @price
			where ProductTransactionID = @TransID
		END
		ELSE
		BEGIN
			Insert INTO ProductTransactions (ProductID, ClientID, VendorID, TransactionDate, DateOrdered, OrderBy, Reference, 
			FileNum, FName, LName, MName, SSN, ProductName, ProductDescription, ProductType, ProductPrice, ExternalInvoiceNumber, 
			SalesRep, CoLName, CoFName, CoMName, CoSSN, ImportBatchID)
			select @productid, ClientID, VendorID, TransactionDate, DateOrdered, OrderBy, Reference, 
			FileNum, FName, LName, MName, SSN, @productname, @productname, 'STATE FEE', @price, ExternalInvoiceNumber, 
			SalesRep, CoLName, CoFName, CoMName, CoSSN, ImportBatchID
			from ProductTransactions
			where ProductTransactionID = @TransID
			
		END
		
		set @transid2 = @TransID
		
		fetch updateproduct into @TransID, @productid, @productname, @st, @price
		
	END

	close updateproduct
	deallocate updateproduct


	  
	if(@@ERROR <> 0)
	Begin
		set @errorcode = -1
	End	

	
    return @errorcode

END	







GO
