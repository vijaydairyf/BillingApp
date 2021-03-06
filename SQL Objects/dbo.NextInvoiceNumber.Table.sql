/****** Object:  Table [dbo].[NextInvoiceNumber]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NextInvoiceNumber](
	[NextInvoiceNumberID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[InvoiceNumberPrefix] [varchar](20) NOT NULL,
	[NextInvoiceNumber] [int] NOT NULL,
 CONSTRAINT [PK_NextInvoiceNumber] PRIMARY KEY CLUSTERED 
(
	[NextInvoiceNumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
