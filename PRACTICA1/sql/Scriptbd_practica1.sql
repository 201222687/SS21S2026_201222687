/* =====================================================
 * 
 * CREATE DATABASE BI_VUELOS;
 * 
   DIMENSION FECHA
   Jerarquía: Año → Mes → Día
===================================================== */

USE BI_VUELOS;

CREATE TABLE dim_fecha (
    fecha_key INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    anio INT NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(20),
    dia INT NOT NULL,
    trimestre INT,
    dia_semana VARCHAR(20)
);

CREATE INDEX ix_dim_fecha_anio_mes
ON dim_fecha(anio, mes);


/* =====================================================
   DIMENSION AEROLINEA
===================================================== */

CREATE TABLE dim_aerolinea (
    aerolinea_key INT IDENTITY(1,1) PRIMARY KEY,
    airline_code VARCHAR(10),
    airline_name VARCHAR(100)
);

CREATE INDEX ix_dim_aerolinea_code
ON dim_aerolinea(airline_code);


/* =====================================================
   DIMENSION AEROPUERTO
===================================================== */

CREATE TABLE dim_aeropuerto (
    aeropuerto_key INT IDENTITY(1,1) PRIMARY KEY,
    codigo_aeropuerto VARCHAR(10)
);

CREATE INDEX ix_dim_aeropuerto_codigo
ON dim_aeropuerto(codigo_aeropuerto);


/* =====================================================
   DIMENSION PASAJERO
===================================================== */

CREATE TABLE dim_pasajero (
    pasajero_key INT IDENTITY(1,1) PRIMARY KEY,
    passenger_id VARCHAR(50),
    genero VARCHAR(20),
    edad INT,
    rango_edad VARCHAR(20),
    nacionalidad VARCHAR(50)
);

CREATE INDEX ix_dim_pasajero_id
ON dim_pasajero(passenger_id);


/* =====================================================
   DIMENSION PAGO
===================================================== */

CREATE TABLE dim_pago (
    pago_key INT IDENTITY(1,1) PRIMARY KEY,
    canal_venta VARCHAR(50),
    metodo_pago VARCHAR(50),
    moneda VARCHAR(10)
);


/* =====================================================
   DIMENSION CABINA
===================================================== */

CREATE TABLE dim_cabina (
    cabina_key INT IDENTITY(1,1) PRIMARY KEY,
    cabin_class VARCHAR(50),
    aircraft_type VARCHAR(100)
);


/* =====================================================
   DIMENSION ESTADO VUELO
===================================================== */

CREATE TABLE dim_estado (
    estado_key INT IDENTITY(1,1) PRIMARY KEY,
    estado_vuelo VARCHAR(50)
);


/* =====================================================
   TABLA DE HECHOS
===================================================== */

CREATE TABLE fact_vuelos (
    fact_key INT IDENTITY(1,1) PRIMARY KEY,

    fecha_salida_key INT NOT NULL,
    fecha_reserva_key INT NOT NULL,
    aerolinea_key INT NOT NULL,
    origen_key INT NOT NULL,
    destino_key INT NOT NULL,
    pasajero_key INT NOT NULL,
    pago_key INT NOT NULL,
    cabina_key INT NOT NULL,
    estado_key INT NOT NULL,

    duration_min INT,
    delay_min INT,
    ticket_price_usd DECIMAL(12,2),
    bags_total INT,
    bags_checked INT,

    FOREIGN KEY (fecha_salida_key) REFERENCES dim_fecha(fecha_key),
    FOREIGN KEY (fecha_reserva_key) REFERENCES dim_fecha(fecha_key),
    FOREIGN KEY (aerolinea_key) REFERENCES dim_aerolinea(aerolinea_key),
    FOREIGN KEY (origen_key) REFERENCES dim_aeropuerto(aeropuerto_key),
    FOREIGN KEY (destino_key) REFERENCES dim_aeropuerto(aeropuerto_key),
    FOREIGN KEY (pasajero_key) REFERENCES dim_pasajero(pasajero_key),
    FOREIGN KEY (pago_key) REFERENCES dim_pago(pago_key),
    FOREIGN KEY (cabina_key) REFERENCES dim_cabina(cabina_key),
    FOREIGN KEY (estado_key) REFERENCES dim_estado(estado_key)
);


/* =====================================================
   INDICES PARA OPTIMIZACION ANALITICA
===================================================== */

CREATE INDEX ix_fact_fecha
ON fact_vuelos(fecha_salida_key);

CREATE INDEX ix_fact_aerolinea
ON fact_vuelos(aerolinea_key);

CREATE INDEX ix_fact_destino
ON fact_vuelos(destino_key);

CREATE INDEX ix_fact_precio
ON fact_vuelos(ticket_price_usd);