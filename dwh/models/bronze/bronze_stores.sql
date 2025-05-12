{{ config(
    materialized='view',
	tags = ['bronze']
) }}

SELECT
    store_id
    , hub_id
    , store_name
    , store_segment
    , store_plan_price
    , store_latitude
    , store_longitude
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{ source ('db', 'raw_stores') }}