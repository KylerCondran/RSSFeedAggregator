/* This query finds how many non scored articles exist per reporter - used to fine tune the article scoring in the TopArticles_StarbotKeywords table */
SELECT [Reporter], Count(*) as [counter]
  FROM [NewsFeed_NewsArticles]
  WHERE StarBotScore = 0
  group by [Reporter]
  order by [counter] desc
