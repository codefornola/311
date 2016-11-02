set search_path to 'nola311';

drop view if exists nola311.call_records_for_review;
create view nola311.call_records_for_review as (
  select
    id
    ,ticket_id
    ,issue_type
    ,ticket_created_date_time
    ,ticket_closed_date_time
    ,ticket_status
    ,issue_description
    ,street_address
    ,neighborhood_district
    ,council_district
    ,city
    ,state
    ,zip_code
    ,location
    ,geom
  from nola311.calls
  where
  	state is null
  	and council_district is null
  	and zip_code is null
  	and city is null
  	and neighborhood_district is null
);

grant all on nola311.call_records_for_review to nola311;

-- select * from nola311.call_records_for_review;
