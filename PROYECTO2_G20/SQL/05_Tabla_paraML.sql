-- Feature engineering

CREATE OR REPLACE TABLE `Proyecto2_G20.ml_features_taxi_2022`
PARTITION BY pickup_date
CLUSTER BY split_col, payment_type, pickup_location_id, dropoff_location_id
AS
SELECT
  -- Partición
  pickup_date,

  -- Features principales (INPUTS)
  passenger_count,
  trip_distance,
  fare_amount,
  trip_duration_minutes,
  pickup_hour,
  pickup_day_of_week,
  pickup_month,
  payment_type,
  pickup_location_id,
  dropoff_location_id,

  -- Variables derivadas
  SAFE_DIVIDE(tip_amount, NULLIF(fare_amount, 0)) AS tip_pct,

  -- Targets
  is_high_tip,     -- clasificación
  tip_amount,      -- regresión

  -- Split temporal (evita data leakage)
  CASE
    WHEN pickup_date < '2022-10-01' THEN 'TRAIN'
    WHEN pickup_date < '2022-12-01' THEN 'EVAL'
    ELSE 'PREDICT'
  END AS split_col

FROM `Proyecto2_G20.taxi_trips_2022_optimized`
WHERE
  pickup_date IS NOT NULL
  AND trip_duration_minutes BETWEEN 1 AND 180
  AND trip_distance BETWEEN 0.1 AND 100
  AND fare_amount BETWEEN 1 AND 300
  AND tip_amount BETWEEN 0 AND 200
  AND passenger_count BETWEEN 1 AND 6;


--  Cuenta cuántos datos hay en cada grupo (TRAIN, EVAL, PREDICT) para validar que el split del modelo está bien hecho.

SELECT
  split_col,
  COUNT(*) AS rows_in_split
FROM `Proyecto2_G20.ml_features_taxi_2022`
GROUP BY split_col
ORDER BY split_col;
