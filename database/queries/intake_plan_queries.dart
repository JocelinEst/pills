class IntakePlanQueries {
  static const String getIntakePlansFull = '''
  SELECT 
    ip.ID as plan_id,
    d.Name as drug_name,
    d.Color as color_hex,
    ip.Start_date,
    ip.End_date,
    ts.Intake_time,
    ts.Days_of_week as days,
    dr.Amount as dose,
    mu.Name as unit,
    GROUP_CONCAT(DISTINCT fc.Name) as food_rule
  FROM Intake_plan ip
  JOIN Drug d ON d.ID = ip.Drug_ID
  LEFT JOIN Time_schedule ts ON ts.Intake_plan_ID = ip.ID
  LEFT JOIN Dosage_rule dr 
    ON dr.Time_schedule_ID = ts.ID 
    AND dr.Day_from_start = 0
  LEFT JOIN Measurement_units mu 
    ON mu.ID = dr.Measurement_unit_ID
  LEFT JOIN Food_intake_condition fic 
    ON fic.Time_schedule_ID = ts.ID
  LEFT JOIN Food_condition_types fc 
    ON fc.ID = fic.Food_condition_type_ID
  WHERE ip.Is_active = 1
    AND (
      ip.End_date IS NULL
      OR DATE(ip.End_date) > DATE(ip.Start_date)
    )
  GROUP BY ip.ID, ts.ID
  ORDER BY ip.ID, ts.Intake_time
''';

  static String getDosageSchemeForPlan(int planId) => '''
    SELECT 
      dr.Day_from_start,
      dr.Amount,
      mu.Name as unit,
      ts.Intake_time
    FROM Dosage_rule dr
    JOIN Time_schedule ts ON ts.ID = dr.Time_schedule_ID
    JOIN Measurement_units mu ON mu.ID = dr.Measurement_unit_ID
    WHERE ts.Intake_plan_ID = $planId
    ORDER BY dr.Day_from_start ASC, ts.Intake_time ASC
  ''';


}