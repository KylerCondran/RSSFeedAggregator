# RSS Feed Aggregator

RSS Feed Aggregator is a database driven RSS Feed Aggregator application built on Azure Functions. It contains the backend features for the administration of a news aggregation website. If you want to build your own news website this is a great place to start!

## Download
Code available on GitHub [Download](https://github.com/KylerCondran/RSSFeedAggregator)

## Getting Started

1. Acquire an [Azure Functions](https://azure.microsoft.com/) instance, it is free for new signups for 30 days. If you want to instead host the application yourself you can convert it to a C# console application.

2. Acquire a MS SQL Server instance where you can host a database. Once you have a database you can use the .SQL files in the Table Schemas folder to create the initial tables. Also run and create the Stored Procedures.

3. Add your database connection string in the initialization method. Also set the user agent string and paywall remover website if interested.

4. The main run method contains a [NCRONTAB Timer Trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-timer) "0 0 * * * *", this controls how often the application is executed.

5. The main run method contains time wheels, switch statements that break up the workload of downloading large volumes of RSS feeds when executed during certain hours of the day. Each readtier is a block of RSSFeeds which will be downloaded together in batches. It is a good idea to spread RSS Feeds out uniformly in these tiers for best performance.

- ReadTiers 1-4: Fast - check every four hours (6 times per day)
- ReadTiers 5-10: Regular - check every 6 hours (4 times per day)
- ReadTiers 11-13: Slow - check every 12 hours (2 times per day)
- ReadTier 14: Daily - every 24 hours (1 time per day)

6. Use the RSSFeeds_Insert.sql file in the Queries folder to add RSS feeds to the RSSFunctionApp_RSSFeeds Table. Set enabled to 1 to turn it on, set compareall if the RSS feed serves feeds from other providers, set removepaywall if the feed contains content that is paywalled, set ingestion logging when first activating to monitor if you are under consuming or over consuming the feed in the RSSFunctionApp_IngestionLogs Table, you can speed it up or slow it down by switching readtiers depending on how often the RSS feed posts new content. It is best to not over consume the feed so you do not risk getting blocked.

7. Trends are generated every 12 hours in the NewsFeed_Tags table, it reads every news article title and picks out the most frequent words. If you do not want a trend to appear in the trend table, add the word to the NewsFeed_BannedTrends table.

8. Article title scoring is done when keywords are added to the TopArticles_StarbotKeywords table, there are 12 tiers a keyword can have. Tiers 1-6 are positive scoring words, tiers 7-12 are negative scoring words. The total score for the article title is calculated and added so it can appear higher or lower in a website feed.

- Tier 1: 13 points
- Tier 2: 11 points
- Tier 3: 9 points
- Tier 4: 5 points
- Tier 5: 3 points
- Tier 6: 1 point
- Tier 7: -1 point
- Tier 8: -3 points
- Tier 9: -5 points
- Tier 10: -9 points
- Tier 11: -11 points
- Tier 12: -13 points

This allows you to score articles based on what you are most interested in and what you are not interested in. This list is completely subjective and to be designed by you based on what news articles are most interesting to you. It is best to add several thousand words to this table to make articles scored efficiently.

9. After your scoring system is set up, periodically bots will go through and favorite articles that have the highest scores. There are currently 4 bots. Bot one will favorite an article once an hour. Bot two will favorite an article four times a day. Bot three will favorite an article twice a day. Bot four will favorite an article once per day. This causes a staggering effect that can easily be overpowered by legitimate users and causes interesting articles to be shifted towards the top to potentially catch a users interest.

## Questions?

Feel free to contact me with any questions!

You can reach me on [LinkedIn](https://www.linkedin.com/in/kylercondran/) or check out my [GitHub](https://github.com/KylerCondran/) for my other projects.
