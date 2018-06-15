#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash

# sanitize the tables
psql $NOLA311_DB_URI -f setup/sanitize_call_data.sql
psql $NOLA311_DB_URI -f setup/sanitize_neighborhood_data.sql

# create views
psql $NOLA311_DB_URI -f views/open_tickets_stats.sql -q
psql $NOLA311_DB_URI -f views/closed_tickets_stats.sql -q
psql $NOLA311_DB_URI -f views/call_records_for_review.sql -q
psql $NOLA311_DB_URI -f views/call_records_with_call_for_details.sql -q
