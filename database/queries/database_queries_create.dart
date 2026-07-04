class DatabaseQueries {
  static const String createDrugTypeTable =
  '''
  CREATE TABLE Drug_types(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL
  )
  ''';
  static const String createDrugTable = '''
  CREATE TABLE Drug_types (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL, 
    Prescription TEXT,
    Quantity_in_package INTEGER NOT NULL CHECK (Quantity_in_package >= 0),
    Current_quantity INTEGER NOT NULL DEFAULT 0 CHECK (Current_quantity >= 0),
    Color TEXT NOT NULL,
     Drug_type_ID INTEGER,
  FOREIGN KEY (Drug_type_ID) REFERENCES Drug_types(ID) 
    ON DELETE SET NULL 
    ON UPDATE CASCADE
  )
''';

  static const String createMeasurementUnitsTable = '''
    CREATE TABLE Measurement_units (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      Name TEXT NOT NULL UNIQUE
    )
  ''';

  static const String createFoodConditionTypesTable = '''
    CREATE TABLE Food_condition_types (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      Name TEXT NOT NULL UNIQUE
    )
  ''';

  static const String createIntakePlanTable = '''
    CREATE TABLE Intake_plan (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      Drug_ID INTEGER NOT NULL,
      Start_date TEXT NOT NULL,
      End_date TEXT,
      Repeat_cycle INTEGER,
      Is_active INTEGER NOT NULL DEFAULT 1,
      FOREIGN KEY (Drug_ID) REFERENCES Drug(ID) ON DELETE RESTRICT ON UPDATE CASCADE,
      CHECK (End_date >= Start_date OR End_date IS NULL),
      CHECK (Repeat_cycle > 0 OR Repeat_cycle IS NULL)
    )
  ''';

  static const String createTimeScheduleTable = '''
    CREATE TABLE Time_schedule (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      Intake_time TEXT NOT NULL,
      Days_of_week TEXT,
      Intake_plan_ID INTEGER NOT NULL,
      FOREIGN KEY (Intake_plan_ID) REFERENCES Intake_plan(ID) ON DELETE CASCADE ON UPDATE CASCADE,
      CHECK (Days_of_week IS NULL OR Days_of_week GLOB '[1-7]*' AND Days_of_week NOT GLOB '*[^1-7,]*')
    )
  ''';

  static const String createDosageRuleTable = '''
  CREATE TABLE Dosage_rule (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  Day_from_start INTEGER NOT NULL CHECK (Day_from_start >= 0),
  Amount REAL NOT NULL CHECK (Amount > 0),
  Time_schedule_ID INTEGER NOT NULL,
  Measurement_unit_ID INTEGER NOT NULL,
  FOREIGN KEY (Time_schedule_ID)
    REFERENCES Time_schedule(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (Measurement_unit_ID)
    REFERENCES Measurement_units(ID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
  ''';

  static const String createScheduledIntakeTable = '''
    CREATE TABLE Scheduled_intake (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      Intake_plan_ID INTEGER NOT NULL,
      Time_schedule_ID INTEGER NOT NULL,
      Scheduled_date TEXT NOT NULL,
      Status INTEGER NOT NULL DEFAULT 0 CHECK (Status IN (0,1)),
      FOREIGN KEY (Intake_plan_ID) REFERENCES Intake_plan(ID) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (Time_schedule_ID) REFERENCES Time_schedule(ID) ON DELETE RESTRICT ON UPDATE CASCADE
    )
  ''';

  static const String createActualIntakeTable = '''
    CREATE TABLE Actual_intake (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      Scheduled_intake_ID INTEGER,
      Actual_date TEXT NOT NULL,
      Actual_time TEXT NOT NULL,
      Reason TEXT,
      Drug_ID INTEGER NOT NULL,
      FOREIGN KEY (Scheduled_intake_ID) REFERENCES Scheduled_intake(ID) ON DELETE SET NULL ON UPDATE CASCADE,
      FOREIGN KEY (Drug_ID) REFERENCES Drug(ID) ON DELETE RESTRICT ON UPDATE CASCADE
    )
  ''';

  static const String createFoodIntakeConditionTable = '''
    CREATE TABLE Food_intake_condition (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      Time_schedule_ID INTEGER NOT NULL,
      Food_condition_type_ID INTEGER NOT NULL,
      FOREIGN KEY (Time_schedule_ID) REFERENCES Time_schedule(ID) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (Food_condition_type_ID) REFERENCES Food_condition_types(ID) ON DELETE RESTRICT ON UPDATE CASCADE
    )
  ''';

  static const String createIndexOnScheduledDate = '''
    CREATE INDEX idx_scheduled_date ON Scheduled_intake(Scheduled_date)
  ''';
}

