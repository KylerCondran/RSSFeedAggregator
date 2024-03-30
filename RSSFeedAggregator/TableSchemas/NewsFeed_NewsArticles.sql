USE [Database]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [NewsFeed_NewsArticles](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Reporter] [nvarchar](100) NOT NULL,
	[Article] [nvarchar](250) NOT NULL,
	[URL] [nvarchar](450) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Summary] [nvarchar](2000) NULL,
	[StarBotScore] [int] NULL,
	[Image] [nvarchar](450) NULL,
 CONSTRAINT [PK_NewsFeed_NewsArticles] PRIMARY KEY CLUSTERED 
(
	[URL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


