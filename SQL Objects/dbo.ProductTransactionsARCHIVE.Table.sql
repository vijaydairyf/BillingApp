/****** Object:  Table [dbo].[ProductTransactionsARCHIVE]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductTransactionsARCHIVE](
	[ProductTransactionID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[VendorID] [int] NOT NULL,
	[TransactionDate] [smalldatetime] NULL,
	[DateOrdered] [smalldatetime] NULL,
	[OrderBy] [varchar](100) NULL,
	[Reference] [varchar](100) NULL,
	[FileNum] [varchar](50) NULL,
	[FName] [varchar](50) NULL,
	[LName] [varchar](50) NULL,
	[MName] [varchar](50) NULL,
	[SSN] [varchar](50) NULL,
	[ProductName] [varchar](100) NULL,
	[ProductDescription] [varchar](max) NULL,
	[ProductType] [varchar](50) NULL,
	[ProductPrice] [money] NOT NULL,
	[ExternalInvoiceNumber] [varchar](50) NULL,
	[SalesRep] [varchar](50) NULL,
	[CoLName] [varchar](50) NULL,
	[CoFName] [varchar](50) NULL,
	[CoMName] [varchar](50) NULL,
	[CoSSN] [varchar](50) NULL,
	[ImportBatchID] [int] NULL,
	[Invoiced] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
