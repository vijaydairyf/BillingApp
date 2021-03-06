/****** Object:  Table [dbo].[InvoiceLines]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InvoiceLines](
	[InvoiceLineID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[InvoiceLineNumber] [int] NOT NULL,
	[Col1Text] [varchar](max) NULL,
	[Col2Text] [varchar](max) NULL,
	[Col3Text] [varchar](max) NULL,
	[Col4Text] [varchar](max) NULL,
	[Col5Text] [varchar](max) NULL,
	[Col6Text] [varchar](max) NULL,
	[Col7Text] [varchar](max) NULL,
	[Col8Text] [varchar](max) NULL,
	[Amount] [money] NULL,
 CONSTRAINT [PK_InvoiceLines] PRIMARY KEY CLUSTERED 
(
	[InvoiceLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [IX_InvoiceLines_InvoiceID]    Script Date: 11/21/2016 9:44:42 AM ******/
CREATE NONCLUSTERED INDEX [IX_InvoiceLines_InvoiceID] ON [dbo].[InvoiceLines]
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
GO
