{{ config(
    materialized='incremental',
	tags = ['gold']
) }}

SELECT
    s.store_id
    , s.hub_id
    , s.store_name
    , s.store_segment
    , s.store_plan_price
    , (SUM(o.order_amount))::DECIMAL(10, 2) AS store_gross_margin
    , COUNT(o.delivery_order_id) AS total_orders
    , s.store_latitude
    , s.store_longitude
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{ ref('silver_stores') }} s
INNER JOIN {{ ref('silver_orders') }} o ON s.store_id = o.store_id
GROUP BY s.store_id, s.hub_id, s.store_name, s.store_segment, s.store_plan_price, s.store_latitude, s.store_longitude