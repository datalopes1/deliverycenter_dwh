{{ config(
    materialized='view',
	tags = ['bronze']
) }}

SELECT
    delivery_id
    , delivery_order_id
    , driver_id
    , delivery_distance_meters
    , delivery_status
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{ source ('db', 'raw_deliveries') }}