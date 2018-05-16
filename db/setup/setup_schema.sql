create schema if not exists nola311;

drop table if exists nola311.calls_tmp cascade;
create table nola311.calls_tmp (
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

drop table if exists nola311.neighborhood_areas_tmp cascade;
create table nola311.neighborhood_areas_tmp (
  id          serial                      primary key,
  json_data   jsonb,
  created_at  timestamp with time zone    default current_timestamp
);

grant all on schema nola311 to nola311;
grant all on all tables in schema nola311 to nola311;
grant all on all sequences in schema nola311 to nola311;

alter role nola311 set search_path to nola311, public;
create extension if not exists postgis;
