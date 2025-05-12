{{ config(
    materialized='incremental',
	tags = ['gold']
) }}

SELECT
	d.driver_id
	, d.driver_modal
	, d.driver_type
	, (SUM(de.delivery_distance_meters)/1000)::DECIMAL(10, 2) AS total_delivery_distance_km
	, COUNT(de.delivery_order_id) AS total_deliveries
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{ ref('silver_drivers') }} d
INNER JOIN {{ ref('silver_deliveries') }} de
	ON d.driver_id = de.driver_id
GROUP BY d.driver_id, d.driver_modal, d.driver_type