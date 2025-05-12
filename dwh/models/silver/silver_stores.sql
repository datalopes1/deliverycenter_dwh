{{ config(
    materialized='incremental',
	tags = ['silver']
) }}

WITH clean AS (
    SELECT
        store_id::INT
        , hub_id::INT
        , store_name
        , store_segment
        , store_plan_price
        , store_latitude
        , store_longitude
        , ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY CURRENT_TIMESTAMP DESC) AS row_num
    FROM {{ ref('bronze_stores') }}
    WHERE store_id IS NOT NULL
)
SELECT
    store_id
    , hub_id
    , store_name
    , store_segment
    , store_plan_price
    , store_latitude
    , store_longitude
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM clean
WHERE store_id IS NOT NULL