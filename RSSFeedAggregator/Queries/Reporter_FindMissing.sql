SELECT reporter
FROM (SELECT FeedName FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1) R(reporter)
EXCEPT
SELECT DISTINCT [Reporter]
  FROM [NewsFeed_NewsArticles] ORDER BY [Reporter] ASC
