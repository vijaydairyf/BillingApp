/****** Object:  Table [dbo].[InternalTazworksUsers]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InternalTazworksUsers](
	[InternalTazworksUsersID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LastName] [varchar](255) NULL,
	[FirstName] [varchar](255) NULL,
	[ShortName] [varchar](max) NULL,
	[Email] [varchar](max) NULL,
 CONSTRAINT [PK_InternalTazworksUsers] PRIMARY KEY CLUSTERED 
(
	[InternalTazworksUsersID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
