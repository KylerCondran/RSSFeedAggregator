/* This query finds RSS Feeds that are being under consumed - decrease the readtier number in the RSSFunctionAPP_RSSFeeds table to speed up the consumption rate */
SELECT FeedName, count(*) AS [UploadedPercentage]
FROM [RSSFunctionApp_IngestionLogs]
WHERE UploadedPercentage = '100'
GROUP BY FeedName
HAVING COUNT(*) > 0
ORDER BY UploadedPercentage DESC