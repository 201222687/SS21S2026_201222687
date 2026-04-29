-- CONEXION AL DATASET PUBLICO.
-- Dataset utilizado  bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022

-- Exploracion de datos.
SELECT *
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
LIMIT 10;
-- Conteo de registros
SELECT COUNT(*) AS total_registros
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`;
-- Revisar estructura
SELECT column_name, data_type
FROM `bigquery-public-data.new_york_taxi_trips.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'tlc_yellow_trips_2022';
