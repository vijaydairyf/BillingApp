/****** Object:  Table [dbo].[FinanceChargeEmailLastRun]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FinanceChargeEmailLastRun](
	[MessageGUID] [uniqueidentifier] NULL,
	[MessageType] [int] NULL,
	[MessageText] [varchar](max) NULL,
	[MessageTo] [int] NULL,
	[ToContactType] [int] NULL,
	[MessageFrom] [int] NULL,
	[FromContactType] [int] NULL,
	[SentDate] [datetime] NULL,
	[ReceivedDate] [datetime] NULL,
	[MessageSubject] [varchar](255) NULL,
	[Status] [tinyint] NULL,
	[BodyFormat] [varchar](50) NULL,
	[BadEmailAddress] [bit] NULL,
	[ClientID] [int] NULL,
	[ClientName] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
