#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash
set -e

DB_USER=${DB_USER:-postgres}
DB_HOST=${DB_HOST:-localhost}
DB_NAME=${DB_NAME:-nola311}
data_dir=$(pwd)/data
neighborhood_areas_file=$data_dir/neighborhood_areas.geo.json
neighborhood_areas_file=$data_dir/neighborhood_areas.geo.json
call_data_file=$data_dir/nola311_raw.csv

echo ""
echo "Setting up schema to load data into $DB_NAME on $DB_HOST"
echo ""
psql -U $DB_USER -d $DB_NAME -h $DB_HOST -f setup/setup_schema.sql

echo ""
echo "Loading data from $call_data_file"
echo "This may take a minute..."
echo ""
psql -U $DB_USER -d $DB_NAME -h $DB_HOST \
     -c "\copy nola311.calls_tmp(ticket_id,issue_type,ticket_created_date_time,ticket_closed_date_time,ticket_status,issue_description,street_address,neighborhood_district,council_district,city,state,zip_code,location,geom,latitude,longitude) from '$call_data_file' with csv header NULL as '';"

echo ""
echo "Loading data from $neighborhood_areas_file"
echo ""
psql -U $DB_USER -d $DB_NAME -h $DB_HOST \
     -c "\copy nola311.neighborhood_areas_tmp(json_data) from '$neighborhood_areas_file' csv quote e'\x01' delimiter e'\x02';"
