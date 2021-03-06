/****** Object:  Table [dbo].[MessageTemplates]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MessageTemplates](
	[MessageTemplateID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientID] [int] NOT NULL,
	[MessageText] [varchar](max) NOT NULL,
	[MessageName] [varchar](50) NOT NULL,
	[IsPlainText] [tinyint] NOT NULL,
 CONSTRAINT [PK_MessageTemplates] PRIMARY KEY CLUSTERED 
(
	[MessageTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
