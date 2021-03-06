/****** Object:  Table [dbo].[ReferenceSplit]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReferenceSplit](
	[ReferenceSplitID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[InvoiceSplitID] [int] NOT NULL,
	[ReferenceText] [varchar](100) NULL,
 CONSTRAINT [PK_ReferenceSplit] PRIMARY KEY CLUSTERED 
(
	[ReferenceSplitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ReferenceSplit]  WITH CHECK ADD  CONSTRAINT [FK_ReferenceSplit_InvoiceSplit] FOREIGN KEY([InvoiceSplitID])
REFERENCES [dbo].[InvoiceSplit] ([InvoiceSplitID])
GO
ALTER TABLE [dbo].[ReferenceSplit] CHECK CONSTRAINT [FK_ReferenceSplit_InvoiceSplit]
GO
