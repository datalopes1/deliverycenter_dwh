{{ config(
    materialized='incremental',
	tags = ['silver']
) }}

WITH clean AS (
	SELECT 
		payment_id::INT
		, payment_order_id::INT
		, payment_method
		, payment_status
		, payment_amount
		, payment_fee
		, ROW_NUMBER() OVER (PARTITION BY payment_id ORDER BY CURRENT_TIMESTAMP DESC) AS row_num
	FROM {{ ref('bronze_payments') }}
	WHERE 
		payment_id IS NOT NULL
		AND payment_order_id IS NOT NULL
)
SELECT
	payment_id
	, payment_order_id
	, payment_amount
	, payment_fee
	, payment_method
	, payment_status
	, CURRENT_TIMESTAMP as ingestion_timestamp
FROM clean
WHERE row_num = 1