  SELECT TOP (50) [ID],[Reporter],[Article],[URL],[StarBotScore]
  FROM [NewsFeed_NewsArticles] WHERE StarBotScore > 28 ORDER BY StarBotScore DESC
