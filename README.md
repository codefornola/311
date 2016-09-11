# 311 app

We want to build something better than the default Socrata 311 site:
http://311explorer.nola.gov/main/category/

Keep useful features and enhance the user experience:

As a user,
I want to lookup info about my request (by entering a reference # received from 311).
I want to visualize ticket types with bar charts (counts) and pie graphs (percentage).
I want to visualize the data on a map around me and filter by ticket type, open/closed, date range.
I want to browse curated datasets before exploring the data myself (maybe showing less data that's
more recent data will be useful; maybe by sharing my location, I can see more relevant data on a map
zoomed to my address).


As a developer,
I want to store the 311 data in a database so we can query it more efficiently.

## prerequisites

We recommend using Homebrew to install components on the Mac.

* Postgres database.
* Postgis. 

If you do not already have these components installed, ask someone on the project to help you get it installed on your machine.

## get the data

```
# get bulk call data data.nola.gov
wget -O 311-calls.csv 'https://data.nola.gov/api/views/3iz8-nghx/rows.csv?accessType=DOWNLOAD'
```

## create the db

```
brew install postgres ## if not already installed
brew install postgis ## if not already installed
createuser three11
createdb three11 -O three11
psql -d three11 -c "create extension postgis;"
```

## load data into db

```
# ogr2ogr is a useful tool for working with geospatial data
brew install gdal --with-postgres ## if not already installed
ogr2ogr -f PostgreSQL PG:"host='localhost' dbname='three11' user='three11'" 311-calls.csv -nln calls

# add location column
psql -U three11 -c "ALTER TABLE calls ADD COLUMN the_geom geometry(POINT, 4326);"
psql -U three11 -c "UPDATE calls SET the_geom = ST_PointFromText(geom, 4326) WHERE geom != '';"
```

## useful data to know about

Show on map: Request per district (legend gets darker for more requests)
Frequency: analyze the frequency of 311 incidents
