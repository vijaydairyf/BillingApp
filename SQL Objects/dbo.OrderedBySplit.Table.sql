/****** Object:  Table [dbo].[OrderedBySplit]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrderedBySplit](
	[OrderedBySplitID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[InvoiceSplitID] [int] NOT NULL,
	[OrderedBy] [varchar](100) NULL,
 CONSTRAINT [PK_OrderedBySplit] PRIMARY KEY CLUSTERED 
(
	[OrderedBySplitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[OrderedBySplit]  WITH CHECK ADD  CONSTRAINT [FK_OrderedBySplit_InvoiceSplit] FOREIGN KEY([InvoiceSplitID])
REFERENCES [dbo].[InvoiceSplit] ([InvoiceSplitID])
GO
ALTER TABLE [dbo].[OrderedBySplit] CHECK CONSTRAINT [FK_OrderedBySplit_InvoiceSplit]
GO
