/* This query finds which reporters have the most duplicates in the table */
SELECT Reporter, count(*) as total FROM [NewsFeed_NewsArticles] WHERE Article IN (SELECT Article
FROM [NewsFeed_NewsArticles]
GROUP BY Article
HAVING COUNT(Article) > 1) group by reporter order by total desc