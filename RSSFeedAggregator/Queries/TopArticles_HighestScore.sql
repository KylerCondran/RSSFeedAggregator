SELECT TOP (5) [Reporter],[Article],[URL],[StarBotScore]
  FROM [NewsFeed_NewsArticles] WHERE DateTime BETWEEN dateadd(hour,-5,GETDATE()) AND dateadd(hour,7,GETDATE()) ORDER BY StarBotScore DESC
  SELECT TOP (5) [Reporter],[Article],[URL],[StarBotScore]
  FROM [NewsFeed_NewsArticles] WHERE DateTime BETWEEN dateadd(hour,-17,GETDATE()) AND dateadd(hour,-5,GETDATE()) ORDER BY StarBotScore DESC
  SELECT TOP (5) [Reporter],[Article],[URL],[StarBotScore]
  FROM [NewsFeed_NewsArticles] WHERE DateTime BETWEEN dateadd(hour,-65,GETDATE()) AND dateadd(hour,-17,GETDATE()) ORDER BY StarBotScore DESC
  SELECT TOP (5) [Reporter],[Article],[URL],[StarBotScore]
  FROM [NewsFeed_NewsArticles] WHERE DateTime BETWEEN dateadd(hour,-161,GETDATE()) AND dateadd(hour,-65,GETDATE()) ORDER BY StarBotScore DESC
  SELECT TOP (5) [Reporter],[Article],[URL],[StarBotScore]
  FROM [NewsFeed_NewsArticles] WHERE DateTime BETWEEN dateadd(hour,-329,GETDATE()) AND dateadd(hour,-161,GETDATE()) ORDER BY StarBotScore DESC
  SELECT TOP (50) [Reporter],[Article],[URL],[DateTime],[StarBotScore]
  FROM [NewsFeed_NewsArticles] WHERE DateTime BETWEEN dateadd(hour,-24,GETDATE()) AND GETDATE() ORDER BY StarBotScore DESC

SELECT TOP (50) [Article],[URL],[Reporter],[DateTime],CASE
	WHEN (datediff(hh,DateTime,GETDATE()) >= 102) THEN [StarBotScore] - 50
	WHEN (datediff(hh,DateTime,GETDATE()) >= 96) THEN [StarBotScore] - 40
	WHEN (datediff(hh,DateTime,GETDATE()) >= 90) THEN [StarBotScore] - 35
	WHEN (datediff(hh,DateTime,GETDATE()) >= 84) THEN [StarBotScore] - 30
	WHEN (datediff(hh,DateTime,GETDATE()) >= 78) THEN [StarBotScore] - 25
	WHEN (datediff(hh,DateTime,GETDATE()) >= 72) THEN [StarBotScore] - 20
	WHEN (datediff(hh,DateTime,GETDATE()) >= 66) THEN [StarBotScore] - 18
	WHEN (datediff(hh,DateTime,GETDATE()) >= 60) THEN [StarBotScore] - 16
	WHEN (datediff(hh,DateTime,GETDATE()) >= 54) THEN [StarBotScore] - 14
	WHEN (datediff(hh,DateTime,GETDATE()) >= 48) THEN [StarBotScore] - 12
	WHEN (datediff(hh,DateTime,GETDATE()) >= 42) THEN [StarBotScore] - 10
	WHEN (datediff(hh,DateTime,GETDATE()) >= 36) THEN [StarBotScore] - 8
	WHEN (datediff(hh,DateTime,GETDATE()) >= 30) THEN [StarBotScore] - 6
	WHEN (datediff(hh,DateTime,GETDATE()) >= 24) THEN [StarBotScore] - 4
	WHEN (datediff(hh,DateTime,GETDATE()) >= 18) THEN [StarBotScore] - 3
	WHEN (datediff(hh,DateTime,GETDATE()) >= 12) THEN [StarBotScore] - 2
	WHEN (datediff(hh,DateTime,GETDATE()) >= 6) THEN [StarBotScore] - 1
    ELSE [StarBotScore]
END AS [StarBotScore]
  FROM [NewsFeed_NewsArticles] ORDER BY StarBotScore DESC, DateTime DESC
