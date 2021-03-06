/****** Object:  Table [dbo].[eDrugImport]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[eDrugImport](
	[ImportID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ImportBatchID] [int] NOT NULL,
	[CustomerNumber] [varchar](max) NOT NULL,
	[CustomerName] [varchar](max) NULL,
	[InvoiceNumber] [varchar](max) NULL,
	[LocationCode] [varchar](max) NOT NULL,
	[ServiceDate] [datetime] NULL,
	[Product] [varchar](max) NULL,
	[Fee] [money] NOT NULL,
	[SSN] [varchar](11) NULL,
	[EmployeeName] [varchar](max) NULL,
	[COCNumber] [varchar](max) NULL,
	[SpecimenID] [varchar](max) NOT NULL,
	[Reason] [varchar](max) NOT NULL,
	[Comments] [varchar](max) NULL,
 CONSTRAINT [PK_eDrugImport] PRIMARY KEY CLUSTERED 
(
	[ImportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
