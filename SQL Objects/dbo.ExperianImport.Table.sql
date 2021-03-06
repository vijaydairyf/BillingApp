/****** Object:  Table [dbo].[ExperianImport]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExperianImport](
	[ImportID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ImportBatchID] [int] NOT NULL,
	[XPRequesterNo] [varchar](5) NOT NULL,
	[XPRecordType] [char](1) NOT NULL,
	[XPMktPreamble] [varchar](4) NULL,
	[XPAccPreamble] [varchar](4) NULL,
	[XPSubcode] [varchar](7) NOT NULL,
	[XPInquiryDate] [datetime] NULL,
	[XPInquiryTime] [varchar](6) NULL,
	[XPLastName] [varchar](255) NULL,
	[XPSecondLastName] [varchar](255) NULL,
	[XPFirstName] [varchar](255) NULL,
	[XPMiddleName] [varchar](255) NULL,
	[XPGenerationCode] [char](1) NULL,
	[XPStreetNumber] [varchar](10) NULL,
	[XPStreetName] [varchar](32) NULL,
	[XPStreetSuffix] [varchar](4) NULL,
	[XPCity] [varchar](32) NULL,
	[XPUnitID] [varchar](32) NULL,
	[XPState] [varchar](2) NULL,
	[XPZipCode] [varchar](9) NULL,
	[XPHitCode] [varchar](2) NULL,
	[XPSSN] [varchar](9) NULL,
	[XPOperatorID] [varchar](2) NULL,
	[XPDuplicateID] [char](1) NULL,
	[XPStatementID] [varchar](2) NULL,
	[XPInvoiceCodes] [varchar](3) NULL,
	[XPProductCode] [varchar](7) NOT NULL,
	[XPProductPrice] [money] NOT NULL,
	[XPMKeyWord] [varchar](20) NULL,
 CONSTRAINT [PK_ExperianImport] PRIMARY KEY CLUSTERED 
(
	[ImportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
