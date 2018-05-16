select
	issue_type,
	issue_description,
	count(*) as num_issues,
	json_agg(id) as row_ids,
	json_agg(ticket_id) as ticket_ids
from nola311.call_records_for_review
group by issue_type, issue_description
order by num_issues desc
;
