/****** Object:  Table [dbo].[ClientSplitClient]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientSplitClient](
	[ClientSplitClientID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientSplitID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
 CONSTRAINT [PK_ClientSplitClient] PRIMARY KEY CLUSTERED 
(
	[ClientSplitClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
