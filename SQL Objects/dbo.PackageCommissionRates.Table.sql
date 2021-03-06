/****** Object:  Table [dbo].[PackageCommissionRates]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PackageCommissionRates](
	[ClientID] [varchar](50) NULL,
	[ClientName] [varchar](255) NULL,
	[SalesRep] [varchar](5) NULL,
	[ProductDescription] [varchar](5000) NULL,
	[ProductName] [varchar](255) NULL,
	[ProductType] [varchar](255) NULL,
	[CommissionRate] [decimal](28, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
