create schema if not exists nola311;

create table if not exists nola311.calls_tmp (
  id serial                 primary key,
  ticket_id                 numeric,
  issue_type                text,
  ticket_created_date_time  text,
  ticket_closed_date_time   text,
  ticket_status             text,
  issue_description         text,
  street_address            text,
  neighborhood_district     text,
  council_district          text,
  city                      text,
  state                     text,
  zip_code                  numeric,
  location                  text,
  geom                      text,
  latitude                  numeric,
  longitude                 numeric
);

copy nola311.calls_tmp (ticket_id,issue_type,ticket_created_date_time,ticket_closed_date_time,ticket_status,issue_description,street_address,neighborhood_district,council_district,city,state,zip_code,location,geom,latitude,longitude)
from program '/usr/local/bin/wget -q -O - "$@" "https://data.nola.gov/api/views/3iz8-nghx/rows.csv?accessType=DOWNLOAD"'
with csv header NULL as '';
