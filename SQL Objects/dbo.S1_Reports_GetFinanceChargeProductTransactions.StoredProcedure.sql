/****** Object:  StoredProcedure [dbo].[S1_Reports_GetFinanceChargeProductTransactions]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--EXEC S1_Reports_GetFinanceChargeProductTransactions '01/01/2012','01/31/2012'

CREATE PROCEDURE [dbo].[S1_Reports_GetFinanceChargeProductTransactions]
(
	@TransactionStartDate datetime,
	@TransactionEndDate datetime
)
AS
	SET NOCOUNT ON;

SELECT C.ClientID, C.ClientName, p.TransactionDate, 
	p.FileNum,
'OverdueInvoice' = P.ProductDescription,
P.ProductPrice
FROM ProductTransactions P 
	INNER JOIN Clients C 
		ON p.ClientID=C.ClientID
WHERE p.transactiondate BETWEEN @TransactionStartDate AND @TransactionEndDate
AND P.ProductID = 372





GO
