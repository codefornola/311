#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash

# create the db
createuser nola311
createdb nola311 -O nola311

# create the table and import the data from the csv
psql -U postgres -d nola311 -f setup/schema_and_csv_import.sql

# sanitize the table
psql -U postgres -d nola311 -f setup/sanitize.sql

# create views
psql -U postgres -d nola311 -f views/open_tickets_stats.sql -q
psql -U postgres -d nola311 -f views/closed_tickets_stats.sql -q
psql -U postgres -d nola311 -f views/call_records_for_review.sql -q
