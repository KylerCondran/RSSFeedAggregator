USE [Database]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [RSSFunctionApp_IngestionLogs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FeedName] [nvarchar](100) NOT NULL,
	[UploadedCount] [int] NOT NULL,
	[DiscardedCount] [int] NOT NULL,
	[TotalCount] [int] NOT NULL,
	[UploadedPercentage] [float] NOT NULL,
	[DateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_RSSFunctionApp_IngestionLogs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


