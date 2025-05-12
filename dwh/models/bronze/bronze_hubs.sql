{{ config(
    materialized='view',
	tags = ['bronze']
) }}

SELECT
    hub_id
    , hub_name
    , hub_city
    , hub_state
    , hub_latitude
    , hub_longitude
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{source ('db', 'raw_hubs') }}