SELECT [Article], Count(*) as [counter]
  FROM [NewsFeed_NewsArticles]
  group by [Article]
  order by [counter] desc
