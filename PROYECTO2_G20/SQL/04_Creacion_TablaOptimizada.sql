-- 1. Crear el dataset
CREATE SCHEMA IF NOT EXISTS `taxi_dataset`;

-- 2. Tabla optimizada con PARTITION BY y CLUSTER BY
CREATE OR REPLACE TABLE `taxi_dataset.taxi_trips_2022_optimized`
PARTITION BY pickup_date
CLUSTER BY vendor_id, pickup_location_id, payment_type
AS
WITH source_data AS (
  SELECT
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    DATE(pickup_datetime) AS pickup_date,
    passenger_count,
    trip_distance,
    rate_code,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    imp_surcharge,
    airport_fee,
    total_amount
  FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
  WHERE DATE(pickup_datetime) BETWEEN '2022-01-01' AND '2022-12-31'
)
SELECT
  vendor_id,
  pickup_datetime,
  dropoff_datetime,
  pickup_date,
  passenger_count,
  trip_distance,
  rate_code,
  store_and_fwd_flag,
  pickup_location_id,
  dropoff_location_id,
  payment_type,
  fare_amount,
  extra,
  mta_tax,
  tip_amount,
  tolls_amount,
  imp_surcharge,
  airport_fee,
  total_amount,
  TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) AS trip_duration_minutes,
  EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS pickup_day_of_week,
  EXTRACT(MONTH FROM pickup_datetime) AS pickup_month,
  -- Propina alta si es >= 20% (clásico)
  IF(SAFE_DIVIDE(tip_amount, NULLIF(fare_amount, 0)) >= 0.20, 1, 0) AS is_high_tip
FROM source_data
WHERE pickup_datetime IS NOT NULL
  AND dropoff_datetime IS NOT NULL
  AND dropoff_datetime >= pickup_datetime
  AND passenger_count BETWEEN 1 AND 6
  AND trip_distance > 0 AND trip_distance <= 100
  AND fare_amount > 0 AND fare_amount <= 500
  AND total_amount > 0;