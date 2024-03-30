SELECT FeedName, count(*) AS [UploadedPercentage]
FROM [RSSFunctionApp_IngestionLogs]
WHERE UploadedPercentage = '0'
GROUP BY FeedName
HAVING COUNT(*) > 0
ORDER BY UploadedPercentage DESC