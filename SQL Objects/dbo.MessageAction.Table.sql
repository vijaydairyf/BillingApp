/****** Object:  Table [dbo].[MessageAction]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MessageAction](
	[MessageActionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MessageID] [int] NOT NULL,
	[MessageActionGUID] [uniqueidentifier] NOT NULL,
	[MessageActionType] [int] NOT NULL CONSTRAINT [DF_MessageAction_MessageActionType]  DEFAULT ((1)),
	[MessageActionPath] [varchar](100) NOT NULL CONSTRAINT [DF_MessageAction_MessageActionPath]  DEFAULT (''),
	[IsActive] [tinyint] NOT NULL CONSTRAINT [DF_MessageAction_IsActive]  DEFAULT ((0)),
 CONSTRAINT [PK_MessageAction] PRIMARY KEY CLUSTERED 
(
	[MessageActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[MessageAction]  WITH CHECK ADD  CONSTRAINT [FK_MessageAction_MessageActionTypes] FOREIGN KEY([MessageActionType])
REFERENCES [dbo].[MessageActionTypes] ([MessageActionTypeID])
GO
ALTER TABLE [dbo].[MessageAction] CHECK CONSTRAINT [FK_MessageAction_MessageActionTypes]
GO
ALTER TABLE [dbo].[MessageAction]  WITH CHECK ADD  CONSTRAINT [FK_MessageAction_Messages] FOREIGN KEY([MessageID])
REFERENCES [dbo].[Messages] ([MessageID])
GO
ALTER TABLE [dbo].[MessageAction] CHECK CONSTRAINT [FK_MessageAction_Messages]
GO
