/* This query finds RSS Feeds that are being over consumed - increase the readtier number in the RSSFunctionAPP_RSSFeeds table to slow down the consumption rate */
SELECT FeedName, count(*) AS [UploadedPercentage]
FROM [RSSFunctionApp_IngestionLogs]
WHERE UploadedPercentage = '0'
GROUP BY FeedName
HAVING COUNT(*) > 0
ORDER BY UploadedPercentage DESC