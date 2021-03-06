/****** Object:  Table [dbo].[SQLJobCreateInvoices]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLJobCreateInvoices](
	[StartTransactionDate] [datetime] NOT NULL,
	[EndTransactionDate] [datetime] NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[BillingGroup] [int] NOT NULL,
	[Started] [bit] NOT NULL,
	[Done] [bit] NOT NULL,
	[UserId] [int] NOT NULL,
	[DateEntered] [datetime] NOT NULL,
 CONSTRAINT [PK_SQLJobCreateInvoices] PRIMARY KEY NONCLUSTERED 
(
	[StartTransactionDate] ASC,
	[EndTransactionDate] ASC,
	[InvoiceDate] ASC,
	[BillingGroup] ASC,
	[DateEntered] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [IX1_SQLJobCreateInvoices]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE CLUSTERED INDEX [IX1_SQLJobCreateInvoices] ON [dbo].[SQLJobCreateInvoices]
(
	[StartTransactionDate] ASC,
	[EndTransactionDate] ASC,
	[InvoiceDate] ASC,
	[BillingGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
