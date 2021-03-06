/****** Object:  Table [dbo].[ProductTransactions]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductTransactions](
	[ProductTransactionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ProductID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[VendorID] [int] NOT NULL,
	[TransactionDate] [smalldatetime] NULL,
	[DateOrdered] [smalldatetime] NULL,
	[OrderBy] [varchar](100) NULL,
	[Reference] [varchar](100) NULL,
	[FileNum] [varchar](50) NULL,
	[FName] [varchar](255) NULL,
	[LName] [varchar](255) NULL,
	[MName] [varchar](255) NULL,
	[SSN] [varchar](50) NULL,
	[ProductName] [varchar](100) NULL,
	[ProductDescription] [varchar](max) NULL,
	[ProductType] [varchar](50) NULL,
	[ProductPrice] [money] NOT NULL,
	[ExternalInvoiceNumber] [varchar](50) NULL,
	[SalesRep] [varchar](50) NULL,
	[CoLName] [varchar](255) NULL,
	[CoFName] [varchar](255) NULL,
	[CoMName] [varchar](255) NULL,
	[CoSSN] [varchar](50) NULL,
	[ImportBatchID] [int] NULL,
	[Invoiced] [bit] NOT NULL CONSTRAINT [DF_ProductTransactions_Invoiced]  DEFAULT ((0)),
 CONSTRAINT [PK_ProductTransactions] PRIMARY KEY CLUSTERED 
(
	[ProductTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [IDX_ProductTransactions_ClientVendorProductTranDate]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE NONCLUSTERED INDEX [IDX_ProductTransactions_ClientVendorProductTranDate] ON [dbo].[ProductTransactions]
(
	[ClientID] ASC,
	[VendorID] ASC,
	[ProductID] ASC,
	[TransactionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductTransactions]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductTransactions] ON [dbo].[ProductTransactions]
(
	[ImportBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductTransactions_ClientID]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductTransactions_ClientID] ON [dbo].[ProductTransactions]
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProductTransactions_FileNum]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductTransactions_FileNum] ON [dbo].[ProductTransactions]
(
	[FileNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductTransactions_TransactionDate]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductTransactions_TransactionDate] ON [dbo].[ProductTransactions]
(
	[TransactionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
