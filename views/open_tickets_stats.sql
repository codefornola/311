set search_path to 'nola311';

drop view if exists nola311.open_tickets_stats;
create view nola311.open_tickets_stats as (
	with
	open_tickets as (
		select
			issue_type,
			extract(year from ticket_created_date_time) as year_created,
			extract(month from ticket_created_date_time) as month_created,
			justify_interval(age(ticket_created_date_time)) as time_open
		from nola311.calls
		where ticket_status = 'Open'
	)
	select
		issue_type,
		year_created,
		month_created,
		count(*) as number_open,
		justify_interval(min(time_open)) as min_time_open,
		justify_interval(avg(time_open)) as avg_time_open,
		justify_interval(max(time_open)) as max_time_open
	from open_tickets
	group by issue_type, year_created, month_created
);

grant all on nola311.open_tickets_stats to nola311;

-- select * from nola311.open_tickets_stats;
