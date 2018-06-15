#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash
set -e

data_dir=$(pwd)/data
neighborhood_areas_file=$data_dir/neighborhood_areas.geo.json
neighborhood_areas_file=$data_dir/neighborhood_areas.geo.json
call_data_file=$data_dir/nola311_raw.csv

echo ""
echo "Setting up schema to load data into $NOLA311_DB_NAME on $NOLA311_DB_HOST:$NOLA311_DB_PORT"
echo ""
psql -U $NOLA311_DB_USER -d $NOLA311_DB_NAME -h $NOLA311_DB_HOST -p $NOLA311_DB_PORT -f setup/setup_schema.sql

echo ""
echo "Loading data from $call_data_file"
echo "This may take a minute..."
echo ""
psql -U $NOLA311_DB_USER -d $NOLA311_DB_NAME -h $NOLA311_DB_HOST -p $NOLA311_DB_PORT \
     -c "\copy nola311.calls_tmp(ticket_id,issue_type,ticket_created_date_time,ticket_closed_date_time,ticket_status,issue_description,street_address,neighborhood_district,council_district,city,state,zip_code,location,geom,latitude,longitude) from '$call_data_file' with csv header NULL as '';"

echo ""
echo "Loading data from $neighborhood_areas_file"
echo ""
psql -U $NOLA311_DB_USER -d $NOLA311_DB_NAME -h $NOLA311_DB_HOST -p $NOLA311_DB_PORT \
     -c "\copy nola311.neighborhood_areas_tmp(json_data) from '$neighborhood_areas_file' csv quote e'\x01' delimiter e'\x02';"
