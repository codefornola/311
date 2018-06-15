#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash

export NOLA311_DB_USER=${NOLA311_DB_USER:-nola311}
export NOLA311_DB_PASSWORD=${NOLA311_DB_PASSWORD:-nola311}
export NOLA311_DB_HOST=${NOLA311_DB_HOST:-localhost}
export NOLA311_DB_PORT=${NOLA311_DB_PORT:-5432}
export NOLA311_DB_NAME=${NOLA311_DB_NAME:-nola311}

if [ ! -z $NOLA311_CREATE_USER ]; then
  echo ""
  echo "Creating nola311 user and database"
  echo ""
  createuser nola311
  createdb nola311 -O nola311
else
  echo ""
  echo "Skipping creation of user and database"
  echo ""
fi

echo ""
echo "Downloading the source data"
echo ""
./setup/download_source_data.sh

echo ""
echo "Setup tables and load data into database"
echo ""
./setup/load_data.sh

echo ""
echo "install remaining database objects"
echo ""
./setup/install.sh
