{{ config(
    materialized='incremental',
	tags = ['silver']
) }}

WITH clean AS (
    SELECT
        hub_id::INT
        , hub_name
        , hub_city
        , hub_state
        , hub_latitude
        , hub_longitude
        , ROW_NUMBER() OVER (PARTITION BY hub_id ORDER BY CURRENT_TIMESTAMP DESC) AS row_num
    FROM {{ ref('bronze_hubs') }}
    WHERE hub_id IS NOT NULL
)
SELECT
    hub_id
    , hub_name
    , hub_city
    , hub_state
    , hub_latitude
    , hub_longitude
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM clean
WHERE row_num = 1