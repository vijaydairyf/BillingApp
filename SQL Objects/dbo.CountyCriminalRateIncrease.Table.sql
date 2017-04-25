/****** Object:  Table [dbo].[CountyCriminalRateIncrease]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CountyCriminalRateIncrease](
	[client_name] [varchar](500) NULL,
	[client_code] [varchar](50) NULL,
	[file_number] [varchar](50) NULL,
	[item_code] [varchar](50) NULL,
	[charge_description] [varchar](500) NULL,
	[charge_amount] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
