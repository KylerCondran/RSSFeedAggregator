USE [Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [NewsFeed_LogSearch] 
       @IPAddress                      NVARCHAR(100)  = NULL   , 
       @SearchTerm                     NVARCHAR(100)  = NULL   
AS 
BEGIN 
SET NOCOUNT ON 
INSERT INTO NewsFeed_SearchHistory (IPAddress, SearchTerm, DateTime) VALUES (@IPAddress, @SearchTerm, GETDATE())
END        
