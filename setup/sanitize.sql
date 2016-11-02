alter role nola311 set search_path to nola311, public;
create extension if not exists postgis;

create table nola311.calls as (
  select
    id,
    ticket_id,
    issue_type,
    to_timestamp(ticket_created_date_time,'MM/DD/YYYY HH12:MI:SS AM') as ticket_created_date_time,
    to_timestamp(ticket_closed_date_time,'MM/DD/YYYY HH12:MI:SS AM') as ticket_closed_date_time,
    ticket_status,
    issue_description,
    street_address,
    neighborhood_district,
    council_district,
    city,
    state,
    zip_code,
    location,
    st_pointfromtext('POINT(' || longitude || ' ' || latitude || ')', 4326) as geom
  from nola311.calls_tmp
);

comment on table nola311.calls is 'This dataset represents calls to the City of New Orleans'' 311 Call Center';

grant all on schema nola311 to nola311;
grant all on all tables in schema nola311 to nola311;
