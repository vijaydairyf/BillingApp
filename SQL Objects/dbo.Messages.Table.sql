/****** Object:  Table [dbo].[Messages]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Messages](
	[MessageID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MessageGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Messages_MessageGUID]  DEFAULT (newid()),
	[MessageType] [int] NOT NULL,
	[MessageText] [varchar](max) NOT NULL,
	[MessageTo] [int] NOT NULL,
	[ToContactType] [int] NOT NULL,
	[MessageFrom] [int] NOT NULL,
	[FromContactType] [int] NOT NULL,
	[SentDate] [datetime] NULL,
	[ReceivedDate] [datetime] NULL,
	[MessageSubject] [varchar](255) NULL,
	[Status] [tinyint] NULL,
	[BodyFormat] [varchar](50) NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
