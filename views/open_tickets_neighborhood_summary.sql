set search_path to 'nola311';

drop view if exists nola311.open_tickets_neighborhood_summary;
create view nola311.open_tickets_neighborhood_summary as (
  with
  open_tickets as (
    select
      neighborhood_district,
      issue_type,
      extract(year from ticket_created_date_time) as year_created,
      extract(month from ticket_created_date_time) as month_created,
      justify_interval(age(ticket_created_date_time)) as time_open
    from nola311.calls
    where ticket_status = 'Open'
  ),
  ticket_stats as (
    select
      neighborhood_district,
      issue_type,
      year_created,
      month_created,
      count(*) as number_open
    from open_tickets
    group by neighborhood_district, issue_type, year_created, month_created
  )
  select
    issue_type,
    neighborhood_district,
    count(*) as num_issues
  from ticket_stats
  group by neighborhood_district, issue_type
);

comment on view nola311.open_tickets_neighborhood_summary is 'A summary of the total number of open tickets by issue type for each neighborhood';

grant all on nola311.open_tickets_neighborhood_summary to nola311;


-- select * from nola311.open_tickets_neighborhood_summary;
