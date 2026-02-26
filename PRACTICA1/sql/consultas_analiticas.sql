
USE BI_VUELOS;

-- 1 Indicadores operativos

-- 1.1 Total de vuelos 

SELECT COUNT(*) AS total_vuelos
FROM fact_vuelos;

-- 1.2 vuelos por año 

SELECT d.anio,
       COUNT(*) AS total_vuelos
FROM fact_vuelos f
JOIN dim_fecha d ON f.fecha_salida_key = d.fecha_key
GROUP BY d.anio
ORDER BY d.anio;

-- 1.3 vuelos por mes 

SELECT d.anio,
       d.nombre_mes,
       COUNT(*) AS total_vuelos
FROM fact_vuelos f
JOIN dim_fecha d ON f.fecha_salida_key = d.fecha_key
GROUP BY d.anio, d.mes, d.nombre_mes
ORDER BY d.anio, d.mes;

-- 1.4 Aerolineas con mas vuelos

SELECT a.airline_name,
       COUNT(*) AS total_vuelos
FROM fact_vuelos f
JOIN dim_aerolinea a ON f.aerolinea_key = a.aerolinea_key
GROUP BY a.airline_name
ORDER BY total_vuelos DESC;

-- 1.5 Destinos mas frecuentes.

SELECT ap.codigo_aeropuerto,
       COUNT(*) AS total_llegadas
FROM fact_vuelos f
JOIN dim_aeropuerto ap ON f.destino_key = ap.aeropuerto_key
GROUP BY ap.codigo_aeropuerto
ORDER BY total_llegadas DESC;

-- /*/*/*/*/*/*/*/*/*/*/*/*/*/

-- 2 Indicadores de clientes

-- 2.1 Distribucion por genero.

SELECT p.genero,
       COUNT(*) AS total_vuelos
FROM fact_vuelos f
JOIN dim_pasajero p ON f.pasajero_key = p.pasajero_key
GROUP BY p.genero;

-- 2.2 Distribucion por rango de edad

SELECT p.rango_edad,
       COUNT(*) AS total_vuelos
FROM fact_vuelos f
JOIN dim_pasajero p ON f.pasajero_key = p.pasajero_key
GROUP BY p.rango_edad
ORDER BY total_vuelos DESC;

-- */*/**/*/*/*/*/*/*/*/*/*/*/*/*/**/

-- 3 Indicadores Financieros

-- 3.1 Ingresos totales.

SELECT SUM(ticket_price_usd) AS ingresos_totales
FROM fact_vuelos;

-- 3.2 Ingresos por aerolinea

SELECT a.airline_name,
       SUM(f.ticket_price_usd) AS ingresos
FROM fact_vuelos f
JOIN dim_aerolinea a ON f.aerolinea_key = a.aerolinea_key
GROUP BY a.airline_name
ORDER BY ingresos DESC;

-- 3.3 Ingresos por metodo de pago

SELECT p.metodo_pago,
       SUM(f.ticket_price_usd) AS ingresos
FROM fact_vuelos f
JOIN dim_pago p ON f.pago_key = p.pago_key
GROUP BY p.metodo_pago
ORDER BY ingresos DESC;

-- */**/*/*/*/*/*/*/*/*/*/*/*/*/*

-- 4 Indicadores operativos avanzados.

-- Promedio de retraso por aerolinea

SELECT a.airline_name,
       AVG(f.delay_min) AS retraso_promedio
FROM fact_vuelos f
JOIN dim_aerolinea a ON f.aerolinea_key = a.aerolinea_key
GROUP BY a.airline_name
ORDER BY retraso_promedio DESC;

-- Promedio de equipaje por vuelo

SELECT AVG(bags_total) AS promedio_bolsas
FROM fact_vuelos;

-- Estados de vuelo

SELECT e.estado_vuelo,
       COUNT(*) AS total
FROM fact_vuelos f
JOIN dim_estado e ON f.estado_key = e.estado_key
GROUP BY e.estado_vuelo
ORDER BY total DESC;


-- 5 consulta ejecutiva

-- Resumen general por año:

SELECT 
    d.anio,
    COUNT(*) AS total_vuelos,
    SUM(f.ticket_price_usd) AS ingresos_totales,
    AVG(f.delay_min) AS retraso_promedio
FROM fact_vuelos f
JOIN dim_fecha d ON f.fecha_salida_key = d.fecha_key
GROUP BY d.anio
ORDER BY d.anio;




