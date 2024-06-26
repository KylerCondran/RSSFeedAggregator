/* This query finds the most recently downloaded articles */
SELECT TOP (1000) [ID]
      ,[Reporter]
      ,[Article]
      ,[URL]
	  ,[Image]
      ,[DateTime]
      ,[Summary]
	  ,[StarBotScore]	  
  FROM [NewsFeed_NewsArticles] ORDER BY ID DESC
