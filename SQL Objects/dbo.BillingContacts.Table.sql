/****** Object:  Table [dbo].[BillingContacts]    Script Date: 11/21/2016 9:44:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BillingContacts](
	[BillingContactID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientID] [int] NOT NULL,
	[ClientContactID] [int] NULL,
	[DeliveryMethod] [int] NOT NULL,
	[ContactName] [varchar](255) NULL,
	[ContactAddress1] [varchar](100) NULL,
	[ContactAddress2] [varchar](100) NULL,
	[ContactCity] [varchar](50) NULL,
	[ContactStateCode] [char](2) NULL,
	[ContactZIP] [varchar](10) NULL,
	[ContactEmail] [varchar](255) NULL,
	[OrderBy] [varchar](100) NULL,
	[ContactPhone] [varchar](50) NULL,
	[ContactFax] [varchar](50) NULL,
	[IsPrimaryBillingContact] [bit] NULL,
	[POName] [varchar](50) NULL,
	[PONumber] [varchar](50) NULL,
	[Notes] [varchar](max) NULL,
	[OnlyShowInvoices] [bit] NULL,
	[BillingContactStatus] [bit] NULL,
	[HideFromClient] [bit] NULL,
 CONSTRAINT [PK_BillingContacts] PRIMARY KEY CLUSTERED 
(
	[BillingContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[BillingContacts]  WITH CHECK ADD  CONSTRAINT [FK_BillingContacts_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[BillingContacts] CHECK CONSTRAINT [FK_BillingContacts_Clients]
GO
