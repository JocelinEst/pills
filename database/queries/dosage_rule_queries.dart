class DosageRuleQueries {
  static String getTotalUsedForDrug(int drugId) => '''
  SELECT COALESCE(SUM(
    CASE 
      WHEN si.Status = 1 THEN COALESCE(dr.Amount, 1)
      ELSE 0
    END
  ), 0) as total_used
  FROM Intake_plan ip
  LEFT JOIN Scheduled_intake si ON si.Intake_plan_ID = ip.ID
  LEFT JOIN Dosage_rule dr 
    ON dr.Time_schedule_ID = si.Time_schedule_ID
    AND dr.Day_from_start = CAST(
      ROUND(julianday(substr(si.Scheduled_date, 1, 10)) - julianday(ip.Start_date)) 
      AS INTEGER
    )
  WHERE ip.Drug_ID = $drugId
''';
}