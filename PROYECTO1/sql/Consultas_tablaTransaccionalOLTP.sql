-- Validar cantidad de registros
SELECT COUNT(*) AS total_registros
FROM TransaccionesVenta;
-- Revisar estructura real
SELECT TOP (10) *
FROM TransaccionesVenta;

SELECT  *
FROM TransaccionesVenta;


-- Revisar rango de fechas
SELECT 
    MIN(FechaTransaccion) AS FechaMinima,
    MAX(FechaTransaccion) AS FechaMaxima
FROM dbo.TransaccionesVenta;

-- Validar posibles dimensiones
-- Clientes únicos
SELECT COUNT(DISTINCT ClienteId) AS TotalClientes
FROM dbo.TransaccionesVenta;
-- Productos únicos
SELECT COUNT(DISTINCT ProductoSKU) AS TotalProductos
FROM dbo.TransaccionesVenta;
-- Categorías
SELECT DISTINCT Categoria
FROM dbo.TransaccionesVenta;
-- Canales de venta
SELECT DISTINCT CanalVenta
FROM dbo.TransaccionesVenta;
