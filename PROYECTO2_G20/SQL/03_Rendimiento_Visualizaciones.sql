
-- Comparación de rendimiento

-- SIN optimización
SELECT COUNT(*)
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE DATE(pickup_datetime) = '2022-06-01';



-- CON optimización
SELECT COUNT(*)
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
WHERE pickup_date = '2022-06-01';

-- Visualizaciones

-- Viajes por mes 

SELECT pickup_month, COUNT(*) AS total_viajes
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_month
ORDER BY pickup_month;

-- Propina promedio por hora 

SELECT pickup_hour, AVG(tip_amount) AS avg_tip
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_hour
ORDER BY pickup_hour;

-- % de propinas altas 

SELECT
  pickup_day_of_week,
  AVG(is_high_tip) * 100 AS porcentaje_propina_alta
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_day_of_week;



