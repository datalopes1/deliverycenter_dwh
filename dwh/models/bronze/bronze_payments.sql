{{ config(
    materialized='view',
	tags = ['bronze']
) }}

SELECT
    payment_id
    , payment_order_id
    , payment_amount
    , payment_fee
    , payment_method
    , payment_status
    , CURRENT_TIMESTAMP AS ingestion_timestamp
FROM {{ source ('db', 'raw_payments') }}