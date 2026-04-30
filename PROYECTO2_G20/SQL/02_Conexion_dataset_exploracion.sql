-- CONEXION AL DATASET PUBLICO.

-- Dataset utilizado  bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022

SELECT *
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
LIMIT 10;

-- Registros de viajes hay en toda la tabla.
SELECT COUNT(*) AS total_registros
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`;

-- Muestra los nombres de las columnas y su tipo de dato
SELECT column_name, data_type
FROM `bigquery-public-data.new_york_taxi_trips.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'tlc_yellow_trips_2022';

-- Ver esquema de la tabla publica.
-- El orden en que aparece en la tabla y si la columna acepta nulos
SELECT
  column_name,
  data_type,
  is_nullable,
  ordinal_position
FROM `bigquery-public-data.new_york_taxi_trips.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'tlc_yellow_trips_2022'
ORDER BY ordinal_position;

-- Estadísticas generales
-- Rango de fechas (inicio y fin de viajes)
-- Distancias mínimas y máximas
SELECT
  COUNT(*) AS total_rows,
  MIN(pickup_datetime) AS min_pickup_datetime,
  MAX(pickup_datetime) AS max_pickup_datetime,
  MIN(dropoff_datetime) AS min_dropoff_datetime,
  MAX(dropoff_datetime) AS max_dropoff_datetime,
  MIN(trip_distance) AS min_trip_distance,
  MAX(trip_distance) AS max_trip_distance
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`;

-- Análisis por mes
-- Cantidad de viajes
-- Promedio de pago total
-- Promedio de distancia
SELECT
  EXTRACT(MONTH FROM pickup_datetime) AS pickup_month,
  COUNT(*) AS trips,
  ROUND(AVG(total_amount), 2) AS avg_total_amount,
  ROUND(AVG(trip_distance), 2) AS avg_trip_distance
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
GROUP BY pickup_month
ORDER BY pickup_month;

-- Análisis por tipo de pago:
-- Número de viajes por tipo de pago
-- Promedio de propina
-- Promedio de tarifa
SELECT
  payment_type,
  COUNT(*) AS trips,
  ROUND(AVG(tip_amount), 2) AS avg_tip_amount,
  ROUND(AVG(fare_amount), 2) AS avg_fare_amount
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
GROUP BY payment_type
ORDER BY trips DESC;

-- Análisis por hora del día:
-- Cuántos viajes hay por hora
-- Distancia promedio
-- Pago promedio
SELECT
  EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,
  COUNT(*) AS trips,
  ROUND(AVG(trip_distance), 2) AS avg_trip_distance,
  ROUND(AVG(total_amount), 2) AS avg_total_amount
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
GROUP BY pickup_hour
ORDER BY pickup_hour;

-- Rutas más frecuentes:
-- Origen y destino
-- Número de viajes
-- Ingreso total generado

SELECT
  pickup_location_id,
  dropoff_location_id,
  COUNT(*) AS trips,
  ROUND(SUM(total_amount), 2) AS total_revenue
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
GROUP BY pickup_location_id, dropoff_location_id
ORDER BY trips DESC
LIMIT 20;



-- Metricas basicas:
-- total_viajes: número total de viajes
-- promedio_pago: cuánto se paga en promedio por viaje
-- distancia_promedio: qué tan largos son los viajes en promedio
SELECT
  COUNT(*) AS total_viajes,
  AVG(total_amount) AS promedio_pago,
  AVG(trip_distance) AS distancia_promedio
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`;

-- Analisis temporal (por mes)
-- Muestra cómo se distribuyen los viajes a lo largo del año:
-- Agrupa por mes
-- Cuenta cuántos viajes hay en cada mes
-- Sirve para identificar estacionalidad o meses con mayor demanda

SELECT
  EXTRACT(MONTH FROM pickup_datetime) AS mes,
  COUNT(*) AS viajes
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
GROUP BY mes
ORDER BY mes;


-- Distribucion por pasajeros
SELECT passenger_count, COUNT(*) AS total
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
GROUP BY passenger_count
ORDER BY total DESC;


-- Análisis de propinas:
SELECT
  AVG(tip_amount) AS promedio_propina,
  MAX(tip_amount) AS max_propina
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`;