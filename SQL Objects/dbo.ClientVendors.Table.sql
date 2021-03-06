/****** Object:  Table [dbo].[ClientVendors]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ClientVendors](
	[ClientVendorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientID] [int] NOT NULL,
	[VendorID] [int] NOT NULL,
	[VendorClientNumber] [varchar](50) NULL,
 CONSTRAINT [PK_ClientVendors] PRIMARY KEY CLUSTERED 
(
	[ClientVendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ClientVendors]  WITH CHECK ADD  CONSTRAINT [FK_ClientVendors_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientVendors] CHECK CONSTRAINT [FK_ClientVendors_Clients]
GO
ALTER TABLE [dbo].[ClientVendors]  WITH CHECK ADD  CONSTRAINT [FK_ClientVendors_Vendors] FOREIGN KEY([VendorID])
REFERENCES [dbo].[Vendors] ([VendorID])
GO
ALTER TABLE [dbo].[ClientVendors] CHECK CONSTRAINT [FK_ClientVendors_Vendors]
GO
