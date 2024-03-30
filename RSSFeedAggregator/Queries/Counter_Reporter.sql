SELECT Count(*) AS [ArticleCount] FROM [NewsFeed_NewsArticles]
SELECT [Reporter], Count(*) as [counter]
  FROM [NewsFeed_NewsArticles]
  group by [Reporter]
  order by [counter] desc
