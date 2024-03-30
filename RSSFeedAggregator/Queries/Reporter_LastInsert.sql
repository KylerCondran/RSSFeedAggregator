select x.reporter, x.datetime
from (
    select reporter, datetime,
        row_number() over (partition by reporter order by datetime desc) as _rn
    from NewsFeed_NewsArticles 
) x
where x._rn = 1
ORDER BY DateTime ASC
