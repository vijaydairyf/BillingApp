/****** Object:  Table [dbo].[SalesRep]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SalesRep](
	[SalesRepID] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepCode] [varchar](50) NOT NULL,
	[SalesRepName] [varchar](500) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
