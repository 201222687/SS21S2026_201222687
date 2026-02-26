import pandas as pd
import pyodbc
import os
import sys

print("Librerías cargadas correctamente")

conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost;"
    "DATABASE=BI_VUELOS;"
    "Trusted_Connection=yes;"
)

cursor = conn.cursor()
print("Conexión exitosa a BI_VUELOS")

csv_path = r"C:\Users\jcmal\Desktop\INGENIERIA\INGE_2026\1_SMSTRE_2026\SMI_2\LAB_SEMI_2\SS21S2026_201222687\PRACTICA1\data\raw\dataset_vuelos_crudo.csv"

df = pd.read_csv(csv_path)
df.columns = df.columns.str.strip().str.lower()

print("Archivo cargado")
df.head()


# ======================================
# FASE 2: TRANSFORMACIÓN
# ======================================

print("Iniciando transformaciones...")

# ---- 1️⃣ Conversión de fechas
for col in ["departure_datetime", "arrival_datetime", "booking_datetime"]:
    df[col] = pd.to_datetime(df[col], errors="coerce", dayfirst=True)

# ---- 2️⃣ Conversión numérica segura
numeric_cols = [
    "duration_min",
    "delay_min",
    "ticket_price_usd_est",
    "bags_total",
    "bags_checked",
    "passenger_age"
]

for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")

# ---- 3️⃣ Normalización aeropuertos
df["origin_airport"] = df["origin_airport"].str.upper()
df["destination_airport"] = df["destination_airport"].str.upper()

# ---- 4️⃣ Eliminar registros críticos nulos
df = df.dropna(subset=[
    "departure_datetime",
    "booking_datetime",
    "airline_code",
    "origin_airport",
    "destination_airport",
    "passenger_id"
])

print("Transformaciones completadas")
print("Total registros válidos:", len(df))

# ======================================
# FASE 3: CARGA
# ======================================

# ======================================
# FASE 3: CARGA FINAL
# ======================================

print("\nINICIANDO FASE DE CARGA...")

cursor.fast_executemany = True
conn.autocommit = False

try:

    # ==================================================
    # DIM_FECHA
    # ==================================================
    print("Cargando dim_fecha...")
    for _, row in df.iterrows():
        for fecha in [row["departure_datetime"], row["booking_datetime"]]:

            cursor.execute("""
            IF NOT EXISTS (SELECT 1 FROM dim_fecha WHERE fecha = ?)
            INSERT INTO dim_fecha (fecha, anio, mes, nombre_mes, dia, trimestre, dia_semana)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            fecha.date(),
            fecha.date(),
            fecha.year,
            fecha.month,
            fecha.strftime("%B"),
            fecha.day,
            (fecha.month - 1)//3 + 1,
            fecha.strftime("%A")
            )

    print("✔ dim_fecha cargada")

    # ==================================================
    # DIM_AEROLINEA
    # ==================================================
    print("Cargando dim_aerolinea...")
    for _, row in df.iterrows():

        cursor.execute("""
        IF NOT EXISTS (SELECT 1 FROM dim_aerolinea WHERE airline_code = ?)
        INSERT INTO dim_aerolinea (airline_code, airline_name)
        VALUES (?, ?)
        """,
        row["airline_code"],
        row["airline_code"],
        row["airline_name"]
        )

    print("✔ dim_aerolinea cargada")

    # ==================================================
    # DIM_AEROPUERTO
    # ==================================================
    print("Cargando dim_aeropuerto...")
    for _, row in df.iterrows():
        for aeropuerto in [row["origin_airport"], row["destination_airport"]]:

            cursor.execute("""
            IF NOT EXISTS (SELECT 1 FROM dim_aeropuerto WHERE codigo_aeropuerto = ?)
            INSERT INTO dim_aeropuerto (codigo_aeropuerto)
            VALUES (?)
            """,
            aeropuerto,
            aeropuerto
            )

    print("✔ dim_aeropuerto cargada")

    # ==================================================
    # DIM_PASAJERO
    # ==================================================
    print("Cargando dim_pasajero...")

    for _, row in df.iterrows():

        try:
            edad = int(float(row["passenger_age"])) if pd.notna(row["passenger_age"]) else None
        except:
            edad = None

        if edad is not None:
            if edad < 18:
                rango = "Menor"
            elif edad < 30:
                rango = "18-29"
            elif edad < 50:
                rango = "30-49"
            else:
                rango = "50+"
        else:
            rango = None

        passenger_id = str(row["passenger_id"]).strip() if pd.notna(row["passenger_id"]) else None
        genero = str(row["passenger_gender"]).strip() if pd.notna(row["passenger_gender"]) else None
        nacionalidad = str(row["passenger_nationality"]).strip() if pd.notna(row["passenger_nationality"]) else None

        cursor.execute("""
        IF NOT EXISTS (SELECT 1 FROM dim_pasajero WHERE passenger_id = ?)
        INSERT INTO dim_pasajero (passenger_id, genero, edad, rango_edad, nacionalidad)
        VALUES (?, ?, ?, ?, ?)
        """,
        passenger_id,
        passenger_id,
        genero,
        edad,
        rango,
        nacionalidad
        )

    print("✔ dim_pasajero cargada")

    # ==================================================
    # DIM_PAGO
    # ==================================================
    print("Cargando dim_pago...")

    for _, row in df.iterrows():

        canal_venta = str(row["sales_channel"]).strip() if pd.notna(row["sales_channel"]) else None
        metodo_pago = str(row["payment_method"]).strip() if pd.notna(row["payment_method"]) else None
        moneda = str(row["currency"]).strip() if pd.notna(row["currency"]) else None

        cursor.execute("""
        IF NOT EXISTS (
            SELECT 1 FROM dim_pago
            WHERE canal_venta = ? AND metodo_pago = ? AND moneda = ?
        )
        INSERT INTO dim_pago (canal_venta, metodo_pago, moneda)
        VALUES (?, ?, ?)
        """,
        canal_venta,
        metodo_pago,
        moneda,
        canal_venta,
        metodo_pago,
        moneda
        )

    print("✔ dim_pago cargada")

    # ==================================================
    # DIM_CABINA
    # ==================================================
    print("Cargando dim_cabina...")

    for _, row in df.iterrows():

        cursor.execute("""
        IF NOT EXISTS (
            SELECT 1 FROM dim_cabina
            WHERE cabin_class = ? AND aircraft_type = ?
        )
        INSERT INTO dim_cabina (cabin_class, aircraft_type)
        VALUES (?, ?)
        """,
        row["cabin_class"],
        row["aircraft_type"],
        row["cabin_class"],
        row["aircraft_type"]
        )

    print("✔ dim_cabina cargada")

    # ==================================================
    # DIM_ESTADO
    # ==================================================
    print("Cargando dim_estado...")

    for _, row in df.iterrows():

        cursor.execute("""
        IF NOT EXISTS (SELECT 1 FROM dim_estado WHERE estado_vuelo = ?)
        INSERT INTO dim_estado (estado_vuelo)
        VALUES (?)
        """,
        row["status"],
        row["status"]
        )

    print("✔ dim_estado cargada")

    # ==================================================
    # FACT_VUELOS
    # ==================================================
    print("Cargando fact_vuelos...")

    for _, row in df.iterrows():

        airline_code = str(row["airline_code"]).strip() if pd.notna(row["airline_code"]) else None
        origin_airport = str(row["origin_airport"]).strip() if pd.notna(row["origin_airport"]) else None
        destination_airport = str(row["destination_airport"]).strip() if pd.notna(row["destination_airport"]) else None
        passenger_id = str(row["passenger_id"]).strip() if pd.notna(row["passenger_id"]) else None
        sales_channel = str(row["sales_channel"]).strip() if pd.notna(row["sales_channel"]) else None
        payment_method = str(row["payment_method"]).strip() if pd.notna(row["payment_method"]) else None
        currency = str(row["currency"]).strip() if pd.notna(row["currency"]) else None
        cabin_class = str(row["cabin_class"]).strip() if pd.notna(row["cabin_class"]) else None
        aircraft_type = str(row["aircraft_type"]).strip() if pd.notna(row["aircraft_type"]) else None
        status = str(row["status"]).strip() if pd.notna(row["status"]) else None

        fecha_salida = row["departure_datetime"].date() if pd.notna(row["departure_datetime"]) else None
        fecha_reserva = row["booking_datetime"].date() if pd.notna(row["booking_datetime"]) else None

        duration = int(float(row["duration_min"])) if pd.notna(row["duration_min"]) else None
        delay = int(float(row["delay_min"])) if pd.notna(row["delay_min"]) else None
        price = float(row["ticket_price_usd_est"]) if pd.notna(row["ticket_price_usd_est"]) else None
        bags_total = int(float(row["bags_total"])) if pd.notna(row["bags_total"]) else None
        bags_checked = int(float(row["bags_checked"])) if pd.notna(row["bags_checked"]) else None

        cursor.execute("SELECT fecha_key FROM dim_fecha WHERE fecha = ?", fecha_salida)
        fecha_salida_key = cursor.fetchone()
        if not fecha_salida_key: continue
        fecha_salida_key = fecha_salida_key[0]

        cursor.execute("SELECT fecha_key FROM dim_fecha WHERE fecha = ?", fecha_reserva)
        fecha_reserva_key = cursor.fetchone()
        if not fecha_reserva_key: continue
        fecha_reserva_key = fecha_reserva_key[0]

        cursor.execute("SELECT aerolinea_key FROM dim_aerolinea WHERE airline_code = ?", airline_code)
        aerolinea_key = cursor.fetchone()
        if not aerolinea_key: continue
        aerolinea_key = aerolinea_key[0]

        cursor.execute("SELECT aeropuerto_key FROM dim_aeropuerto WHERE codigo_aeropuerto = ?", origin_airport)
        origen_key = cursor.fetchone()
        if not origen_key: continue
        origen_key = origen_key[0]

        cursor.execute("SELECT aeropuerto_key FROM dim_aeropuerto WHERE codigo_aeropuerto = ?", destination_airport)
        destino_key = cursor.fetchone()
        if not destino_key: continue
        destino_key = destino_key[0]

        cursor.execute("SELECT pasajero_key FROM dim_pasajero WHERE passenger_id = ?", passenger_id)
        pasajero_key = cursor.fetchone()
        if not pasajero_key: continue
        pasajero_key = pasajero_key[0]

        cursor.execute("""
            SELECT pago_key FROM dim_pago
            WHERE canal_venta = ? AND metodo_pago = ? AND moneda = ?
        """, sales_channel, payment_method, currency)
        pago_key = cursor.fetchone()
        if not pago_key: continue
        pago_key = pago_key[0]

        cursor.execute("""
            SELECT cabina_key FROM dim_cabina
            WHERE cabin_class = ? AND aircraft_type = ?
        """, cabin_class, aircraft_type)
        cabina_key = cursor.fetchone()
        if not cabina_key: continue
        cabina_key = cabina_key[0]

        cursor.execute("SELECT estado_key FROM dim_estado WHERE estado_vuelo = ?", status)
        estado_key = cursor.fetchone()
        if not estado_key: continue
        estado_key = estado_key[0]

        cursor.execute("""
        INSERT INTO fact_vuelos (
            fecha_salida_key,
            fecha_reserva_key,
            aerolinea_key,
            origen_key,
            destino_key,
            pasajero_key,
            pago_key,
            cabina_key,
            estado_key,
            duration_min,
            delay_min,
            ticket_price_usd,
            bags_total,
            bags_checked
        )
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        """,
        fecha_salida_key,
        fecha_reserva_key,
        aerolinea_key,
        origen_key,
        destino_key,
        pasajero_key,
        pago_key,
        cabina_key,
        estado_key,
        duration,
        delay,
        price,
        bags_total,
        bags_checked
        )

    conn.commit()
    print("\nETL COMPLETADO EXITOSAMENTE")

except Exception as e:
    conn.rollback()
    print("\nERROR EN EL ETL:", e)

# ======================================
# FASE 3: CARGA FINAL
# ======================================


cursor.close()
conn.close()
print("Conexión cerrada")