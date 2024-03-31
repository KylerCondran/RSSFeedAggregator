USE [Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NewsFeed] 
	@Switch                      INT  = NULL,
	@UserIP                      NVARCHAR(25)  = NULL
AS 
BEGIN 
SET NOCOUNT ON 
/* Top Articles - 12H */
IF @Switch = 1 
BEGIN
SELECT TOP 5 * FROM (SELECT a.NewsArticleID AS [ID], COUNT(*) AS [StarCount], b.Reporter, b.Article, b.Summary, b.URL, b.DateTime FROM NewsFeed_StarredArticles a LEFT JOIN NewsFeed_NewsArticles b ON b.ID = a.NewsArticleID GROUP BY a.NewsArticleID, b.Reporter, b.Article, b.Summary, b.URL, b.DateTime) t WHERE DateTime BETWEEN dateadd(hour,-5,GETDATE()) AND dateadd(hour,7,GETDATE()) ORDER BY StarCount DESC, DateTime DESC
END
/* Top Articles - 24H */
ELSE IF @Switch = 2
BEGIN
SELECT TOP 5 * FROM (SELECT a.NewsArticleID AS [ID], COUNT(*) AS [StarCount], b.Reporter, b.Article, b.Summary, b.URL, b.DateTime FROM NewsFeed_StarredArticles a LEFT JOIN NewsFeed_NewsArticles b ON b.ID = a.NewsArticleID GROUP BY a.NewsArticleID, b.Reporter, b.Article, b.Summary, b.URL, b.DateTime) t WHERE DateTime BETWEEN dateadd(hour,-17,GETDATE()) AND dateadd(hour,-5,GETDATE()) ORDER BY StarCount DESC, DateTime DESC
END
/* Top Articles - 3D */
ELSE IF @Switch = 3
BEGIN
SELECT TOP 10 * FROM (SELECT a.NewsArticleID AS [ID], COUNT(*) AS [StarCount], b.Reporter, b.Article, b.Summary, b.URL, b.DateTime FROM NewsFeed_StarredArticles a LEFT JOIN NewsFeed_NewsArticles b ON b.ID = a.NewsArticleID GROUP BY a.NewsArticleID, b.Reporter, b.Article, b.Summary, b.URL, b.DateTime) t WHERE DateTime BETWEEN dateadd(hour,-65,GETDATE()) AND dateadd(hour,-17,GETDATE()) ORDER BY StarCount DESC, DateTime DESC
END
/* Top Articles - 7D */
ELSE IF @Switch = 4
BEGIN
SELECT TOP 10 * FROM (SELECT a.NewsArticleID AS [ID], COUNT(*) AS [StarCount], b.Reporter, b.Article, b.Summary, b.URL, b.DateTime FROM NewsFeed_StarredArticles a LEFT JOIN NewsFeed_NewsArticles b ON b.ID = a.NewsArticleID GROUP BY a.NewsArticleID, b.Reporter, b.Article, b.Summary, b.URL, b.DateTime) t WHERE DateTime BETWEEN dateadd(hour,-161,GETDATE()) AND dateadd(hour,-65,GETDATE()) ORDER BY StarCount DESC, DateTime DESC
END
/* Top Articles - 14D */
ELSE IF @Switch = 5
BEGIN
SELECT TOP 20 * FROM (SELECT a.NewsArticleID AS [ID], COUNT(*) AS [StarCount], b.Reporter, b.Article, b.Summary, b.URL, b.DateTime FROM NewsFeed_StarredArticles a LEFT JOIN NewsFeed_NewsArticles b ON b.ID = a.NewsArticleID GROUP BY a.NewsArticleID, b.Reporter, b.Article, b.Summary, b.URL, b.DateTime) t WHERE DateTime BETWEEN dateadd(hour,-329,GETDATE()) AND dateadd(hour,-161,GETDATE()) ORDER BY StarCount DESC, DateTime DESC
END
/* Display Trends */
ELSE IF @Switch = 6
BEGIN
SELECT Tag FROM NewsFeed_Tags ORDER BY Tag ASC
END
/* Check Search Limit */
ELSE IF @Switch = 7
BEGIN
SELECT COUNT(*) AS [Count] FROM (SELECT [IPAddress], [DateTime] FROM [NewsFeed_SearchHistory] WHERE [IPAddress] = @UserIP AND (DATEDIFF(mi,DateTime,GETDATE()) <= 60)) t
END
/* Check Star Limit */
ELSE IF @Switch = 8
BEGIN
SELECT COUNT(*) AS [Count] FROM NewsFeed_StarredArticles WHERE UserIPAddress = @UserIP AND (DATEDIFF(hh,DateTime,GETDATE()) <= 24)
END
/* Top Articles - Favorite Articles */
ELSE IF @Switch = 9
BEGIN
SELECT NewsFeed_NewsArticles.ID, NewsFeed_NewsArticles.Reporter, NewsFeed_NewsArticles.Article, NewsFeed_NewsArticles.URL, NewsFeed_NewsArticles.DateTime, NewsFeed_NewsArticles.Summary, NewsFeed_StarredArticles.UserIPAddress FROM NewsFeed_NewsArticles LEFT JOIN NewsFeed_StarredArticles ON NewsFeed_NewsArticles.ID = NewsFeed_StarredArticles.NewsArticleID WHERE NewsFeed_StarredArticles.UserIPAddress = @UserIP ORDER BY NewsFeed_NewsArticles.DateTime DESC
END
/* Display Available Star Count */
ELSE IF @Switch = 10
BEGIN
SELECT ID FROM NewsFeed_StarredArticles WHERE UserIPAddress = @UserIP AND (datediff(hh,DateTime,GETDATE()) <= 24)
END
END        
