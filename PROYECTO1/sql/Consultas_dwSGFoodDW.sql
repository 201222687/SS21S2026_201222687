
SELECT * FROM dim_fecha;
SELECT * FROM dim_cliente;
select * from dim_producto
select * from dim_ubicacion;
select * from dim_canal;
select * from fact_ventas;


DELETE FROM fact_ventas;
DBCC CHECKIDENT ('fact_ventas', RESEED, 0);

DELETE FROM dim_fecha;
DBCC CHECKIDENT ('dim_fecha', RESEED, 0);

DELETE FROM dim_cliente;
DBCC CHECKIDENT ('dim_cliente', RESEED, 0);

DELETE FROM dim_producto;
DBCC CHECKIDENT ('dim_producto', RESEED, 0);

DELETE FROM dim_ubicacion;
DBCC CHECKIDENT ('dim_ubicacion', RESEED, 0);

DELETE FROM dim_canal;
DBCC CHECKIDENT ('dim_canal', RESEED, 0);


SELECT 
       sum(cantidad_vendida) as Cantidad_Vendida,
       AVG(precio_unitario) as Precio_Unitario,
       SUM(descuento) as Descuento 
FROM fact_ventas;




