CREATE OR REPLACE TABLE `Proyecto2_G20.predicciones_clasificacion_clean` AS
SELECT
  pickup_hour,
  pickup_day_of_week,

  -- Probabilidad de propina alta (label = 1)
  MAX(CASE 
        WHEN prob.label = 1 THEN prob.prob
      END) AS prob_propina_alta,

  -- Predicción final
  MAX(predicted_is_high_tip) AS prediccion

FROM `Proyecto2_G20.predicciones_clasificacion`,
UNNEST(predicted_is_high_tip_probs) AS prob

GROUP BY pickup_hour, pickup_day_of_week;