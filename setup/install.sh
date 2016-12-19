#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash

# sanitize the tables
psql -U nola311 -d nola311 -f setup/sanitize_call_data.sql
psql -U nola311 -d nola311 -f setup/sanitize_neighborhood_data.sql

# create views
psql -U nola311 -d nola311 -f views/open_tickets_stats.sql -q
psql -U nola311 -d nola311 -f views/closed_tickets_stats.sql -q
psql -U nola311 -d nola311 -f views/call_records_for_review.sql -q
psql -U nola311 -d nola311 -f views/call_records_with_call_for_details.sql -q
