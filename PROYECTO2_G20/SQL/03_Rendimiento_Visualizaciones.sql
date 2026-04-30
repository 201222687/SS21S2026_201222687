
-- Comparación de rendimiento

-- SIN optimización
SELECT COUNT(*)
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE DATE(pickup_datetime) = '2022-06-01';



-- CON optimización
SELECT COUNT(*)
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
WHERE pickup_date = '2022-06-01';

-- Consulta base sin optimización
-- Convierte la fecha y hora en solo fecha (pickup_date)
-- Cuenta cuántos viajes hubo por día
-- Suma el dinero total generado por día

SELECT
  DATE(pickup_datetime) AS pickup_date,
  COUNT(*) AS trips,
  ROUND(SUM(total_amount), 2) AS revenue
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE DATE(pickup_datetime) BETWEEN '2022-07-01' AND '2022-09-30'
GROUP BY pickup_date
ORDER BY pickup_date;

-- Consulta sobre tabla optimizada
-- Tabla particionada por fecha
-- Solo escanea los datos necesarios

SELECT
  pickup_date,
  COUNT(*) AS trips,
  ROUND(SUM(total_amount), 2) AS revenue
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
WHERE pickup_date BETWEEN '2022-07-01' AND '2022-09-30'
GROUP BY pickup_date
ORDER BY pickup_date;


-- Visualizaciones
-- Viajes por mes del año
SELECT pickup_month, COUNT(*) AS total_viajes
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_month
ORDER BY pickup_month;


-- Propina promedio por hora 

-- Descripción:
-- Calcula el promedio de propinas para cada hora del día (0–23).

-- ¿Para qué sirve?
-- Ayuda a identificar en qué horas los clientes dejan mejores propinas.

SELECT pickup_hour, AVG(tip_amount) AS avg_tip
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_hour
ORDER BY pickup_hour;


-- Porcentaje de viajes con propinas altas (≥20%) por día de la semana.
-- is_high_tip : 1 (sí) o 0 (no)

SELECT
  pickup_day_of_week,
  AVG(is_high_tip) * 100 AS porcentaje_propina_alta
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_day_of_week;


-- Top rutas por ingreso

-- Qué hace:
-- Analiza combinaciones origen → destino

-- Para qué sirve:
-- Identificar las rutas más rentables
-- Ver cuáles trayectos generan más dinero

SELECT
  pickup_location_id,
  dropoff_location_id,
  COUNT(*) AS trips,
  ROUND(SUM(total_amount), 2) AS total_revenue,
  ROUND(AVG(trip_duration_minutes), 2) AS avg_trip_duration_minutes
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_location_id, dropoff_location_id
ORDER BY total_revenue DESC
LIMIT 25;


-- Comportamiento semanal
-- Qué hace:

-- Agrupa los viajes por día de la semana (1–7 o según tu definición)
-- Calcula:
-- Cantidad de viajes
-- Distancia promedio
-- Propina promedio

-- Sirve para:
-- Entender el patrón semanal

SELECT
  pickup_day_of_week,
  COUNT(*) AS trips,
  ROUND(AVG(trip_distance), 2) AS avg_trip_distance,
  ROUND(AVG(tip_amount), 2) AS avg_tip_amount
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_day_of_week
ORDER BY pickup_day_of_week;