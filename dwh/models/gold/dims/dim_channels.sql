{{ config(
    materialized='incremental',
	tags = ['gold']
) }}

SELECT
    channel_id
    , channel_name
    , channel_type
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{ ref('silver_channels') }}