
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

-- Qué hace:

-- Convierte la fecha y hora en solo fecha (pickup_date)
-- Cuenta cuántos viajes hubo por día
-- Suma el dinero total generado por día

-- Para qué sirve:

-- Analizar la demanda diaria y los ingresos en un periodo específico (julio a septiembre 2022)

-- Importante:

-- No está optimizada → escanea más datos y puede ser más lenta/costosa

SELECT
  DATE(pickup_datetime) AS pickup_date,
  COUNT(*) AS trips,
  ROUND(SUM(total_amount), 2) AS revenue
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE DATE(pickup_datetime) BETWEEN '2022-07-01' AND '2022-09-30'
GROUP BY pickup_date
ORDER BY pickup_date;

-- Consulta sobre tabla optimizada

-- Qué hace:

-- Exactamente lo mismo que la anterior

-- Diferencia clave:

-- Usa una tabla particionada por fecha
-- Solo escanea los datos necesarios

--Para qué sirve:

-- Obtener el mismo análisis pero de forma más rápida y barata

SELECT
  pickup_date,
  COUNT(*) AS trips,
  ROUND(SUM(total_amount), 2) AS revenue
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
WHERE pickup_date BETWEEN '2022-07-01' AND '2022-09-30'
GROUP BY pickup_date
ORDER BY pickup_date;


-- Visualizaciones

-- Viajes por mes 

-- Descripción:
-- Cuenta la cantidad de viajes en cada mes del año.

-- ¿Para qué sirve?
-- Permite visualizar la demanda mensual y detectar patrones estacionales (meses con más o menos actividad). 

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

-- % de propinas altas 

-- Descripción:
-- Calcula el porcentaje de viajes con propinas altas (≥20%) por día de la semana.

-- ¿Cómo funciona?

-- is_high_tip es 1 (sí) o 0 (no)
-- El promedio de esa columna equivale al porcentaje
-- Se multiplica por 100 para expresarlo en %

-- ¿Para qué sirve?
-- Permite ver qué días los clientes son más generosos con las propinas.

SELECT
  pickup_day_of_week,
  AVG(is_high_tip) * 100 AS porcentaje_propina_alta
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_day_of_week;


-- Top rutas por ingreso

-- Qué hace:

-- Analiza combinaciones origen → destino
-- Calcula:
-- Número de viajes
-- Ingreso total
-- Duración promedio

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

-- Para qué sirve:

-- Entender el patrón semanal
-- Detectar:
-- Días con más actividad
-- Días con viajes más largos o mejores propinas

SELECT
  pickup_day_of_week,
  COUNT(*) AS trips,
  ROUND(AVG(trip_distance), 2) AS avg_trip_distance,
  ROUND(AVG(tip_amount), 2) AS avg_tip_amount
FROM `Proyecto2_G20.taxi_trips_2022_optimized`
GROUP BY pickup_day_of_week
ORDER BY pickup_day_of_week;




