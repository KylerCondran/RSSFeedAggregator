# RSS Feed Aggregator

RSS Feed Aggregator is a database driven RSS Feed Aggregator application built on Azure Functions. It contains the backend features for the administration of a news aggregation website. If you want to build your own news website this is a great place to start!

## Download
Code available on GitHub [Download](https://github.com/KylerCondran/RSSFeedAggregator)

## Getting Started

1. Acquire an [Azure Functions](https://azure.microsoft.com/) instance, it is free for new signups for 30 days. If you want to instead host the application yourself you can convert it to a C# console application.

2. Acquire a MS SQL Server instance where you can host a database. Once you have a database you can use the .SQL files in the Table Schemas folder to create the initial tables. Also run and create the Stored Procedures.

3. Add your connection string to the database in the initialization method. Also set the UserAgent string and PayWallRemover website if interested.

4. The main run method contains a [NCRONTAB Timer Trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-timer) "0 0 * * * *", this controls how often the application is executed.

5. The main run method contains time wheels, switch statements that break up the workload of downloading large volumes of RSS feeds when executed during certain hours of the day. Each readtier is a block of RSSFeeds which will be downloaded together in batches. It is a good idea to spread RSS Feeds out uniformly in these tiers for best performance.

- ReadTiers 1-4: Fast - check every four hours (6 times per day)
- ReadTiers 5-10: Regular - check every 6 hours (4 times per day)
- ReadTiers 11-13: Slow - check every 12 hours (2 times per day)
- ReadTier 14: Daily - every 24 hours (1 time per day)

6. Use the RSSFeeds_Insert.sql file in the Queries folder to add RSS feeds to the RSSFunctionApp_RSSFeeds Table. Set enabled to 1 to turn it on, set compareall if the RSS feed serves feeds from other providers, set removepaywall if the feed contains content that is paywalled, set ingestion logging when first activating to see if you are under consuming or over consuming the feed, it can be sped up or slowed down depending on how often the RSS feed posts new content.

## Questions?

Feel free to contact me with any questions!

You can reach me on [LinkedIn](https://www.linkedin.com/in/kylercondran/) or check out my [GitHub](https://github.com/KylerCondran/) for my other projects.
