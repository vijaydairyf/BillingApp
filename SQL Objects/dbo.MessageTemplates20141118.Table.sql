/****** Object:  Table [dbo].[MessageTemplates20141118]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MessageTemplates20141118](
	[MessageTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[MessageText] [varchar](max) NOT NULL,
	[MessageName] [varchar](50) NOT NULL,
	[IsPlainText] [tinyint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
