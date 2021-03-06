/****** Object:  Table [dbo].[QBExportLinkCredits]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QBExportLinkCredits](
	[QBExportLinkCreditsID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CreditInvoiceID] [int] NOT NULL,
	[Linked] [bit] NOT NULL CONSTRAINT [DF_QBExportLinkCredits_Linked]  DEFAULT ((0)),
 CONSTRAINT [PK_QBExportLinkCredits] PRIMARY KEY CLUSTERED 
(
	[QBExportLinkCreditsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
