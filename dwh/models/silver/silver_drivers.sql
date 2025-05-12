{{ config(
    materialized='incremental',
	tags = ['silver']
) }}

WITH clean AS (
    SELECT
        driver_id::INT
        , driver_modal
        , driver_type
        , ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY CURRENT_TIMESTAMP DESC) AS row_num
    FROM {{ ref('bronze_drivers') }}
    WHERE driver_id IS NOT NULL
)

SELECT
    driver_id
    , driver_modal
    , driver_type
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM clean
WHERE row_num = 1