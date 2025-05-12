{{ config(
    materialized='incremental',
	tags=['gold']
) }}

WITH date_bounds AS (
    SELECT
        DATE_TRUNC('year', MIN(order_date))::DATE AS start_date,
        (DATE_TRUNC('year', MAX(order_date)) + INTERVAL '1 year' - INTERVAL '1 day')::DATE AS end_date
    FROM {{ ref('silver_orders') }}
),
date_dim AS (
    SELECT 
        date::DATE AS date_id,
        EXTRACT(YEAR FROM date)::INT AS year,
        EXTRACT(MONTH FROM date)::INT AS month,
        EXTRACT(DAY FROM date)::INT AS day,
        EXTRACT(DOW FROM date)::INT AS day_of_week,
        EXTRACT(WEEK FROM date)::INT AS week_of_year,
        EXTRACT(QUARTER FROM date)::INT AS quarter,
        TO_CHAR(date, 'Month') AS month_name,
        TO_CHAR(date, 'Mon') AS month_short_name,
        TO_CHAR(date, 'Day') AS day_name,
        CASE WHEN EXTRACT(DOW FROM date) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend
    FROM date_bounds, GENERATE_SERIES(start_date, end_date, INTERVAL '1 day') AS date
)
SELECT * FROM date_dim