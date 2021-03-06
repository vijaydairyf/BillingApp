/****** Object:  StoredProcedure [dbo].[S1_Invoices_GetInvoices_DateRange_Paged_AuditOnly]    Script Date: 11/21/2016 9:27:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
Created By:		Rhonda Carey
Created On:		06/28/2011
Description:	Get the invoices for audit only clients

Modified By:
Modified On:
Description:

Test Script:

EXEC S1_Invoices_GetInvoices_DateRange_Paged_AuditOnly '1/1/2010', '12/31/2010', null, null, false, null, 4, null, 1, 100, 'AmountDue', 1


***********************************************************************************/
CREATE PROCEDURE [dbo].[S1_Invoices_GetInvoices_DateRange_Paged_AuditOnly]
(
	@StartDate datetime,
	@EndDate datetime,
	@ClientIDFilter int,
	@BillingContactIDFilter int,
	@BillingContactAnyClient bit,
	@DeliveryMethodFilter int,
	@ReleaseStatusFilter int,
	@InvoiceNumberFilter varchar(50),
	@CurrentPage int,
	@RowsPerPage int,
	@OrderBy varchar(50),
	@OrderDir bit
)
AS
	SET NOCOUNT ON;	
	
	DECLARE @FirstRow int, @LastRow int
	SELECT @FirstRow=((@CurrentPage-1)*@RowsPerPage)+1
	SELECT @LastRow=@FirstRow+(@RowsPerPage-1);
	
IF (@OrderDir=0)
BEGIN

WITH CTE (
	InvoiceID, InvoiceNumber, InvoiceDate, InvoiceTypeID, InvoiceTypeDesc, Amount, OriginalAmount, BillingContactID,
	ClientContactID, ContactName, ClientName, ReleasedStatusText, rownum, Number
)
AS
(
SELECT InvoiceID, InvoiceNumber, InvoiceDate, InvoiceTypeID, InvoiceTypeDesc, Amount, OriginalAmount, BillingContactID,
	ClientContactID, ContactName, ClientName, ReleasedStatusText,
rownum = ROW_NUMBER() OVER (ORDER BY 
	(CASE 
		WHEN @OrderBy='InvoiceDate' THEN CONVERT(char(8),A.InvoiceDate,112) 
		WHEN @OrderBy='InvoiceNumber' THEN A.InvoiceNumber
		WHEN @OrderBy='Type' THEN A.InvoiceTypeDesc
		WHEN @OrderBy='Client' THEN A.ClientName
		WHEN @OrderBy='Status' THEN A.ReleasedStatusText
		WHEN @OrderBy='OriginalAmount' THEN right('0000000000'+ltrim(Convert(varchar(10),A.OriginalAmount)),10)
		WHEN @OrderBy='AmountDue' THEN right('0000000000'+ltrim(Convert(varchar(10),A.Amount)),10)
		ELSE CONVERT(char(8),A.InvoiceDate,112)  
	END
	)
	ASC,A.InvoiceID),
	COUNT(*) OVER () as Number
FROM
(

SELECT I.InvoiceID, I.InvoiceNumber, I.InvoiceDate, I.InvoiceTypeID, 
(CASE WHEN I.VoidedOn IS NULL THEN IT.InvoiceTypeDesc ELSE 'Void' END) as InvoiceTypeDesc,
(CASE WHEN I.VoidedOn IS NULL THEN I.Amount - ISNULL(P.PaymentAmount,0) - ISNULL(CreditAmount,0) ELSE 0 END) as Amount, 
I.Amount as OriginalAmount, BC.BillingContactID, 
BC.ClientContactID, BC.ContactName, C.ClientName, 
(CASE WHEN RS.ReleasedStatusID = 0 THEN RS.ReleasedStatusText
+ (CASE WHEN BC.DeliveryMethod=0 THEN '-Online'
WHEN BC.DeliveryMethod=1 THEN '-Email-Auto'
WHEN BC.DeliveryMethod=2 THEN '-Email-Manual'
WHEN BC.DeliveryMethod=3 THEN '-Mail'
ELSE '' END)
ELSE RS.ReleasedStatusText END) as ReleasedStatusText
FROM Invoices I
INNER JOIN InvoiceTypes IT
	ON IT.InvoiceTypeID=I.InvoiceTypeID
INNER JOIN Clients C
	ON I.ClientID=C.ClientID
INNER JOIN InvoiceBillingContacts IBC
	ON IBC.InvoiceID=I.InvoiceID
	AND IBC.IsPrimaryBillingContact=1
INNER JOIN BillingContacts BC
	ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ReleasedStatus RS
	ON I.Released=RS.ReleasedStatusID
LEFT JOIN (SELECT P1.InvoiceID, SUM(ISNULL(P1.Amount,0)) as PaymentAmount FROM InvoicePayments P1 GROUP BY P1.InvoiceID) P
	 ON I.InvoiceID=P.InvoiceID
LEFT JOIN (SELECT I1.RelatedInvoiceID, SUM(ISNULL(I1.Amount,0)) as CreditAmount FROM Invoices I1 WHERE I1.InvoiceTypeID=3 and I1.VoidedOn is null GROUP BY I1.RelatedInvoiceID) CR
	 ON I.InvoiceID=CR.RelatedInvoiceID
WHERE I.InvoiceDate BETWEEN @StartDate AND @EndDate
AND C.BillingGroup in (2,5)
--AND I.VoidedOn IS NULL
--If @BillingContactAnyClient = 1 Then don't filter by client
AND (C.ClientID=@ClientIDFilter OR @ClientIDFilter IS NULL OR @BillingContactAnyClient=1) 
AND (BC.BillingContactID=@BillingContactIDFilter OR @BillingContactIDFilter IS NULL)
AND (I.Released=@ReleaseStatusFilter OR @ReleaseStatusFilter IS NULL)
AND (BC.DeliveryMethod=@DeliveryMethodFilter OR @DeliveryMethodFilter IS NULL)
AND (I.InvoiceNumber = @InvoiceNumberFilter OR @InvoiceNumberFilter IS NULL)

) A
)
SELECT *
	FROM CTE
	WHERE rownum BETWEEN @FirstRow AND @LastRow
	ORDER BY rownum
	
END
ELSE
BEGIN

WITH CTE (
	InvoiceID, InvoiceNumber, InvoiceDate, InvoiceTypeID, InvoiceTypeDesc, Amount, OriginalAmount, BillingContactID,
	ClientContactID, ContactName, ClientName, ReleasedStatusText, rownum, Number
)
AS
(
SELECT InvoiceID, InvoiceNumber, InvoiceDate, InvoiceTypeID, InvoiceTypeDesc, Amount, OriginalAmount, BillingContactID,
	ClientContactID, ContactName, ClientName, ReleasedStatusText,
rownum = ROW_NUMBER() OVER (ORDER BY 
	(CASE 
		WHEN @OrderBy='InvoiceDate' THEN CONVERT(char(8),A.InvoiceDate,112) 
		WHEN @OrderBy='InvoiceNumber' THEN A.InvoiceNumber
		WHEN @OrderBy='Type' THEN A.InvoiceTypeDesc
		WHEN @OrderBy='Client' THEN A.ClientName
		WHEN @OrderBy='Status' THEN A.ReleasedStatusText
		WHEN @OrderBy='OriginalAmount' THEN right('0000000000'+ltrim(Convert(varchar(10),A.OriginalAmount)),10)
		WHEN @OrderBy='AmountDue' THEN right('0000000000'+ltrim(Convert(varchar(10),A.Amount)),10)
		ELSE CONVERT(char(8),A.InvoiceDate,112)  
	END
	)
	DESC,A.InvoiceID),
	COUNT(*) OVER () as Number
FROM
(

SELECT I.InvoiceID, I.InvoiceNumber, I.InvoiceDate, I.InvoiceTypeID, 
(CASE WHEN I.VoidedOn IS NULL THEN IT.InvoiceTypeDesc ELSE 'Void' END) as InvoiceTypeDesc,
(CASE WHEN I.VoidedOn IS NULL THEN I.Amount - ISNULL(P.PaymentAmount,0) - ISNULL(CreditAmount,0) ELSE 0 END) as Amount, 
I.Amount as OriginalAmount, BC.BillingContactID, 
BC.ClientContactID, BC.ContactName, C.ClientName, 
(CASE WHEN RS.ReleasedStatusID = 0 THEN RS.ReleasedStatusText
+ (CASE WHEN BC.DeliveryMethod=0 THEN '-Online'
WHEN BC.DeliveryMethod=1 THEN '-Email-Auto'
WHEN BC.DeliveryMethod=2 THEN '-Email-Manual'
WHEN BC.DeliveryMethod=3 THEN '-Mail'
ELSE '' END)
ELSE RS.ReleasedStatusText END) as ReleasedStatusText
FROM Invoices I
INNER JOIN InvoiceTypes IT
	ON IT.InvoiceTypeID=I.InvoiceTypeID
INNER JOIN Clients C
	ON I.ClientID=C.ClientID
INNER JOIN InvoiceBillingContacts IBC
	ON IBC.InvoiceID=I.InvoiceID
	AND IBC.IsPrimaryBillingContact=1
INNER JOIN BillingContacts BC
	ON BC.BillingContactID=IBC.BillingContactID
INNER JOIN ReleasedStatus RS
	ON I.Released=RS.ReleasedStatusID
LEFT JOIN (SELECT P1.InvoiceID, SUM(ISNULL(P1.Amount,0)) as PaymentAmount FROM InvoicePayments P1 GROUP BY P1.InvoiceID) P
	 ON I.InvoiceID=P.InvoiceID
LEFT JOIN (SELECT I1.RelatedInvoiceID, SUM(ISNULL(I1.Amount,0)) as CreditAmount FROM Invoices I1 WHERE I1.InvoiceTypeID=3 and I1.VoidedOn is null GROUP BY I1.RelatedInvoiceID) CR
	 ON I.InvoiceID=CR.RelatedInvoiceID
WHERE I.InvoiceDate BETWEEN @StartDate AND @EndDate
--AND I.VoidedOn IS NULL
AND C.BillingGroup in (2,5)
--If @BillingContactAnyClient = 1 Then don't filter by client
AND (C.ClientID=@ClientIDFilter OR @ClientIDFilter IS NULL OR @BillingContactAnyClient=1) 
AND (BC.BillingContactID=@BillingContactIDFilter OR @BillingContactIDFilter IS NULL)
AND (I.Released=@ReleaseStatusFilter OR @ReleaseStatusFilter IS NULL)
AND (BC.DeliveryMethod=@DeliveryMethodFilter OR @DeliveryMethodFilter IS NULL)
AND (I.InvoiceNumber = @InvoiceNumberFilter OR @InvoiceNumberFilter IS NULL)
) A
)
SELECT *
	FROM CTE
	WHERE rownum BETWEEN @FirstRow AND @LastRow
	ORDER BY rownum

END
GO
