
-- 1 Dimension fecha

CREATE TABLE dim_fecha (
    fecha_key INT PRIMARY KEY, -- surrogate _key
    fecha DATE NOT NULL,        
    anio INT,
    mes INT,
    nombre_mes VARCHAR(20),
    trimestre INT,
    dia INT
);

-- 2 Dimension cliente

CREATE TABLE dim_cliente (
    cliente_key INT IDENTITY(1,1) PRIMARY KEY, -- surrogate _key
    cliente_id VARCHAR(20),                    -- clave natural nk()
    cliente_nombre VARCHAR(120),
    segmento_cliente VARCHAR(40)
);

-- 3 Dimension producto

CREATE TABLE dim_producto (
    producto_key INT IDENTITY(1,1) PRIMARY KEY, -- surrogate _key
    producto_sku VARCHAR(30),                   -- clave natural nk()
    producto_nombre VARCHAR(120),
    marca VARCHAR(60),
    categoria VARCHAR(60),
    subcategoria VARCHAR(60),
    fabricante VARCHAR(40)
);

-- 4 Dimension Ubicacion

CREATE TABLE dim_ubicacion (
    ubicacion_key INT IDENTITY(1,1) PRIMARY KEY, -- surrogate _key
    departamento VARCHAR(60), 
    municipio VARCHAR(60)
);

-- 5 dimension canal

CREATE TABLE dim_canal (
    canal_key INT IDENTITY(1,1) PRIMARY KEY, -- surrogate _key
    canal_venta VARCHAR(30)
);

-- 6 Tabla de hechos.

CREATE TABLE fact_ventas (
    venta_key INT IDENTITY(1,1) PRIMARY KEY, -- surrogate _key

    fecha_key INT NOT NULL,
    cliente_key INT NOT NULL,
    producto_key INT NOT NULL,
    ubicacion_key INT NOT NULL,
    canal_key INT NOT NULL,

    cantidad_vendida INT,
    precio_unitario DECIMAL(18,2),
    costo_unitario DECIMAL(18,2),
    descuento DECIMAL(18,2),
    total_venta DECIMAL(18,2),
    existencia_antes INT,
    existencia_despues INT,

    CONSTRAINT FK_fact_fecha FOREIGN KEY (fecha_key)
        REFERENCES dim_fecha(fecha_key),

    CONSTRAINT FK_fact_cliente FOREIGN KEY (cliente_key)
        REFERENCES dim_cliente(cliente_key),

    CONSTRAINT FK_fact_producto FOREIGN KEY (producto_key)
        REFERENCES dim_producto(producto_key),

    CONSTRAINT FK_fact_ubicacion FOREIGN KEY (ubicacion_key)
        REFERENCES dim_ubicacion(ubicacion_key),

    CONSTRAINT FK_fact_canal FOREIGN KEY (canal_key)
        REFERENCES dim_canal(canal_key)
);
