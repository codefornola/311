drop table if exists nola311.neighborhoods cascade;
create table nola311.neighborhoods (
  id serial primary key,
  source_row_id bigint,
  object_id bigint,
  gnocdc_label text,
  shape_area numeric,
  shape_length numeric,
  geojson_feature jsonb
);

insert into nola311.neighborhoods (source_row_id, object_id, gnocdc_label,
                                   shape_area, shape_length, geojson_feature)
with json_geo_records as (
	select id as source_row_id, jsonb_array_elements(json_data->'features') as feature
	from nola311.neighborhood_areas_tmp
)
select
	t.source_row_id as source_row_id,
	((t.feature)->'properties'->>'OBJECTID')::bigint as object_id,
	(t.feature)->'properties'->>'GNOCDC_LAB' as gnocdc_label,
	((t.feature)->'properties'->>'Shape_Area')::numeric as shape_area,
	((t.feature)->'properties'->>'Shape_Length')::numeric as shape_length,
	(t.feature) as geojson_feature
from json_geo_records t
;

comment on table nola311.neighborhoods is 'This dataset contains geojson features and related metadata for New Orleans'' neighborhoods per GNO CDC.';

grant all on schema nola311 to nola311;
grant all on all tables in schema nola311 to nola311;
grant all on all sequences in schema nola311 to nola311;
