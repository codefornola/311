set search_path to 'nola311';

drop view if exists nola311.call_for_details_stats;
create view nola311.call_for_details_stats as (
  with
  call_for_details as (
  	select *
  	from nola311.calls
  	where issue_type = 'General Service Request'
  		and issue_description = '[Call 311 for details]'
  )
  , open_tickets as (
		select
		issue_type,
		issue_description,
      ticket_status,
			extract(year from ticket_created_date_time) as year_created,
			extract(quarter from ticket_created_date_time) as qtr_created,
			justify_interval(age(ticket_created_date_time)) as time_open
		from call_for_details
		where ticket_status = 'Open'
	)
  , closed_tickets as (
		select
		issue_type,
		issue_description,
      ticket_status,
      extract(year from ticket_created_date_time) as year_created,
			extract(quarter from ticket_created_date_time) as qtr_created,
			extract(year from ticket_closed_date_time) as year_closed,
			extract(quarter from ticket_closed_date_time) as qtr_closed,
			justify_interval(ticket_closed_date_time - ticket_created_date_time) as time_to_close
		from call_for_details
		where ticket_status = 'Closed'
	)
  , open_stats as (
    select
		issue_type,
		issue_description,
      ticket_status,
      year_created,
      qtr_created,
      count(*) as number_open,
      justify_interval(min(time_open)) as min_time_open,
      justify_interval(percentile_cont(0.1) within group (order by time_open)) as perc10_time_open,
      justify_interval(percentile_cont(0.25) within group (order by time_open)) as perc25_time_open,
      justify_interval(avg(time_open)) as avg_time_open,
      justify_interval(percentile_cont(0.5) within group (order by time_open)) as median_time_open,
      justify_interval(percentile_cont(0.75) within group (order by time_open)) as perc75_time_open,
      justify_interval(percentile_cont(0.9) within group (order by time_open)) as perc90_time_open,
      justify_interval(max(time_open)) as max_time_open
    from open_tickets
    group by issue_type, issue_description, ticket_status, year_created, qtr_created
  )
  , closed_stats as (
  	select
		issue_type,
		issue_description,
		ticket_status,
		year_created,
		qtr_created,
		count(*) as number_closed,
  		justify_interval(min(time_to_close)) as min_time_to_close,
  		justify_interval(percentile_cont(0.1) within group (order by time_to_close)) as perc10_time_to_close,
  		justify_interval(percentile_cont(0.25) within group (order by time_to_close)) as perc25_time_to_close,
  		justify_interval(avg(time_to_close)) as avg_time_to_close,
  		justify_interval(percentile_cont(0.5) within group (order by time_to_close)) as median_time_to_close,
  		justify_interval(percentile_cont(0.75) within group (order by time_to_close)) as perc75_time_to_close,
  		justify_interval(percentile_cont(0.9) within group (order by time_to_close)) as perc90_time_to_close,
  		justify_interval(max(time_to_close)) as max_time_to_close
  	from closed_tickets
  	group by issue_type, issue_description, ticket_status, year_created, qtr_created
  )
  select
    coalesce(op.year_created, cl.year_created) as year_created,
    coalesce(op.qtr_created, cl.qtr_created) as qtr_created,
    number_open,
    min_time_open,
    perc10_time_open,
    perc25_time_open,
    avg_time_open,
    median_time_open,
    perc75_time_open,
    perc90_time_open,
    max_time_open,
    number_closed,
    min_time_to_close,
    perc10_time_to_close,
    perc25_time_to_close,
    avg_time_to_close,
    median_time_to_close,
    perc75_time_to_close,
    perc90_time_to_close,
    max_time_to_close
  from open_stats op
    full outer join closed_stats cl
    on op.issue_type = cl.issue_type
    and op.issue_description = cl.issue_description
    and op.year_created = cl.year_created
    and op.qtr_created = cl.qtr_created
  order by year_created desc, qtr_created desc
);

grant all on nola311.call_for_details_stats to nola311;

-- select * from nola311.call_for_details_stats;
