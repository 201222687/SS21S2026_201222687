
 
USE BI_VUELOS;


select * from dim_fecha  ;
select * from dim_aerolinea ; 
select * from dim_aeropuerto ; 
select * from dim_pasajero  ;
select * from dim_pago  ;
select * from dim_cabina  ;
select * from dim_estado  ;
select * from fact_vuelos  ;


SELECT COUNT(*) FROM dim_fecha; -- 855
SELECT COUNT(*) FROM dim_aerolinea; --12
SELECT COUNT(*) FROM dim_aeropuerto;--15
SELECT COUNT(*) FROM dim_pasajero; -- 7170
SELECT COUNT(*) FROM dim_pago;--204
SELECT COUNT(*) FROM dim_cabina;--48
SELECT COUNT(*) FROM dim_estado;--4
SELECT COUNT(*) FROM fact_vuelos;--7066




SELECT a.airline_name,
       AVG(f.delay_min) AS retraso_promedio
FROM fact_vuelos f
JOIN dim_aerolinea a ON f.aerolinea_key = a.aerolinea_key
GROUP BY a.airline_name
ORDER BY retraso_promedio DESC;


SELECT p.nacionalidad,
       COUNT(*) AS total_vuelos
FROM fact_vuelos f
JOIN dim_pasajero p ON f.pasajero_key = p.pasajero_key
GROUP BY p.nacionalidad
ORDER BY total_vuelos DESC;


DELETE FROM fact_vuelos;

DELETE FROM dim_aeropuerto;
DELETE FROM dim_aerolinea;
DELETE FROM dim_fecha;
DELETE FROM dim_cabina;
DELETE FROM dim_estado;
DELETE FROM dim_pasajero;
DELETE FROM dim_pago;


DELETE FROM dim_pago;
DBCC CHECKIDENT ('dim_pago', RESEED, 0);

DELETE FROM dim_cabina;
DBCC CHECKIDENT ('dim_cabina', RESEED, 0);

DELETE FROM dim_estado;
DBCC CHECKIDENT ('dim_estado', RESEED, 0);

DELETE FROM dim_pasajero;
DBCC CHECKIDENT ('dim_pasajero', RESEED, 0);

DELETE FROM dim_aeropuerto;
DBCC CHECKIDENT ('dim_aeropuerto', RESEED, 0);

DELETE FROM dim_aerolinea;
DBCC CHECKIDENT ('dim_aerolinea', RESEED, 0);

DELETE FROM dim_fecha;
DBCC CHECKIDENT ('dim_fecha', RESEED, 0);

DELETE FROM fact_vuelos;
DBCC CHECKIDENT ('fact_vuelos', RESEED, 0);


select * from dim_fecha;
select * from dim_aerolinea;
select * from dim_aeropuerto;
select * from dim_cabina;
select * from dim_estado;
select * from dim_pasajero;
select * from dim_pago;

select * from fact_vuelos;





