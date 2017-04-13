#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash

echo ""
echo "Creating nola311 user and database"
echo ""
createuser nola311
createdb nola311 -O nola311

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
