USE [Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NewsFeed_AddStarredArticle] 
       @IPAddress                      NVARCHAR(25)  = NULL   , 
       @NewsArticleID                      int  = NULL   
AS 
BEGIN 
SET NOCOUNT ON 
IF NOT EXISTS (SELECT ID FROM NewsFeed_StarredArticles WHERE UserIPAddress = @IPAddress AND NewsArticleID = @NewsArticleID)
	BEGIN
	INSERT INTO NewsFeed_StarredArticles (NewsArticleID, UserIPAddress, DateTime) VALUES (@NewsArticleID, @IPAddress, GETDATE())
	END        
END
