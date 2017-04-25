/****** Object:  Table [dbo].[_InvoiceReport]    Script Date: 11/21/2016 9:44:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[_InvoiceReport](
	[Type] [varchar](50) NULL,
	[Date] [varchar](50) NULL,
	[Num] [varchar](50) NULL,
	[Name] [varchar](100) NULL,
	[Debit] [money] NULL,
	[Balance] [varchar](50) NULL,
	[RealDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
