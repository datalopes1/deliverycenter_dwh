{{ config(
    materialized='table',
	tags = ['gold']
) }}

WITH fct_orders AS (SELECT 
	o.order_id
	, o.store_id
	, o.channel_id
	, d.delivery_id
	, d.driver_id
	, o.delivery_order_id
	, o.order_date
	, o.order_status
	, COALESCE(o.order_metric_cycle_time, 0) AS order_cycle_time
	, DATE_PART('Minute', o.order_moment_finished - o.order_moment_collected) AS delivery_lead_time
	, o.order_amount
	, o.order_delivery_fee
	, o.order_delivery_cost
	, d.delivery_distance_meters
	, ROW_NUMBER() OVER (PARTITION BY o.delivery_order_id ORDER BY CURRENT_TIMESTAMP DESC) AS row_num
FROM {{ ref('silver_orders') }} o
INNER JOIN {{ ref('silver_deliveries') }} d
	ON o.delivery_order_id = d.delivery_order_id)
SELECT 
	order_id
	, store_id
	, channel_id
	, delivery_id 
	, driver_id
	, delivery_order_id
	, order_date
	, order_status
	, order_cycle_time
	, delivery_lead_time
	, order_amount
	, order_delivery_fee
	, order_delivery_cost 
	, delivery_distance_meters
	, CURRENT_TIMESTAMP AS ingestion_timestamp
FROM fct_orders 
WHERE row_num = 1 