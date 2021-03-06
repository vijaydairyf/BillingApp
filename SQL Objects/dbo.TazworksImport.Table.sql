/****** Object:  Table [dbo].[TazworksImport]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TazworksImport](
	[ImportID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ImportBatchID] [int] NOT NULL,
	[VendorID] [int] NOT NULL,
	[FileNum] [int] NOT NULL,
	[ClientNumber] [varchar](50) NOT NULL,
	[ClientName] [varchar](max) NULL,
	[SalesRep] [varchar](max) NULL,
	[LName] [varchar](max) NULL,
	[FName] [varchar](max) NULL,
	[MName] [varchar](max) NULL,
	[SSN] [varchar](max) NULL,
	[ClientNumberOrdered] [varchar](max) NULL,
	[ClientNameOrdered] [varchar](max) NULL,
	[OrderBy] [varchar](max) NULL,
	[Reference] [varchar](max) NULL,
	[DateOrdered] [date] NULL,
	[ProductName] [varchar](max) NULL,
	[ProductType] [varchar](max) NULL,
	[ItemCode] [varchar](max) NULL,
	[ProductDesc] [varchar](max) NULL,
	[Price] [money] NULL,
	[Tax] [varchar](max) NULL,
	[InvoiceNumber] [varchar](max) NULL,
	[ClientID] [int] NULL,
	[Jurisdiction] [varchar](45) NULL,
	[ItemDescription] [varchar](max) NULL,
	[CoLName] [varchar](max) NULL,
	[CoFName] [varchar](max) NULL,
	[CoSSN] [varchar](max) NULL,
 CONSTRAINT [PK_TazworksImport] PRIMARY KEY CLUSTERED 
(
	[ImportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
