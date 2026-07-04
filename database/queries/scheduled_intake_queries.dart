class ScheduledIntakeQueries {
  static const String getAllDrugs = '''
  SELECT 
    si.ID as scheduled_id,
    d.Name as drug_name,
    d.Color,
    d.Prescription,
    dt.Name as form_type,
    ts.Intake_time,
    si.Status,
    si.Scheduled_date,
    food.food_rule,
    CAST(
      julianday(date(si.Scheduled_date)) -
      julianday(date(ip.Start_date))
      AS INT
    ) as day_from_start,

    dr.Amount as amount,
    mu.ID as unit_id,
    mu.Name as unit

  FROM Scheduled_intake si
  JOIN Intake_plan ip
    ON si.Intake_plan_ID = ip.ID
  JOIN Drug d
    ON ip.Drug_ID = d.ID
  LEFT JOIN Drug_types dt
    ON dt.ID = d.Drug_type_ID
  JOIN Time_schedule ts
    ON si.Time_schedule_ID = ts.ID

  LEFT JOIN Dosage_rule dr
    ON dr.Time_schedule_ID = ts.ID
   AND dr.Day_from_start = (
      SELECT MAX(dr2.Day_from_start)
      FROM Dosage_rule dr2
      WHERE dr2.Time_schedule_ID = ts.ID
        AND dr2.Day_from_start <= CAST(
          julianday(date(si.Scheduled_date)) -
          julianday(date(ip.Start_date)) AS INT
        )
   )

  LEFT JOIN Measurement_units mu
    ON mu.ID = dr.Measurement_unit_ID

  LEFT JOIN (
    SELECT 
      fic.Time_schedule_ID,
      GROUP_CONCAT(fc.Name, ', ') as food_rule
    FROM Food_intake_condition fic
    JOIN Food_condition_types fc
      ON fc.ID = fic.Food_condition_type_ID
    GROUP BY fic.Time_schedule_ID
  ) food
    ON food.Time_schedule_ID = ts.ID

  WHERE ip.Is_active = 1

  GROUP BY si.ID

  ORDER BY
    si.Scheduled_date ASC,
    ts.Intake_time ASC
''';

  static String getDrugsForDatePanel(DateTime date) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return '''
    SELECT
      si.ID as scheduled_id,
      d.Name as drug_name,
      d.Color,
      d.Prescription,
      dt.Name as form_type,
      ts.Intake_time,
      si.Status,
      si.Scheduled_date,
      food.food_rule,
      dr.Amount as amount,
      mu.Name as unit

    FROM Scheduled_intake si
    JOIN Intake_plan ip 
      ON si.Intake_plan_ID = ip.ID
    JOIN Drug d 
      ON ip.Drug_ID = d.ID
    LEFT JOIN Drug_types dt 
      ON dt.ID = d.Drug_type_ID
    JOIN Time_schedule ts 
      ON si.Time_schedule_ID = ts.ID

    LEFT JOIN Dosage_rule dr 
      ON dr.Time_schedule_ID = ts.ID
     AND dr.Day_from_start = (
        SELECT MAX(dr2.Day_from_start)
        FROM Dosage_rule dr2
        WHERE dr2.Time_schedule_ID = ts.ID
          AND dr2.Day_from_start <= CAST(
            julianday(date(si.Scheduled_date)) -
            julianday(date(ip.Start_date)) AS INT
          )
     )

    LEFT JOIN Measurement_units mu 
      ON mu.ID = dr.Measurement_unit_ID

    LEFT JOIN (
      SELECT 
        fic.Time_schedule_ID,
        GROUP_CONCAT(fc.Name, ', ') as food_rule
      FROM Food_intake_condition fic
      JOIN Food_condition_types fc 
        ON fc.ID = fic.Food_condition_type_ID
      GROUP BY fic.Time_schedule_ID
    ) food 
      ON food.Time_schedule_ID = ts.ID

    WHERE DATE(si.Scheduled_date) = '$dateStr'
      AND ip.Is_active = 1

    GROUP BY si.ID

    ORDER BY ts.Intake_time ASC
    ''';
  }

  static String updateScheduledIntakeStatus(int id, bool isTaken) =>
      'UPDATE Scheduled_intake SET Status = ${isTaken ? 1 : 0} WHERE ID = $id';

  static String getDrugIdAndDoseForScheduledIntake(int id) => '''
  SELECT 
    d.ID as drug_id,
    dr.Amount as amount,
    mu.ID as unit_id,
    mu.Name as unit

  FROM Scheduled_intake si
  JOIN Intake_plan ip 
    ON si.Intake_plan_ID = ip.ID
  JOIN Drug d 
    ON ip.Drug_ID = d.ID

  LEFT JOIN Dosage_rule dr 
    ON dr.Time_schedule_ID = si.Time_schedule_ID
   AND dr.Day_from_start = (
      SELECT MAX(dr2.Day_from_start)
      FROM Dosage_rule dr2
      WHERE dr2.Time_schedule_ID = si.Time_schedule_ID
        AND dr2.Day_from_start <= CAST(
          julianday(date(si.Scheduled_date)) -
          julianday(date(ip.Start_date)) AS INT
        )
   )

  LEFT JOIN Measurement_units mu
    ON mu.ID = dr.Measurement_unit_ID

  WHERE si.ID = $id
''';
}