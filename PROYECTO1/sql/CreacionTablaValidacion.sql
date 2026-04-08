CREATE TABLE auditoria_validacion (
    cliente_id VARCHAR(20),
    producto_sku VARCHAR(30),
    fecha DATE,
    cantidad_excel INT,
    cantidad_dw INT,
    total_excel DECIMAL(18,2),
    total_dw DECIMAL(18,2),
    tipo_resultado VARCHAR(20)
);

-- Validar cantidad de registros
SELECT COUNT(*) AS total_registros
FROM auditoria_validacion;
-- Revisar estructura real
SELECT TOP (10) *
FROM auditoria_validacion;
-- Mostrando todos los registros.
SELECT  *
FROM auditoria_validacion;

-- CONSULTA DE VALIDACIÓN

SELECT tipo_resultado, COUNT(*) 
FROM auditoria_validacion
GROUP BY tipo_resultado;


-- 2. PORCENTAJE DE CALIDAD

SELECT 
tipo_resultado,
COUNT(*) * 100.0 / (SELECT COUNT(*) FROM auditoria_validacion) AS porcentaje
FROM auditoria_validacion
GROUP BY tipo_resultado;

-- 3. TOP ERRORES
SELECT TOP 10 *
FROM auditoria_validacion
WHERE tipo_resultado = 'DIFERENCIAS';


-- Elimnar todos losregistro de la tabla.
-- comenzar a ingresar datos desde un contador reiniciado.
TRUNCATE TABLE  auditoria_validacion;
