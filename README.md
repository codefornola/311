# 311 app [![Build Status](https://travis-ci.org/codefornola/311.svg?branch=master)](https://travis-ci.org/codefornola/311)

**Docker Image** [![](https://images.microbadger.com/badges/image/codefornola/311.svg)](https://microbadger.com/images/codefornola/311 "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/codefornola/311.svg)](https://microbadger.com/images/codefornola/311 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/codefornola/311.svg)](https://microbadger.com/images/codefornola/311 "Get your own commit badge on microbadger.com")

The city now has a pretty good site for vizualizing the 311 (and other open data) so you should check it out here: https://explore.nola.gov/

Also, you can submit a 311 ticket online now! https://www.nola.gov/311/

This purpose of this project will now focus on working with the 311 data for data analysis use cases.  


## Prerequisites

Ensure you have [Docker](https://www.docker.com/community-edition) b/c that makes the database installation easier.

You will also need to install Python and Jupiter Notebooks to work with the data.  We recommend downloading 
[Anaconda](https://www.anaconda.com/download/) to do this. 

> You probably want to download the Python 3 version b/c Python 2 will become unsupported [soon](https://pythonclock.org/)



## Database setup

For local development, you can use Docker to setup the database
```
docker-compose up -d db
```

Then you can run the `setup.sh` script to download the data and load it into the database.

```
./setup.sh
```

If you are loading the data into a remote database, use environment variables
to tell the script where to load:

```
NOLA311_DB_USER=nola311 \
NOLA311_DB_NAME=nola311 \
NOLA311_DB_HOST=c2rp0kujqp.us-east-1.rds.amazonaws.com \
NOLA311_DB_PORT=5432 \
./setup.sh
```

### Getting Started

Once `jupiter` is installed, you can start the notebook server and open the "Getting Started" notebook

```
jupyter notebook Getting_Started.ipynb
```


## some sample queries on the database

Login to the db with psql `psql -h localhost -U nola311` and run some queries:

```sql
-- what are the top issues that people call about?
select issue_type, count(*) as num_calls
from nola311.calls
group by issue_type
order by num_calls desc;

-- which council district has the most calls?
select council_district, count(*) as num_calls
from nola311.calls
group by council_district
order by num_calls desc;

-- how many pothole calls have been opened and closed this year?
select ticket_status, count(*) as total
from nola311.calls
where issue_type = 'Pothole/Roadway Surface Repair'
and ticket_created_date_time >= '2018-01-01'::date
group by ticket_status;

--- dont forget to checkout the views
select *
from open_tickets_stats
where issue_type = 'Catch Basin Maintenance'
and year_created = '2018';
```
