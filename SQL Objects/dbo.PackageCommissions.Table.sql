/****** Object:  Table [dbo].[PackageCommissions]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PackageCommissions](
	[PackageCommissionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientID] [varchar](50) NOT NULL,
	[ClientName] [varchar](500) NULL,
	[PackageName] [varchar](500) NULL,
	[PackageProducts] [varchar](800) NULL,
	[PackageCommissionRate] [decimal](4, 2) NOT NULL,
	[BillingClientID] [int] NULL,
 CONSTRAINT [PK_PackageCommissions] PRIMARY KEY CLUSTERED 
(
	[PackageCommissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
