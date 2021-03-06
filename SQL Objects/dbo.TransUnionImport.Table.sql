/****** Object:  Table [dbo].[TransUnionImport]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TransUnionImport](
	[ImportID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ImportBatchID] [int] NOT NULL,
	[TUSubscriberID] [varchar](50) NOT NULL,
	[InquiryDate] [datetime] NULL,
	[InquiryTime] [varchar](50) NULL,
	[ECOA] [varchar](2) NULL,
	[Surname] [varchar](255) NULL,
	[FirstName] [varchar](255) NULL,
	[Address] [varchar](max) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](50) NULL,
	[Zip] [varchar](10) NULL,
	[SSN] [varchar](20) NULL,
	[SpouseFirstName] [varchar](255) NULL,
	[NetPrice] [money] NULL,
	[MMSSTo] [varchar](max) NULL,
	[TimeZone] [varchar](100) NULL,
	[ProductCode] [varchar](7) NULL,
	[ProductType] [varchar](1) NULL,
	[Hit] [varchar](1) NULL,
	[UserReference] [varchar](max) NULL,
 CONSTRAINT [PK_TransUnionImport] PRIMARY KEY CLUSTERED 
(
	[ImportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
