#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash

# Utility function to get expanded path from a relative one
function abs_path {
  (cd "$(dirname '$1')" &>/dev/null && printf "%s/%s" "$PWD" "${1##*/}")
}

# Create data folder if it doesn't exist
current_dir=$(pwd)
script_dir=$(dirname $0)
if [ ! -d "$script_dir/../data" ]; then
  echo "No data directory -- creating one at $(abs_path $script_dir/../data)"
  mkdir "$(abs_path $script_dir/../data)"
fi
data_dir="$(abs_path $script_dir/../data)"

# Tabular data: 311 data file (CSV)
call_data_file="$data_dir/nola311_raw.csv"
if [ ! -f "$call_data_file" ]; then
  /usr/local/bin/wget --show-progress -O "$call_data_file" "https://data.nola.gov/api/views/3iz8-nghx/rows.csv?accessType=DOWNLOAD"
else
  echo "File $(abs_path "$call_data_file") already exists...  skipping download."
fi

# Geographic data: Neighborhood Statistical Areas (GeoJSON)
neighborhood_areas_file="$data_dir/neighborhood_areas.geo.json"
if [ ! -f "$neighborhood_areas_file" ]; then
  /usr/local/bin/wget --show-progress -O "$neighborhood_areas_file" "http://portal.nolagis.opendata.arcgis.com/datasets/e7daa4c977d14e1b9e2fa4d7aff81e59_0.geojson"
else
  echo "File $(abs_path "$neighborhood_areas_file") already exists...  skipping download."
fi

echo ""
echo "Data downloaded to $data_dir."
echo ""
echo "Setting up schemas and importing data"

# Call script to create schemas and import data, passing file locations
psql --set=call_data_file="$call_data_file" \
     --set=neighborhood_areas_file="$neighborhood_areas_file" \
     -U postgres -d nola311 -f setup/schema_and_csv_import.sql
