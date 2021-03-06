/****** Object:  Table [dbo].[ClientInvoiceSettings]    Script Date: 11/21/2016 9:44:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientInvoiceSettings](
	[ClientInvoiceSettingsID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientID] [int] NOT NULL,
	[InvoiceTemplateID] [int] NOT NULL,
	[SplitByMode] [int] NULL,
	[ReportGroupID] [tinyint] NULL,
	[HideSSN] [bit] NOT NULL,
	[ApplyFinanceCharge] [bit] NULL,
	[FinanceChargeDays] [int] NULL,
	[FinanceChargePercent] [decimal](4, 3) NULL,
	[SentToCollections] [bit] NULL,
	[ExcludeFromReminders] [bit] NULL,
 CONSTRAINT [PK_ClientInvoiceSettings] PRIMARY KEY CLUSTERED 
(
	[ClientInvoiceSettingsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ClientInvoiceSettings]  WITH CHECK ADD  CONSTRAINT [FK_ClientInvoiceSettings_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientInvoiceSettings] CHECK CONSTRAINT [FK_ClientInvoiceSettings_Clients]
GO
