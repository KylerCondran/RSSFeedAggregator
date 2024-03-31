using System;
using Microsoft.Azure.WebJobs;
using System.Data.SqlClient;
using System.Net;
using System.ServiceModel.Syndication;
using System.Xml;
using System.Text.RegularExpressions;
using System.Data;
using System.Collections.Generic;
using System.Linq;

namespace RSSFeedAggregator
{
    public class RSSFeedAggregator
    {
        string _connectionString;
        string _userAgent;
        string _paywallRemover;
        int _connectionTimeout;
        int _ArticleKeepAge;
        Dictionary<string, int> _ArticleScoreKeywords;

        #region "Initialization"      
        public void Initialize()
        {
            _connectionString = "ConnectionStringGoesHere";
            _userAgent = "UserAgentGoesHere";
            _connectionTimeout = 5000; //(milliseconds) 5 second timeout
            _paywallRemover = "https://PaywallRemoverWebsite/proxy?q=";
            _ArticleKeepAge = -14; //(days) fetch articles with an age of 2 weeks maximum
            _ArticleScoreKeywords = InitKeywordTable();
        }
        #endregion

        #region "Main"
        [FunctionName("RSSFeedAggregator")]
        public void Run([TimerTrigger("0 0 * * * *")] TimerInfo myTimer)
        {
            try
            {
                Initialize();
                //Fast - every four hours time wheel (6 times per day)
                switch (true)
                {
                    case bool _ when DateTime.Now.AddHours(1).Hour % 4 == 0:
                        ReadRssLists(1);
                        StarBot(1, 1, -5, 7);
                        break;
                    case bool _ when DateTime.Now.AddHours(2).Hour % 4 == 0:
                        ReadRssLists(2);
                        StarBot(1, 1, -5, 7);
                        break;
                    case bool _ when DateTime.Now.AddHours(3).Hour % 4 == 0:
                        ReadRssLists(3);
                        StarBot(1, 1, -5, 7);
                        break;
                    case bool _ when DateTime.Now.Hour % 4 == 0:
                        ReadRssLists(4);
                        StarBot(1, 1, -5, 7);
                        break;
                }
                //Regular - every 6 hours time wheel (4 times per day)
                switch (true)
                {
                    case bool _ when DateTime.Now.AddHours(1).Hour % 6 == 0:
                        ReadRssLists(5);
                        break;
                    case bool _ when DateTime.Now.AddHours(2).Hour % 6 == 0:
                        ReadRssLists(6);
                        break;
                    case bool _ when DateTime.Now.AddHours(3).Hour % 6 == 0:
                        ReadRssLists(7);
                        break;
                    case bool _ when DateTime.Now.AddHours(4).Hour % 6 == 0:
                        ReadRssLists(8);
                        break;
                    case bool _ when DateTime.Now.AddHours(5).Hour % 6 == 0:
                        ReadRssLists(9);
                        break;
                    case bool _ when DateTime.Now.Hour % 6 == 0:
                        ReadRssLists(10);
                        break;
                }
                //Slow - every 12 hours time wheel (2 times per day)
                switch (true)
                {
                    case bool _ when DateTime.Now.AddHours(4).Hour % 12 == 0:
                        ReadRssLists(11);
                        StarBot(2, 1, -17, 7);
                        break;
                    case bool _ when DateTime.Now.AddHours(8).Hour % 12 == 0:
                        ReadRssLists(12);
                        StarBot(3, 1, -161, 7);
                        break;
                    case bool _ when DateTime.Now.Hour % 12 == 0:
                        ReadRssLists(13);
                        StarBot(2, 1, -17, 7);
                        DeleteOldTags();
                        GenerateTags();
                        break;
                }
                //Daily - every 24 hours (1 time per day)
                switch (DateTime.Now.Hour)
                {
                    case 1:
                        DeleteOlderThan2Weeks();
                        break;
                    case 5:
                        ReadRssLists(14);
                        StarBot(4, 1, -329, 7);
                        break;
                }
            }
            catch (Exception e)
            {
                TryToDumpErrorToDB(e, "None", "None", "Main Method");
            }
        }
        #endregion

        #region "RSS Reading Subs"
        public void ReadRssLists(int readtier)
        {
            try
            {
                using SqlConnection conn = new(_connectionString);
                conn.Open();
                using SqlCommand comm = new();
                comm.Connection = conn;
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandText = "RSSFunctionApp";
                comm.Parameters.AddWithValue("@Switch", 2);
                comm.Parameters.AddWithValue("@ReadTier", readtier);
                using SqlDataReader rdr = comm.ExecuteReader();
                while (rdr.Read())
                {
                    try
                    {
                        string thefeedname = rdr.GetString(0);
                        string thefeedurl = rdr.GetString(1);
                        bool compareall = rdr.GetBoolean(2);
                        bool removepaywall = rdr.GetBoolean(3);
                        bool ingestionlogging = rdr.GetBoolean(4);
                        ReadTheFeed(thefeedname, thefeedurl, compareall, removepaywall, ingestionlogging);
                    }
                    catch (Exception e)
                    {
                        TryToDumpErrorToDB(e, "None", "None", "ReadRSSLists");
                    }
                }
                conn.Close();
            }
            catch (Exception e)
            {
                TryToDumpErrorToDB(e, "None", "None", "ReadRSSLists");
            }
        }

        public void ReadTheFeed(string feedname, string feedurl, bool compareall, bool removepaywall, bool ingestionlogging)
        {
            HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create(feedurl);
            myReq.UserAgent = _userAgent;
            myReq.Timeout = _connectionTimeout;
            try
            {
                using HttpWebResponse response = (HttpWebResponse)myReq.GetResponse();
                using XmlReader reader = XmlReader.Create(response.GetResponseStream());
                SyndicationFeed feed = SyndicationFeed.Load(reader);
                if (feed == null) return;
                try
                {
                    List<string> linkList = InitLinkList(feedname, compareall);
                    int uploadedArticle = 0;
                    int discardedArticle = 0;
                    foreach (SyndicationItem i in feed.Items)
                    {
                        try
                        {
                            string linkuri = "";
                            string imageuri = "";
                            DateTime pubDateTime;
                            try
                            {
                                pubDateTime = i.PublishDate.ToUniversalTime().DateTime;

                            }
                            catch (Exception e)
                            {
                                discardedArticle++;
                                continue;
                            }
                            switch (i.Links.Count)
                            {
                                case 1:
                                    linkuri = i.Links[0].Uri.ToString().ToLower();
                                    break;
                                case > 1:
                                    {
                                        foreach (SyndicationLink x in i.Links)
                                        {
                                            string thislink = x.Uri.ToString();
                                            switch (x.RelationshipType)
                                            {
                                                case null:
                                                    continue;
                                                case "enclosure" when x.MediaType != null:
                                                    {
                                                        if (x.MediaType.Contains("image"))
                                                        {
                                                            List<string> imgExtensions = new() { ".png", ".jpg", ".jpeg", ".gif" };
                                                            foreach (string q in imgExtensions.Where(q => thislink.ToLower().Contains(q)).Where(_ => imageuri == ""))
                                                            {
                                                                imageuri = thislink;
                                                            }
                                                        }
                                                        break;
                                                    }
                                                default:
                                                    {
                                                        if (linkuri == "")
                                                        {
                                                            linkuri = thislink.ToLower();
                                                        }
                                                        break;
                                                    }
                                            }
                                        }
                                        break;
                                    }
                            }
                            if (linkuri == "")
                            {
                                discardedArticle++;
                                continue;
                            }
                            if (removepaywall)
                            {
                                linkuri = _paywallRemover + linkuri;
                            }
                            if (linkList.Contains(linkuri)) continue;
                            if (!IsValidDateKeepRange(pubDateTime) ||
                                linkuri.Length >= 451) continue;
                            string titletext = "";
                            string summarytext = "";
                            if (i.Title.Text != null)
                            {
                                titletext = i.Title.Text;
                                if (titletext.Length > 250)
                                {
                                    titletext = titletext[..250];
                                }
                            }
                            if (i.Summary != null)
                            {
                                summarytext = SummaryClipping(i.Summary.Text);

                            }
                            int articlescore = ArticleScoring(titletext.ToLower());
                            TryToDumpStoryToDB(feedname, titletext, summarytext, linkuri, pubDateTime, articlescore, imageuri);
                            linkList.Add(linkuri);
                            uploadedArticle++;
                        }
                        catch (Exception e)
                        {
                            TryToDumpErrorToDB(e, feedname, "None", "ReadTheFeed3");
                        }
                    }
                    if (ingestionlogging && !(uploadedArticle == 0 && discardedArticle == 0))
                    {
                        LogIngestedPercentage(feedname, uploadedArticle, discardedArticle);
                    }
                }
                catch (Exception e)
                {
                    TryToDumpErrorToDB(e, feedname, "None", "ReadTheFeed2");
                }
            }
            catch (Exception e)
            {
                TryToDumpErrorToDB(e, feedname, "None", "ReadTheFeed1");
            }
        }

        public bool IsValidDateKeepRange(DateTime? dateTime)
        {
            if (dateTime == null) return false;

            DateTime minValue = DateTime.Now.ToUniversalTime().AddDays(_ArticleKeepAge);
            DateTime maxValue = DateTime.Now.ToUniversalTime();

            return minValue <= dateTime.Value && maxValue >= dateTime.Value;
        }

        public static string SummaryClipping(string summary)
        {
            summary = Regex.Replace(summary, "<[^>]*>", string.Empty);
            summary = Regex.Replace(summary, @"\s+", " ");
            if (summary.Length > 2000)
            {
                summary = summary[..2000];
            }
            return summary;
        }

        public int ArticleScoring(string articleTitle)
        {
            int articlescore = 0;
            int maxtierfour = 4;
            int maxtiersix = 8;
            articleTitle = Regex.Replace(articleTitle, "[^a-z ]", string.Empty);
            string[] splitwordarray = articleTitle.Split(" ");
            foreach (string word in splitwordarray)
            {
                if (_ArticleScoreKeywords.ContainsKey(word))
                {
                    switch (_ArticleScoreKeywords[word])
                    {
                        case 1:
                            articlescore += 13;
                            break;
                        case 2:
                            articlescore += 11;
                            break;
                        case 3:
                            articlescore += 9;
                            break;
                        case 4:
                            if (maxtierfour > 0)
                            {
                                maxtierfour -= 1;
                                articlescore += 5;
                            }
                            break;
                        case 5:
                            articlescore += 3;
                            break;
                        case 6:
                            if (maxtiersix > 0)
                            {
                                maxtiersix -= 1;
                                articlescore += 1;
                            }
                            break;
                        case 7:
                            articlescore -= 1;
                            break;
                        case 8:
                            articlescore -= 3;
                            break;
                        case 9:
                            articlescore -= 5;
                            break;
                        case 10:
                            articlescore -= 9;
                            break;
                        case 11:
                            articlescore -= 11;
                            break;
                        case 12:
                            articlescore -= 13;
                            break;
                    }
                }
            }
            return articlescore;
        }

        public List<string> InitLinkList(string feedname, bool compareall)
        {
            List<string> linkList = new();
            string urlselectquery = "SELECT URL FROM NewsFeed_NewsArticles WHERE Reporter = @Reporter ORDER BY DateTime DESC";
            if (compareall) { urlselectquery = "SELECT URL FROM NewsFeed_NewsArticles ORDER BY DateTime DESC"; }

            using SqlConnection conn = new(_connectionString);
            conn.Open();
            using SqlCommand comm = new(urlselectquery, conn);
            if (compareall == false) { comm.Parameters.AddWithValue("@Reporter", feedname); }
            using SqlDataReader rdr = comm.ExecuteReader();
            while (rdr.Read())
            {
                linkList.Add(rdr.GetString(0).ToLower());
            }
            conn.Close();
            return linkList;
        }

        public Dictionary<string, int> InitKeywordTable()
        {
            Dictionary<string, int> keywordTable = new();
            using SqlConnection conn = new(_connectionString);
            conn.Open();
            using SqlCommand comm = new();
            comm.Connection = conn;
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandText = "RSSFunctionApp";
            comm.Parameters.AddWithValue("@Switch", 1);
            using SqlDataReader rdr = comm.ExecuteReader();
            while (rdr.Read())
            {
                keywordTable.Add(rdr.GetString(0).ToLower(), rdr.GetInt32(1));
            }
            conn.Close();
            return keywordTable;
        }
        #endregion

        #region "Database Inserts"       
        public void TryToDumpStoryToDB(string feedName, string title, string summary, string link, DateTime pubDate, int articleScore, string image)
        {
            using SqlConnection conn = new(_connectionString);
            using SqlCommand comm = new("INSERT INTO NewsFeed_NewsArticles (Reporter, Article, URL, DateTime, Summary, StarBotScore, Image) VALUES (@Reporter, @Article, @URL, @DateTime, @Summary, @StarBotScore, @Image)", conn);
            comm.CommandType = CommandType.Text;
            comm.Parameters.AddWithValue("@Reporter", feedName);
            comm.Parameters.AddWithValue("@Article", title);
            comm.Parameters.AddWithValue("@Summary", summary);
            comm.Parameters.AddWithValue("@URL", link);
            comm.Parameters.AddWithValue("@DateTime", pubDate);
            comm.Parameters.AddWithValue("@StarBotScore", articleScore);
            comm.Parameters.AddWithValue("@Image", image);
            try
            {
                conn.Open();
                comm.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                TryToDumpErrorToDB(e, feedName, title, "TryToDumpStoryToDB");
            }
        }

        public void TryToDumpErrorToDB(Exception eMessage, string feedName, string articleTitle, string subroutine)
        {
            try
            {
                string errormessagetext = eMessage.Message;
                string articletext = articleTitle;
                string sourcetext = eMessage.StackTrace;
                string typetext = eMessage.GetType().Name;
                if (errormessagetext.Length > 2000)
                {
                    errormessagetext = errormessagetext[..2000];
                }
                if (articletext.Length > 250)
                {
                    articletext = articletext[..250];
                }
                if (sourcetext is { Length: > 5000 })
                {
                    sourcetext = sourcetext[..5000];
                }
                if (typetext.Length > 2000)
                {
                    typetext = typetext[..2000];
                }
                using SqlConnection conn = new(_connectionString);
                using SqlCommand comm = new("INSERT INTO RSSFunctionApp_ErrorLogs (Type, Message, Source, FeedName, ArticleTitle, Subroutine, DateTime, Handled) VALUES (@Type, @Message, @Source, @FeedName, @ArticleTitle, @Subroutine, GETDATE(), 0)", conn);
                comm.CommandType = CommandType.Text;
                comm.Parameters.AddWithValue("@Type", typetext);
                comm.Parameters.AddWithValue("@Message", errormessagetext);
                comm.Parameters.AddWithValue("@Source", sourcetext);
                comm.Parameters.AddWithValue("@FeedName", feedName);
                comm.Parameters.AddWithValue("@ArticleTitle", articletext);
                comm.Parameters.AddWithValue("@Subroutine", subroutine);
                conn.Open();
                comm.ExecuteNonQuery();
            }
            catch (Exception)
            {
                //Error Writing To Database - Write Error Locally
            }
        }

        public void LogIngestedPercentage(string feedName, int uploadedCount, int discardedCount)
        {
            int totalCount = uploadedCount + discardedCount;
            float uploadedPercentage = (float)uploadedCount / (float)totalCount * 100;
            using SqlConnection conn = new(_connectionString);
            using SqlCommand comm = new("INSERT INTO RSSFunctionApp_IngestionLogs (FeedName, UploadedCount, DiscardedCount, TotalCount, UploadedPercentage, DateTime) VALUES (@FeedName, @UploadedCount, @DiscardedCount, @TotalCount, @UploadedPercentage, GETDATE())", conn);
            comm.CommandType = CommandType.Text;
            comm.Parameters.AddWithValue("@FeedName", feedName);
            comm.Parameters.AddWithValue("@UploadedCount", uploadedCount);
            comm.Parameters.AddWithValue("@DiscardedCount", discardedCount);
            comm.Parameters.AddWithValue("@TotalCount", totalCount);
            comm.Parameters.AddWithValue("@UploadedPercentage", uploadedPercentage);
            try
            {
                conn.Open();
                comm.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                TryToDumpErrorToDB(e, feedName, "", "LogIngestedPercentage");
            }
        }

        public void GenerateTags()
        {
            try
            {
                Dictionary<string, int> tagTable = new();
                List<string> bannedTrendsList = new();

                // Read Banned Trends
                using SqlConnection conn1 = new(_connectionString);
                conn1.Open();
                using SqlCommand comm1 = new();
                comm1.Connection = conn1;
                comm1.CommandType = CommandType.StoredProcedure;
                comm1.CommandText = "RSSFunctionApp";
                comm1.Parameters.AddWithValue("@Switch", 3);
                using SqlDataReader rdr1 = comm1.ExecuteReader();
                while (rdr1.Read())
                {
                    bannedTrendsList.Add(rdr1.GetString(0).ToLower());
                }
                conn1.Close();

                // Read Articles
                using SqlConnection conn2 = new(_connectionString);
                conn2.Open();
                using SqlCommand comm2 = new();
                comm2.Connection = conn2;
                comm2.CommandType = CommandType.StoredProcedure;
                comm2.CommandText = "RSSFunctionApp";
                comm2.Parameters.AddWithValue("@Switch", 4);
                using SqlDataReader rdr2 = comm2.ExecuteReader();
                while (rdr2.Read())
                {
                    string rawstring = rdr2.GetString(0).ToLower();
                    rawstring = Regex.Replace(rawstring, "[^a-z. ]", string.Empty);
                    string[] splitarray = rawstring.Split(" ");
                    foreach (string splitstring in splitarray)
                    {
                        if (bannedTrendsList.Contains(splitstring)) continue;
                        if (tagTable.ContainsKey(splitstring))
                        {
                            tagTable[splitstring]++;
                        }
                        else
                        {
                            tagTable.Add(splitstring, 1);
                        }
                        break;
                    }
                }
                conn2.Close();

                var sortedtagTable = from entry in tagTable orderby entry.Value descending select entry;

                using SqlConnection conn3 = new(_connectionString);
                using SqlCommand comm3 = new("INSERT INTO NewsFeed_Tags (Tag) VALUES (@Tag0),(@Tag1),(@Tag2),(@Tag3),(@Tag4),(@Tag5),(@Tag6),(@Tag7),(@Tag8),(@Tag9),(@Tag10),(@Tag11),(@Tag12),(@Tag13),(@Tag14),(@Tag15),(@Tag16),(@Tag17),(@Tag18),(@Tag19),(@Tag20),(@Tag21),(@Tag22),(@Tag23),(@Tag24),(@Tag25),(@Tag26),(@Tag27),(@Tag28),(@Tag29)", conn3);
                comm3.CommandType = CommandType.Text;
                for (int i = 0; i < 30; i++)
                {
                    comm3.Parameters.AddWithValue("@Tag" + i, sortedtagTable.ElementAt(i).Key);
                }
                conn3.Open();
                comm3.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                TryToDumpErrorToDB(e, "None", "None", "GenerateTags");
            }
        }

        public void StarBot(int botNumber, int starCount, int fromRange, int toRange)
        {
            try
            {
                using SqlConnection conn1 = new(_connectionString);
                conn1.Open();
                using SqlCommand comm1 = new();
                comm1.Connection = conn1;
                comm1.CommandType = CommandType.StoredProcedure;
                comm1.CommandText = "RSSFunctionApp";
                comm1.Parameters.AddWithValue("@Switch", 7);
                comm1.Parameters.AddWithValue("@FromRange", fromRange);
                comm1.Parameters.AddWithValue("@ToRange", toRange);
                comm1.Parameters.AddWithValue("@BotNumber", "StarBot" + botNumber);
                comm1.Parameters.AddWithValue("@TopCount", starCount);
                using SqlDataReader rdr1 = comm1.ExecuteReader();
                while (rdr1.Read())
                {
                    using SqlConnection conn2 = new(_connectionString);
                    using SqlCommand comm2 = new();
                    comm2.Connection = conn2;
                    comm2.CommandType = CommandType.StoredProcedure;
                    comm2.CommandText = "NewsFeed_AddStarredArticle";
                    comm2.Parameters.AddWithValue("@IPAddress", "StarBot" + botNumber);
                    comm2.Parameters.AddWithValue("@NewsArticleID", rdr1.GetInt32(0));
                    conn2.Open();
                    comm2.ExecuteNonQuery();
                }
                conn1.Close();
            }
            catch (Exception e)
            {
                TryToDumpErrorToDB(e, "None", "None", "StarBot");
            }
        }
        #endregion

        #region "Database Deletes"    
        public void DeleteOlderThan2Weeks()
        {
            try
            {
                using SqlConnection conn = new(_connectionString);
                using SqlCommand comm = new();
                comm.Connection = conn;
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandText = "RSSFunctionApp";
                comm.Parameters.AddWithValue("@Switch", 5);
                conn.Open();
                comm.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                TryToDumpErrorToDB(e, "", "", "DeleteOlderThan2Weeks");
            }
        }

        public void DeleteOldTags()
        {
            try
            {
                using SqlConnection conn = new(_connectionString);
                using SqlCommand comm = new();
                comm.Connection = conn;
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandText = "RSSFunctionApp";
                comm.Parameters.AddWithValue("@Switch", 6);
                conn.Open();
                comm.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                TryToDumpErrorToDB(e, "", "", "DeleteOldTags");
            }
        }
        #endregion      
    }
}