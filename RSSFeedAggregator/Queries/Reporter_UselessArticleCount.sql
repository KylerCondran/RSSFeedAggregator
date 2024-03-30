SELECT [Reporter], Count(*) as [counter]
  FROM [NewsFeed_NewsArticles]
  WHERE StarBotScore = 0
  group by [Reporter]
  order by [counter] desc
