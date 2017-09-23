#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash

NOLA311_DB_USER=${NOLA311_DB_USER:-postgres}
NOLA311_DB_HOST=${NOLA311_DB_HOST:-localhost}
NOLA311_DB_NAME=${NOLA311_DB_NAME:-nola311}

# sanitize the tables
psql -U $NOLA311_DB_USER -d $NOLA311_DB_NAME -h $NOLA311_DB_HOST -f setup/sanitize_call_data.sql
psql -U $NOLA311_DB_USER -d $NOLA311_DB_NAME -h $NOLA311_DB_HOST -f setup/sanitize_neighborhood_data.sql

# create views
psql -U $NOLA311_DB_USER -d $NOLA311_DB_NAME -h $NOLA311_DB_HOST -f views/open_tickets_stats.sql -q
psql -U $NOLA311_DB_USER -d $NOLA311_DB_NAME -h $NOLA311_DB_HOST -f views/closed_tickets_stats.sql -q
psql -U $NOLA311_DB_USER -d $NOLA311_DB_NAME -h $NOLA311_DB_HOST -f views/call_records_for_review.sql -q
psql -U $NOLA311_DB_USER -d $NOLA311_DB_NAME -h $NOLA311_DB_HOST -f views/call_records_with_call_for_details.sql -q
