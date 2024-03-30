SELECT TOP (1000) [ID]
      ,[FeedName]
      ,[URL]
      ,[ReadTier]
      ,[Enabled]
	  ,[CompareAll]
	  ,[RemovePaywall]
	  ,[IngestionLogging]
	  ,CASE
    WHEN ReadTier = 1 THEN '7PM,11PM,3AM,7AM,11AM,3PM'
    WHEN ReadTier = 2 THEN '6PM,10PM,2AM,6AM,10AM,2PM'
    WHEN ReadTier = 3 THEN '9PM,1AM,5AM,9AM,1PM,5PM'
    WHEN ReadTier = 4 THEN '8PM,12AM,4AM,8AM,12PM,4PM'
    WHEN ReadTier = 5 THEN '5PM,11PM,5AM,11AM'
    WHEN ReadTier = 6 THEN '10PM,4AM,10AM,4PM'
    WHEN ReadTier = 7 THEN '9PM,3AM,9AM,3PM'
    WHEN ReadTier = 8 THEN '8PM,2AM,8AM,2PM'
    WHEN ReadTier = 9 THEN '7PM,1AM,7AM,1PM'
    WHEN ReadTier = 10 THEN '6PM,12AM,6AM,12PM'
    WHEN ReadTier = 11 THEN '4AM,4PM'
    WHEN ReadTier = 12 THEN '8AM,8PM'
    WHEN ReadTier = 13 THEN '12AM,12PM'
    WHEN ReadTier = 14 THEN '5AM'
END AS [ReadTimes]
	  ,[Category]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 ORDER BY ReadTier, FeedName ASC
