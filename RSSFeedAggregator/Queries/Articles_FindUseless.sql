/* This query finds which articles do not have any scoring - used to fine tune scoring by adding keywords to the TopArticles_StarbotKeywords table */
SELECT TOP (1000) [ID]
      ,[Reporter]
      ,[Article]
  FROM [NewsFeed_NewsArticles] WHERE StarBotScore = 0 AND datediff(hh,DateTime,GETDATE()) < 12 ORDER BY ID DESC