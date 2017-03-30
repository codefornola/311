#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash

DB_USER=${DB_USER:-postgres}
DB_HOST=${DB_HOST:-localhost}
DB_NAME=${DB_NAME:-nola311}

# sanitize the tables
psql -U $DB_USER -d $DB_NAME -h $DB_HOST -f setup/sanitize_call_data.sql
psql -U $DB_USER -d $DB_NAME -h $DB_HOST -f setup/sanitize_neighborhood_data.sql

# create views
psql -U $DB_USER -d $DB_NAME -h $DB_HOST -f views/open_tickets_stats.sql -q
psql -U $DB_USER -d $DB_NAME -h $DB_HOST -f views/closed_tickets_stats.sql -q
psql -U $DB_USER -d $DB_NAME -h $DB_HOST -f views/call_records_for_review.sql -q
psql -U $DB_USER -d $DB_NAME -h $DB_HOST -f views/call_records_with_call_for_details.sql -q
