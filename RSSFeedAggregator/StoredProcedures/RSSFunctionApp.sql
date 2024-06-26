USE [Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RSSFunctionApp] 
	@Switch                      INT  = NULL,
	@ReadTier					 INT = NULL,
	@TopCount					 INT = NULL,
	@FromRange				   	 INT = NULL,
	@ToRange				   	 INT = NULL,
	@BotNumber         NVARCHAR(25)  = NULL
AS 
BEGIN 
SET NOCOUNT ON 
/* Main - Read Keywords */
IF @Switch = 1 
BEGIN
SELECT Keyword, Tier FROM TopArticles_StarbotKeywords ORDER BY Keyword ASC
END
/* Read RSSLists */
ELSE IF @Switch = 2
BEGIN
SELECT FeedName, URL, CompareAll, RemovePaywall, IngestionLogging FROM RSSFunctionApp_RSSFeeds WHERE ReadTier = @ReadTier AND Enabled = 1 ORDER BY FeedName ASC
END
/* Generate Tags - Read Banned Trends */
ELSE IF @Switch = 3
BEGIN
SELECT Trend FROM NewsFeed_BannedTrends ORDER BY Trend ASC
END
/* Generate Tags - Read Articles */
ELSE IF @Switch = 4
BEGIN
SELECT Article FROM NewsFeed_NewsArticles
END
/* Delete Older Than 2 Weeks/Delete old error log timeouts */
ELSE IF @Switch = 5
BEGIN
DELETE FROM NewsFeed_NewsArticles WHERE datediff(d,DateTime,GETDATE()) > 14
DELETE FROM NewsFeed_StarredArticles WHERE NewsArticleID NOT IN (SELECT ID FROM NewsFeed_NewsArticles) OR NOT (DateTime BETWEEN cast(DATEADD(day,-14,GETDATE()) AS Date) AND GETDATE())
DELETE FROM RSSFunctionApp_ErrorLogs WHERE Message IN ('The operation has timed out.', 'The remote server returned an error: (503) Service Unavailable.',
  'The remote server returned an error: (504) Gateway Time-out.','The remote server returned an error: (502) Bad Gateway.','The response ended prematurely.') AND NOT (DateTime BETWEEN cast(DATEADD(day,-14,GETDATE()) AS Date) AND GETDATE())
UPDATE RSSFunctionApp_ErrorLogs SET Handled = 1 WHERE Type = 'XmlException' AND NOT (DateTime BETWEEN cast(DATEADD(day,-14,GETDATE()) AS Date) AND GETDATE()) AND Handled = 0
END
/* Delete Old Tags */
ELSE IF @Switch = 6
BEGIN
DELETE FROM NewsFeed_Tags
END
/* Fetch Articles To Star */
ELSE IF @Switch = 7
BEGIN
SELECT TOP (@TopCount) ID FROM NewsFeed_NewsArticles WHERE (DateTime BETWEEN dateadd(hour,@FromRange,GETDATE()) AND dateadd(hour,@ToRange,GETDATE())) AND ID NOT IN (SELECT NewsArticleID FROM NewsFeed_StarredArticles WHERE UserIPAddress = @BotNumber) AND Article NOT IN (SELECT NewsFeed_NewsArticles.Article FROM NewsFeed_NewsArticles INNER JOIN NewsFeed_StarredArticles ON NewsFeed_NewsArticles.ID = NewsFeed_StarredArticles.NewsArticleID WHERE NewsFeed_StarredArticles.UserIPAddress = @BotNumber) AND StarBotScore > 0 ORDER BY StarBotScore DESC
END
END        
