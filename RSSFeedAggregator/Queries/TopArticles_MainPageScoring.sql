/* This query finds articles that should appear on the main page due to having a score over a certain threshold */
  SELECT TOP (50) [ID],[Reporter],[Article],[URL],[StarBotScore]
  FROM [NewsFeed_NewsArticles] WHERE StarBotScore > 28 ORDER BY StarBotScore DESC
