{{ config(
    materialized='incremental',
    pre_hook="SET LOCAL statement_timeout = '300s'; SET LOCAL DateStyle TO 'US';",
	tags=['silver']
) }}

WITH clean AS (
	SELECT
		order_id::INT
		, store_id::INT
		, channel_id::INT
		, payment_order_id::INT
		, delivery_order_id::INT
		, order_status
		, DATE(order_moment_created) AS order_date
		, order_moment_created::TIMESTAMP AS order_moment_created
		, order_moment_accepted::TIMESTAMP AS order_moment_accepted
		, order_moment_ready::TIMESTAMP AS order_moment_ready
		, order_moment_collected::TIMESTAMP AS order_moment_collected
		, order_moment_in_expedition::TIMESTAMP AS order_moment_in_expedition
		, order_moment_delivering::TIMESTAMP AS order_moment_delivering
		, order_moment_delivered::TIMESTAMP AS order_moment_delivered
		, order_moment_finished::TIMESTAMP AS order_moment_finished
		, order_metric_collected_time
		, order_metric_paused_time
		, order_metric_production_time
		, order_metric_walking_time
		, order_metric_expediton_speed_time
		, order_metric_transit_time 
		, order_metric_cycle_time
		, COALESCE(order_amount, 0) AS order_amount
		, COALESCE(order_delivery_fee, 0) AS order_delivery_fee
		, COALESCE(order_delivery_cost, 0) AS order_delivery_cost
		, ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY CURRENT_TIMESTAMP DESC) AS row_num
	FROM {{ ref('bronze_orders') }}
	WHERE 
		order_id IS NOT NULL
		AND store_id IS NOT NULL
		AND channel_id IS NOT NULL
		AND payment_order_id IS NOT NULL
		AND delivery_order_id IS NOT NULL
)
SELECT
	order_id
	, store_id
	, channel_id
	, payment_order_id
	, delivery_order_id
	, order_status
	, order_date
	, order_moment_created
	, order_moment_accepted
	, order_moment_ready
	, order_moment_collected
	, order_moment_in_expedition
	, order_moment_delivering
	, order_moment_delivered
	, order_moment_finished
	, order_metric_collected_time
	, order_metric_paused_time
	, order_metric_production_time
	, order_metric_walking_time
	, order_metric_expediton_speed_time
	, order_metric_transit_time
	, order_metric_cycle_time
	, order_amount
	, order_delivery_fee
	, order_delivery_cost
	, CURRENT_TIMESTAMP AS ingestion_timestamp
FROM clean
WHERE row_num = 1