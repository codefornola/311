-- Note that this script must be called with the `--set=` option
-- passed to the `psql` command to set the following variables to
-- indicate the location of the relevant data files:
--   :'call_data_file'
--   :'neighborhood_areas_file'

create schema if not exists nola311;

create table if not exists nola311.calls_tmp (
  id                        serial     primary key,
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

copy nola311.calls_tmp (
  ticket_id,
  issue_type,
  ticket_created_date_time,
  ticket_closed_date_time,
  ticket_status,
  issue_description,
  street_address,
  neighborhood_district,
  council_district,
  city,
  state,
  zip_code,
  location,
  geom,
  latitude,
  longitude
)
from :'call_data_file'
with csv header NULL as '';

create table if not exists nola311.neighborhood_areas_tmp (
  id          serial                      primary key,
  json_data   jsonb,
  created_at  timestamp with time zone    default current_timestamp
);

copy nola311.neighborhood_areas_tmp (
  json_data
)
from :'neighborhood_areas_file'
csv quote e'\x01' delimiter e'\x02';

grant all on schema nola311 to nola311;
grant all on all tables in schema nola311 to nola311;

alter role nola311 set search_path to nola311, public;
create extension if not exists postgis;
