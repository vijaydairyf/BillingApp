/****** Object:  Table [dbo].[InvoiceSplitBillingContacts]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceSplitBillingContacts](
	[InvoiceSplitBillingContactID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[InvoiceSplitID] [int] NOT NULL,
	[BillingContactID] [int] NOT NULL,
	[IsPrimaryBillingContact] [bit] NOT NULL,
 CONSTRAINT [PK_InvoiceSplitBillingContacts] PRIMARY KEY CLUSTERED 
(
	[InvoiceSplitBillingContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[InvoiceSplitBillingContacts]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceSplitBillingContacts_BillingContacts] FOREIGN KEY([BillingContactID])
REFERENCES [dbo].[BillingContacts] ([BillingContactID])
GO
ALTER TABLE [dbo].[InvoiceSplitBillingContacts] CHECK CONSTRAINT [FK_InvoiceSplitBillingContacts_BillingContacts]
GO
ALTER TABLE [dbo].[InvoiceSplitBillingContacts]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceSplitBillingContacts_InvoiceSplit] FOREIGN KEY([InvoiceSplitID])
REFERENCES [dbo].[InvoiceSplit] ([InvoiceSplitID])
GO
ALTER TABLE [dbo].[InvoiceSplitBillingContacts] CHECK CONSTRAINT [FK_InvoiceSplitBillingContacts_InvoiceSplit]
GO
