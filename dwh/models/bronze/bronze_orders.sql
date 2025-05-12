{{ config(
    materialized='view',
	tags = ['bronze']
) }}

SELECT
    order_id
    , store_id
    , channel_id
    , payment_order_id
    , delivery_order_id
    , order_status
    , order_amount
    , order_delivery_fee
    , order_delivery_cost
    , order_created_hour
    , order_created_minute
    , order_created_day
    , order_created_month
    , order_created_year
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
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{ source ('db', 'raw_orders') }}