class DrugQueries {
  static const String getAllDrugsList = '''
    SELECT 
      d.ID,
      d.Name,
      d.Prescription,
      d.Quantity_in_package,
      d.Current_quantity,
      d.Color,
      d.Drug_type_ID,
      dt.Name as Drug_type_Name,
      dt.Measurement as Measurement
    FROM Drug d
    LEFT JOIN Drug_types dt ON dt.ID = d.Drug_type_ID
    ORDER BY d.Name ASC
  ''';
  static const String getFoodConditionTypes = '''
  SELECT ID, Name
  FROM Food_condition_types
  ORDER BY ID
''';
  static const String getDrugTypes = '''
    SELECT ID, Name, Measurement 
    FROM Drug_types
    ORDER BY Name
  ''';

  static String deleteDrug(int id) => 'DELETE FROM Drug WHERE ID = $id';

  static String decrementDrugQuantity(int drugId, int amount) =>
      'UPDATE Drug SET Current_quantity = Current_quantity - $amount WHERE ID = $drugId';

  static String incrementDrugQuantity(int drugId, int amount) =>
      'UPDATE Drug SET Current_quantity = Current_quantity + $amount WHERE ID = $drugId';

  static String updateDrugCurrentQuantity(int drugId, int newQuantity) =>
      'UPDATE Drug SET Current_quantity = $newQuantity WHERE ID = $drugId';

  static const String resetAllCurrentQuantities =
      'UPDATE Drug SET Current_quantity = Quantity_in_package';

  static String checkIntakeHistory(int drugId) => '''
    SELECT 
      (SELECT COUNT(*) FROM Scheduled_intake si 
       JOIN Intake_plan ip ON si.Intake_plan_ID = ip.ID 
       WHERE ip.Drug_ID = $drugId) +
      (SELECT COUNT(*) FROM Actual_intake WHERE Drug_ID = $drugId)
    as count
  ''';
}
