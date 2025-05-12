{{ config(
    materialized='view',
	tags = ['bronze']
) }}

SELECT
    channel_id
    , channel_name
    , channel_type
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{source ('db', 'raw_channels') }}