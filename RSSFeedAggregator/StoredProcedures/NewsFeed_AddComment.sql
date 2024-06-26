USE [Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NewsFeed_AddComment] 
	   @NewsArticleID                      int  = NULL   ,
	   @IPAddress                      NVARCHAR(25)  = NULL   ,
	   @UserName                     NVARCHAR(25)  = NULL  ,
       @Comment                      NVARCHAR(2000)  = NULL    
 
AS 
BEGIN 
SET NOCOUNT ON 
IF NOT EXISTS (SELECT ID FROM [NewsFeed_ArticleComments] WHERE UserIPAddress = @IPAddress AND NewsArticleID = @NewsArticleID)
	BEGIN
	INSERT INTO NewsFeed_ArticleComments (NewsArticleID, UserIPAddress, UserName, Comment, DateTime) VALUES (@NewsArticleID, @IPAddress, @UserName, @Comment, GETDATE())
	END
END        
