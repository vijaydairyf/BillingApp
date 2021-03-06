/****** Object:  Table [dbo].[ForgotPassword]    Script Date: 11/21/2016 9:44:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ForgotPassword](
	[ForgotPasswordGuid] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[PasswordAnswer] [nvarchar](256) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UserIP] [varchar](15) NOT NULL,
 CONSTRAINT [PK_ForgotPassword] PRIMARY KEY CLUSTERED 
(
	[ForgotPasswordGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 10) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
