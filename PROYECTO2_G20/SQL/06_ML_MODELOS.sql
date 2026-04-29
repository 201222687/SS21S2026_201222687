

-- BLOQUE DE MACHINE LEARNING COMPLETO.


-- MODELO 1: CLASIFICACIÓN (PROPINA ALTA)

-- Objetivo: predecir si un viaje tendrá propina alta (is_high_tip)

-- Esta consulta crea un modelo de regresión logística que aprende a predecir si un viaje tendrá una propina alta (is_high_tip).
-- Se entrena únicamente con los datos del conjunto TRAIN, utilizando variables como distancia, monto, tiempo y ubicación del viaje.

CREATE OR REPLACE MODEL `Proyecto2_G20.modelo_clasificacion`
OPTIONS(
  model_type = 'logistic_reg',
  input_label_cols = ['is_high_tip']
) AS
SELECT
  passenger_count,
  trip_distance,
  fare_amount,
  trip_duration_minutes,
  pickup_hour,
  pickup_day_of_week,
  pickup_month,
  payment_type,
  pickup_location_id,
  dropoff_location_id,
  is_high_tip
FROM `Proyecto2_G20.ml_features_taxi_2022`
WHERE split_col = 'TRAIN';


-- EVALUACIÓN (USANDO EVAL)

-- Esta consulta evalúa el modelo usando los datos de EVAL, es decir, datos que el modelo no vio durante el entrenamiento.
-- Permite medir su desempeño mediante métricas como accuracy, precision, recall y ROC AUC, indicando qué tan bien predice las propinas altas.

SELECT *
FROM ML.EVALUATE(
  MODEL `Proyecto2_G20.modelo_clasificacion`,
  (
    SELECT
      passenger_count,
      trip_distance,
      fare_amount,
      trip_duration_minutes,
      pickup_hour,
      pickup_day_of_week,
      pickup_month,
      payment_type,
      pickup_location_id,
      dropoff_location_id,
      is_high_tip
    FROM `Proyecto2_G20.ml_features_taxi_2022`
    WHERE split_col = 'EVAL'
  )
);

-- PREDICCIONES.

-- Esta consulta aplica el modelo sobre datos nuevos (PREDICT) para estimar si un viaje tendrá propina alta.
-- Devuelve:

-- la predicción (0 o 1)
-- la probabilidad asociada

SELECT
  *,
  predicted_is_high_tip,
  predicted_is_high_tip_probs
FROM ML.PREDICT(
  MODEL `Proyecto2_G20.modelo_clasificacion`,
  (
    SELECT
      passenger_count,
      trip_distance,
      fare_amount,
      trip_duration_minutes,
      pickup_hour,
      pickup_day_of_week,
      pickup_month,
      payment_type,
      pickup_location_id,
      dropoff_location_id
    FROM `Proyecto2_G20.ml_features_taxi_2022`
    WHERE split_col = 'PREDICT'
  )
);

--  GUARDAR PREDICCIONES

-- Esta consulta guarda los resultados de las predicciones en una nueva tabla (predicciones_clasificacion).
-- Esto permite usar los resultados posteriormente en visualizaciones o análisis.


CREATE OR REPLACE TABLE `Proyecto2_G20.predicciones_clasificacion` AS
SELECT
  *
FROM ML.PREDICT(
  MODEL `Proyecto2_G20.modelo_clasificacion`,
  (
    SELECT
      passenger_count,
      trip_distance,
      fare_amount,
      trip_duration_minutes,
      pickup_hour,
      pickup_day_of_week,
      pickup_month,
      payment_type,
      pickup_location_id,
      dropoff_location_id
    FROM `Proyecto2_G20.ml_features_taxi_2022`
    WHERE split_col = 'PREDICT'
  )
);


-- MODELO 2: REGRESIÓN (MONTO DE PROPINA)

-- Objetivo: predecir cuánto será la propina (tip_amount)

-- Esta consulta crea un modelo de regresión lineal que predice el monto exacto de la propina (tip_amount).
-- Se entrena con datos del conjunto TRAIN, utilizando variables del viaje como distancia, tarifa, tiempo y ubicación.


CREATE OR REPLACE MODEL `Proyecto2_G20.modelo_regresion`
OPTIONS(
  model_type = 'linear_reg',
  input_label_cols = ['tip_amount']
) AS
SELECT
  passenger_count,
  trip_distance,
  fare_amount,
  trip_duration_minutes,
  pickup_hour,
  pickup_day_of_week,
  pickup_month,
  payment_type,
  pickup_location_id,
  dropoff_location_id,
  tip_amount
FROM `Proyecto2_G20.ml_features_taxi_2022`
WHERE split_col = 'TRAIN';


-- EVALUACIÓN REGRESIÓN 

-- Esta consulta evalúa el modelo con datos de EVAL, midiendo su precisión mediante métricas como el RMSE (error cuadrático medio).
-- Permite determinar qué tan cerca están las predicciones de los valores reales.

SELECT *
FROM ML.EVALUATE(
  MODEL `Proyecto2_G20.modelo_regresion`,
  (
    SELECT
      passenger_count,
      trip_distance,
      fare_amount,
      trip_duration_minutes,
      pickup_hour,
      pickup_day_of_week,
      pickup_month,
      payment_type,
      pickup_location_id,
      dropoff_location_id,
      tip_amount
    FROM `Proyecto2_G20.ml_features_taxi_2022`
    WHERE split_col = 'EVAL'
  )
);


-- PREDICCIONES

-- Esta consulta usa el modelo para estimar el monto de la propina en datos nuevos (PREDICT).
-- Devuelve el valor estimado (predicted_tip_amount) para cada viaje.

SELECT
  *,
  predicted_tip_amount
FROM ML.PREDICT(
  MODEL `Proyecto2_G20.modelo_regresion`,
  (
    SELECT
      passenger_count,
      trip_distance,
      fare_amount,
      trip_duration_minutes,
      pickup_hour,
      pickup_day_of_week,
      pickup_month,
      payment_type,
      pickup_location_id,
      dropoff_location_id
    FROM `Proyecto2_G20.ml_features_taxi_2022`
    WHERE split_col = 'PREDICT'
  )
);

-- GUARDA PREDICCIONES.

-- Esta consulta guarda las predicciones del modelo de regresión en una tabla (predicciones_regresion).
-- Esto facilita su uso en dashboards o comparaciones posteriores.

CREATE OR REPLACE TABLE `Proyecto2_G20.predicciones_regresion` AS
SELECT
  *  
FROM ML.PREDICT(
  MODEL `Proyecto2_G20.modelo_regresion`,
  (
    SELECT
      passenger_count,
      trip_distance,
      fare_amount,
      trip_duration_minutes,
      pickup_hour,
      pickup_day_of_week,
      pickup_month,
      payment_type,
      pickup_location_id,
      dropoff_location_id
    FROM `Proyecto2_G20.ml_features_taxi_2022`
    WHERE split_col = 'PREDICT'
  )
);

