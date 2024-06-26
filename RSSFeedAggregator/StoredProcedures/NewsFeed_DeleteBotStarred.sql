USE [Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NewsFeed_DeleteBotStarred] 
       @NewsArticleID                      int  = NULL
AS 
BEGIN 
SET NOCOUNT ON 
DELETE FROM [NewsFeed_StarredArticles] WHERE NewsArticleID = @NewsArticleID AND UserIPAddress IN ('StarBot1', 'StarBot2', 'StarBot3', 'StarBot4')
END