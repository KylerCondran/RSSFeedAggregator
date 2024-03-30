USE [Database]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [RSSFunctionApp_RSSFeeds](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FeedName] [nvarchar](50) NOT NULL,
	[URL] [nvarchar](100) NOT NULL,
	[ReadTier] [int] NOT NULL,
	[Enabled] [int] NOT NULL,
	[Category] [nvarchar](5) NULL,
	[CompareAll] [bit] NULL,
	[RemovePaywall] [bit] NULL,
	[IngestionLogging] [bit] NULL,
 CONSTRAINT [PK_RSSFunctionApp_RSSFeeds] PRIMARY KEY CLUSTERED 
(
	[URL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


