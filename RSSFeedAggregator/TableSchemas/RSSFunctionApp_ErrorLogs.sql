USE [Database]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [RSSFunctionApp_ErrorLogs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](2000) NOT NULL,
	[Message] [nvarchar](2000) NOT NULL,
	[Source] [nvarchar](max) NOT NULL,
	[FeedName] [nvarchar](100) NOT NULL,
	[ArticleTitle] [nvarchar](250) NULL,
	[Subroutine] [nvarchar](100) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Handled] [int] NOT NULL,
 CONSTRAINT [PK_RSSFunctionApp_ErrorLogs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


