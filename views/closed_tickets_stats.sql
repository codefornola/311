set search_path to 'nola311';

drop view if exists nola311.closed_tickets_stats;
create view nola311.closed_tickets_stats as (
	with
	closed_tickets as (
		select
			issue_type,
			extract(year from ticket_created_date_time) as year_created,
			extract(month from ticket_created_date_time) as month_created,
			extract(year from ticket_closed_date_time) as year_closed,
			extract(month from ticket_closed_date_time) as month_closed,
			justify_interval(ticket_closed_date_time - ticket_created_date_time) as time_to_close
		from nola311.calls
		where ticket_status = 'Closed'
	)
	select
		issue_type,
		year_created,
		month_created,
		count(*) as number_closed,
		justify_interval(min(time_to_close)) as min_time_to_close,
		justify_interval(avg(time_to_close)) as avg_time_to_close,
		justify_interval(max(time_to_close)) as max_time_to_close
	from closed_tickets
	group by issue_type, year_created, month_created
);

select * from nola311.closed_tickets_stats;
