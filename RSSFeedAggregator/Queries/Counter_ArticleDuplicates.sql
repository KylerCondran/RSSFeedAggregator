/* This query finds which articles are most duplicated in the table */
SELECT [Article], Count(*) as [counter]
  FROM [NewsFeed_NewsArticles]
  group by [Article]
  order by [counter] desc
