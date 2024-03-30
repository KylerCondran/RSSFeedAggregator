SELECT FeedName, count(*) AS [UploadedPercentage]
FROM [RSSFunctionApp_IngestionLogs]
WHERE UploadedPercentage = '100'
GROUP BY FeedName
HAVING COUNT(*) > 0
ORDER BY UploadedPercentage DESC