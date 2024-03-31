USE [Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [NewsFeed_DisplayComments] 
       @NewsArticleID                      INT  = NULL
AS 
BEGIN 
SET NOCOUNT ON 
SELECT ID, UserName + ':' AS [UserName], Comment FROM [NewsFeed_ArticleComments] WHERE NewsArticleID = @NewsArticleID ORDER BY DateTime DESC
END