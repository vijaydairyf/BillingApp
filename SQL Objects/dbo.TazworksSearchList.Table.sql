/****** Object:  Table [dbo].[TazworksSearchList]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TazworksSearchList](
	[TazworksSearchListID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SearchText] [varchar](max) NOT NULL,
	[ProductCode] [varchar](255) NOT NULL,
	[MatchPriority] [int] NOT NULL CONSTRAINT [DF_TazworksSearchList_MatchPriority]  DEFAULT ((0)),
 CONSTRAINT [PK_TazworksSearchList] PRIMARY KEY CLUSTERED 
(
	[TazworksSearchListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
