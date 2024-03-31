/* This query finds the total article count in the table and total article count broken down by reporter */
SELECT Count(*) AS [ArticleCount] FROM [NewsFeed_NewsArticles]
SELECT [Reporter], Count(*) as [counter]
  FROM [NewsFeed_NewsArticles]
  group by [Reporter]
  order by [counter] desc
