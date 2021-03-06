/****** Object:  StoredProcedure [dbo].[S1_BillingImport_UpdateTaz1StateMVRRecords]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Exec S1_BillingImport_UpdateTaz1StateMVRRecords 

CREATE PROCEDURE [dbo].[S1_BillingImport_UpdateTaz1StateMVRRecords]

AS
SET NOCOUNT ON;
Begin

	DECLARE @errorcode int,
			@productdesc varchar(max),
			@state varchar(2),
			@producttransactionid int
			
	DECLARE @tmp_TDI TABLE (
			ProductTransactionID int, 
			state varchar(2))
			
	Set @errorcode = 0

		
	DECLARE getstates cursor for
	select ltrim(rtrim(right(productdescription, len(productdescription) - (charindex('(', ProductDescription, 0))))), 
	ProductTransactionID
	from ProductTransactions PT
	inner join Clients C on C.ClientID = PT.ClientID
	where c.Clientid in (289)
	  and ImportBatchID = (select max(ImportBatchID) from ImportBatch where ImportBatchVendorID = 1 and ImportSuccess = 1)
	  and ProductDescription like ('%(%)%') and ProductDescription not like ('%($%+%)%') and ProductDescription not like ('%(%+%)%')
	  and productid = 156
	  order by ProductTransactionID

	open getstates
	fetch getstates into @productdesc, @producttransactionid

	while (@@FETCH_STATUS = 0)
	BEGIN

		while (LEN(@productdesc) > 0)
		BEGIN
		set @state = SUBSTRING(@productdesc, 1, 2)

		insert into @tmp_TDI (ProductTransactionID, state)
		values (@producttransactionid,  @state)
		
		set @productdesc = case when CHARINDEX(',', @productdesc, 1) = 0 then RIGHT(@productdesc, len(@productdesc) - CHARINDEX(')', @productdesc, 1)) else RIGHT(@productdesc, len(@productdesc) - CHARINDEX(',', @productdesc, 1)-1) end 
	  
		if(CHARINDEX(')', @productdesc, 1) = 0)
		begin

			set @productdesc = ''
		end
	  
  		END
		
		fetch getstates into @productdesc, @producttransactionid

	END

	close getstates
	deallocate getstates


	Declare @TransID int, @productid int, @productname varchar(max), @st varchar(2), @price money, @transid2 int 
	
	set @transid2 = 0


	Declare updateproduct cursor for
	select ProductTransactionID, P.ProductID, P.ProductName, [state], 1.25 as Price
	from @tmp_TDI, Products P
	where P.ProductID = 156
	group by state, ProductTransactionID, ProductID, productname
	order by ProductTransactionID

	open updateproduct
	fetch updateproduct into @TransID, @productid, @productname, @st, @price

	While (@@FETCH_STATUS = 0)
	BEGIN

		if (@transid2 <> @TransID)
		BEGIN
		
			update ProductTransactions
			set ProductID = @productid, ProductDescription = a.ProductDescription, ProductPrice = @price
			from 
			(select (case when CharIndex(')', ProductDescription, 1) - CharIndex('(', ProductDescription, 1) > 4 
				 then ProductDescription + ' - ' + @st 
				 else ProductDescription
			end) as ProductDescription, ProductTransactionID
			from 
			ProductTransactions
			where ProductTransactionID = @TransID
			)a
			where a.ProductTransactionID = ProductTransactions.ProductTransactionID 
			  and ProductTransactions.ProductTransactionID = @TransID
		END
		ELSE
		BEGIN
			Insert INTO ProductTransactions (ProductID, ClientID, VendorID, TransactionDate, DateOrdered, OrderBy, Reference, 
			FileNum, FName, LName, MName, SSN, ProductName, ProductDescription, ProductType, ProductPrice, ExternalInvoiceNumber, 
			SalesRep, CoLName, CoFName, CoMName, CoSSN, ImportBatchID)
			select @productid, ClientID, VendorID, TransactionDate, DateOrdered, OrderBy, Reference, 
			FileNum, FName, LName, MName, SSN, ProductName, 
			case when charindex('-', ProductDescription, CharIndex(')', ProductDescription, 1)) = (len(ProductDescription) - 3)
			     then left(ProductDescription, LEN(ProductDescription) - 5) + ' - ' + @st
			     else ProductDescription + ' - ' + @st
			     end as ProductDescription, ProductType,  @price, ExternalInvoiceNumber, 
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
