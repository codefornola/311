#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash

# create the db
createuser nola311
createdb nola311 -O nola311

# download the source data, setup tables, and import data
./setup/download_source_data.sh

# install remaining database objects
./setup/install.sh
