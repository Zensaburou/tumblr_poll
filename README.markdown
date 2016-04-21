## Tumblr Poller

This application polls post information in a given time range from the [Tumblr API](https://www.tumblr.com/docs/en/api/v2) and saves it to a SQLite database.
A [Morishita Overlap Index](https://en.wikipedia.org/wiki/Morisita%27s_overlap_index) and a [Hunter-Gaston/Simpson Diversity Index](https://en.wikipedia.org/wiki/Diversity_index) can then be calculated to determine the relative similarity of reblog source material as well as the diversity of reblog sources.

#### Setup

* Create database with `$ rake db:create`

* Add `.env` to the root directory according to the following template:

```
NEWEST_TIMESTAMP: <Most recent timestamp>
OLDEST_TIMESTAMP: <Oldest timestamp>
CONSUMER_KEY: <tumblr API consumer key>
CONSUMER_SECRET: <tumblr API consumer secret>
OAUTH_TOKEN: <tumblr API oauth token>
OAUTH_TOKEN_SECRET: <tumblr API oauth token secret>
```

#### Polling and analyzing data

Run the poll with `$ rake tumblr:poll`. Posts are saved within the given timestamp range for each blog in the database

Simpson indices can be calculated on blogs with `$ rake tumblr:simpsons`

Morishita Overlaps are calculated with `$ rake tumblr:overlaps`
