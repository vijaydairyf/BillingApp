/****** Object:  Table [dbo].[ImportBatch]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ImportBatch](
	[ImportBatchID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ImportBatchUser] [varchar](50) NOT NULL,
	[ImportBatchDateTime] [datetime] NOT NULL CONSTRAINT [DF_ImportBatch_ImportBatchDateTime]  DEFAULT (getdate()),
	[ImportBatchFileName] [varchar](255) NOT NULL,
	[ImportBatchVendorID] [int] NOT NULL,
	[ImportSuccess] [bit] NULL,
 CONSTRAINT [PK_ImportBatch] PRIMARY KEY CLUSTERED 
(
	[ImportBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
