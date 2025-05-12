{{ config(
    materialized='incremental',
	tags = ['silver']
) }}

WITH clean AS (
    SELECT
        channel_id::INT
        , channel_name
        , channel_type
        , ROW_NUMBER() OVER (PARTITION BY channel_id ORDER BY CURRENT_TIMESTAMP DESC) AS row_num
    FROM {{ ref ('bronze_channels') }} 
    WHERE channel_id IS NOT NULL
)

SELECT
    channel_id
    , channel_name
    , channel_type
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM clean
WHERE row_num = 1