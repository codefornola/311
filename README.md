# 311 app

We want to build something better than the default Socrata 311 site:
http://311explorer.nola.gov/main/category/

Here are some vague user stories explaining the main features:

As a citizen,
* I want to lookup info about my 311 request (by entering a reference # received from 311 or searching my previous history).
* I want to visualize ticket types with bar charts (counts) and pie graphs (percentage).
* I want to visualize the data on a map around me and filter and sort by ticket type, open/closed, date range.
* I want to browse curated datasets before exploring the data myself (maybe showing less data that's
more recent data will be useful; maybe by sharing my location, I can see more relevant data on a map
zoomed to my address).
* I want to see open requests near me.
* I want to submit issues that integrate with the City's system (the city 311 system can notify the user).
* I want the ability to choose the amount of information to share about myself (email required to submit ticket?)

Other nice to have features:
* Commenting and upvoting on issues nearby me
* Get notified about issues created by others (star/follow)
* See filter of all issues a user has submitted (email required)
* Map feature: Request per district (styled where color gets darker for more requests)
* Frequency: analyze the frequency of 311 incidents (median time, types
  that stay open the longest, etc)


## database setup

First you need to install PostgreSQL and PostGIS.

Once those are available, you can run the `setup.sh` script:

```
./setup.sh
```

If you are loading the data into a remote database, use environment variables
to tell the script where to load:

```
DB_USER=nola311 DB_NAME=nola311 DB_HOST=c2rp0kujqp.us-east-1.rds.amazonaws.com ./setup.sh
```

## some sample queries

Login to the db with psql `psql -h localhost -U nola311` and run some queries:

```sql
-- what are the top issues that people call about?
select issue_type, count(*) as num_calls from nola311.calls group by issue_type order by num_calls desc;

-- which council district has the most calls?
select council_district, count(*) as num_calls from nola311.calls group by council_district order by num_calls desc;

-- how many pothole calls have been opened and closed this year?
select ticket_status, count(*) as total from nola311.calls where issue_type = 'Pothole/Roadway Surface Repair' and ticket_created_date_time >= '2017-01-01'::date group by ticket_status;

--- dont forget to checkout the views 

select * from open_tickets_stats where issue_type = 'Catch Basin Maintenance' and year_created = '2017';
```
