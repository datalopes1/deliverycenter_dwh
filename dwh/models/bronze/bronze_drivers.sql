{{ config(
    materialized='view',
	tags = ['bronze']
) }}

SELECT
    driver_id
    , driver_modal
    , driver_type
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{source ('db', 'raw_drivers') }}