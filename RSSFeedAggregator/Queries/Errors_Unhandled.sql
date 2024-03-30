SELECT TOP (1000) [ID]
      ,[Type]
      ,[Message]
      ,[Source]
      ,[FeedName]
      ,[ArticleTitle]
      ,[Subroutine]
      ,[DateTime]
      ,[Handled]
  FROM [RSSFunctionApp_ErrorLogs] 
  WHERE Handled = 0 AND Message NOT IN ('The operation has timed out.', 'The remote server returned an error: (503) Service Unavailable.',
  'The remote server returned an error: (504) Gateway Time-out.','The remote server returned an error: (502) Bad Gateway.','The response ended prematurely.') AND Type NOT IN ('XmlException')
  ORDER BY DateTime DESC