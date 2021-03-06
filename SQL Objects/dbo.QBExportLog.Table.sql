/****** Object:  Table [dbo].[QBExportLog]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QBExportLog](
	[QBExportLogID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ExportStep] [int] NOT NULL,
	[ExportTime] [datetime] NOT NULL,
 CONSTRAINT [PK_QBExportLog] PRIMARY KEY CLUSTERED 
(
	[QBExportLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
