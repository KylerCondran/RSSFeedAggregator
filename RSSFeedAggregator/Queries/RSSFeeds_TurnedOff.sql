/* This query finds which RSS Feeds are currently disabled */
SELECT TOP (1000) [ID]
      ,[FeedName]
      ,[URL]
      ,[ReadTier]
      ,[Enabled]
	  ,[CompareAll]
	  ,[RemovePaywall]
	  ,[IngestionLogging]
	  ,[Category]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 0 ORDER BY FeedName ASC
