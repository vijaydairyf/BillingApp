/****** Object:  Table [dbo].[Invoices]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Invoices](
	[InvoiceID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientID] [int] NOT NULL,
	[InvoiceTypeID] [int] NOT NULL,
	[InvoiceNumber] [varchar](50) NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[VoidedOn] [datetime] NULL,
	[VoidedByUser] [int] NULL,
	[Amount] [money] NOT NULL,
	[NumberOfColumns] [tinyint] NOT NULL,
	[Col1Header] [varchar](100) NULL,
	[Col2Header] [varchar](100) NULL,
	[Col3Header] [varchar](100) NULL,
	[Col4Header] [varchar](100) NULL,
	[Col5Header] [varchar](100) NULL,
	[Col6Header] [varchar](100) NULL,
	[Col7Header] [varchar](100) NULL,
	[Col8Header] [varchar](100) NULL,
	[CreateInvoicesBatchID] [int] NULL,
	[BillTo] [varchar](max) NULL,
	[POName] [varchar](50) NULL,
	[PONumber] [varchar](50) NULL,
	[BillingReportGroupID] [int] NOT NULL,
	[InvoiceExported] [bit] NOT NULL CONSTRAINT [DF_Invoices_InvoiceExported]  DEFAULT ((0)),
	[InvoiceExportedOn] [datetime] NULL,
	[DueText] [varchar](50) NULL,
	[RelatedInvoiceID] [int] NULL,
	[Released] [tinyint] NULL CONSTRAINT [DF_Invoices_Released]  DEFAULT ((0)),
	[DontShowOnStatement] [bit] NOT NULL DEFAULT ((0)),
	[QBTransactionID] [varchar](50) NULL,
 CONSTRAINT [PK_Invoices] PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [idx_InvoicesInvoiceType]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE NONCLUSTERED INDEX [idx_InvoicesInvoiceType] ON [dbo].[Invoices]
(
	[InvoiceTypeID] ASC,
	[VoidedOn] ASC,
	[Released] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
/****** Object:  Index [IX_Invoices_ClientID]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE NONCLUSTERED INDEX [IX_Invoices_ClientID] ON [dbo].[Invoices]
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
/****** Object:  Index [IX_Invoices_RelatedInvoiceID]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE NONCLUSTERED INDEX [IX_Invoices_RelatedInvoiceID] ON [dbo].[Invoices]
(
	[RelatedInvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_Invoices_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[Invoices] CHECK CONSTRAINT [FK_Invoices_Clients]
GO
