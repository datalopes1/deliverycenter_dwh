{{ config(
    materialized='incremental',
	tags = ['silver']
) }}


WITH clean AS (
	SELECT 
		delivery_id::INT
		, delivery_order_id::INT
		, driver_id::INT
		, delivery_status
		, delivery_distance_meters
		, ROW_NUMBER() OVER (PARTITION BY delivery_id ORDER BY CURRENT_TIMESTAMP DESC) AS row_num
	FROM {{ ref ('bronze_deliveries') }} 
	WHERE 
		delivery_id IS NOT NULL
		AND delivery_order_id IS NOT NULL
		AND driver_id IS NOT NULL

)
SELECT
	delivery_id
	, delivery_order_id
	, driver_id
	, delivery_status
	, delivery_distance_meters
	, CURRENT_TIMESTAMP AS ingestion_timestamp
FROM clean
WHERE row_num = 1