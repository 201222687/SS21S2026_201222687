CREATE OR REPLACE TABLE `Proyecto2_G20.predicciones_clasificacion_clean` AS
SELECT
  CAST(pickup_hour AS INT64) AS pickup_hour,
  CAST(pickup_day_of_week AS INT64) AS pickup_day_of_week,

  -- Probabilidad promedio de propina alta
  AVG(
    CASE 
      WHEN prob.label = 1 THEN prob.prob
    END
  ) AS prob_propina_alta,

  -- Porcentaje de predicciones de propina alta
  AVG(CAST(predicted_is_high_tip AS FLOAT64)) AS tasa_prediccion_alta

FROM `Proyecto2_G20.predicciones_clasificacion`,
UNNEST(predicted_is_high_tip_probs) AS prob

GROUP BY pickup_hour, pickup_day_of_week;


SELECT
  CAST(pickup_hour AS INT64) AS pickup_hour,

  -- Probabilidad promedio de propina alta
  AVG(IF(prob.label = 1, prob.prob, NULL)) AS prob_propina_alta

FROM `Proyecto2_G20.predicciones_clasificacion`,
UNNEST(predicted_is_high_tip_probs) AS prob

GROUP BY pickup_hour
ORDER BY pickup_hour;


SELECT
  pickup_day_of_week,

  AVG(prob_propina_alta) AS prob_propina_alta_promedio,
  AVG(tasa_prediccion_alta) AS tasa_prediccion_promedio,

  COUNT(*) AS total_registros

FROM `Proyecto2_G20.predicciones_clasificacion_clean`

GROUP BY pickup_day_of_week
ORDER BY pickup_day_of_week;

