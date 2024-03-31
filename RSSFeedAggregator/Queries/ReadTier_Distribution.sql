/* This query finds the overall readtier distribution - use this to spread the RSS Feeds out uniformly in fast, regular, or slow, for best performance */
SELECT '1' AS [Tier], Count(*) AS [Fast]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 1
SELECT '2' AS [Tier], Count(*) AS [Fast]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 2
SELECT '3' AS [Tier], Count(*) AS [Fast]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 3
SELECT '4' AS [Tier], Count(*) AS [Fast]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 4
SELECT '5' AS [Tier], Count(*) AS [Regular]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 5
SELECT '6' AS [Tier], Count(*) AS [Regular]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 6
SELECT '7' AS [Tier], Count(*) AS [Regular]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 7
SELECT '8' AS [Tier], Count(*) AS [Regular]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 8
SELECT '9' AS [Tier], Count(*) AS [Regular]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 9
SELECT '10' AS [Tier], Count(*) AS [Regular]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 10
SELECT '11' AS [Tier], Count(*) AS [Slow]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 11
SELECT '12' AS [Tier], Count(*) AS [Slow]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 12
SELECT '13' AS [Tier], Count(*) AS [Slow]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 13
SELECT '14' AS [Tier], Count(*) AS [Daily]
  FROM [RSSFunctionApp_RSSFeeds] WHERE Enabled = 1 AND ReadTier = 14
