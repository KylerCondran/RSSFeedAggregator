USE [Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NewsFeed_MainFeed] 
       @UserIP                      NVARCHAR(25)  = NULL
AS 
BEGIN 
SET NOCOUNT ON 
SELECT TOP 1000 NewsFeed_NewsArticles.ID, NewsFeed_NewsArticles.URL, NewsFeed_NewsArticles.Summary, NewsFeed_NewsArticles.DateTime, CASE WHEN NewsFeed_StarredArticles.UserIPAddress IS NULL THEN 'No' ELSE 'Yes' END AS [IsStarred], CASE WHEN x.NewsArticleID IS NULL THEN 'No' ELSE 'Yes' END AS [HasComment], NewsFeed_NewsArticles.Reporter, replace(NewsFeed_NewsArticles.Article, 'Breaking: ', '') AS [Article] FROM NewsFeed_NewsArticles LEFT JOIN NewsFeed_StarredArticles ON NewsFeed_NewsArticles.ID = NewsFeed_StarredArticles.NewsArticleID AND NewsFeed_StarredArticles.UserIPAddress = @UserIP OUTER APPLY (SELECT TOP 1 NewsArticleID FROM NewsFeed_ArticleComments WHERE NewsArticleID = NewsFeed_NewsArticles.ID) x WHERE (NewsFeed_NewsArticles.Article LIKE ('Breaking:%') OR StarBotScore > 28) ORDER BY NewsFeed_NewsArticles.DateTime DESC
END