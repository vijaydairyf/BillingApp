/****** Object:  Table [dbo].[CommissionImport]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CommissionImport](
	[ClientID] [varchar](50) NULL,
	[ClientName] [varchar](500) NULL,
	[SalesRep] [varchar](500) NULL,
	[ProductDescription] [varchar](500) NULL,
	[ProductName] [varchar](500) NULL,
	[ProductType] [varchar](500) NULL,
	[CommissionRate] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
