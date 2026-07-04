class DatabaseQueriesTestData {

  static const List<Map<String, String>> drugTypes = [
    {'Name': 'Таблетки'},
    {'Name': 'Капсулы'},
    {'Name': 'Сироп'},
    {'Name': 'Раствор'},
    {'Name': 'Капли'},
  ];

  static const List<Map<String, String>> measurementUnits = [
    {'Name': 'тб.'},
    {'Name': 'мл.'},
    {'Name': 'мг.'},
  ];

  static const List<Map<String, String>> foodConditionTypes = [
    {'Name': 'До еды'},
    {'Name': 'После еды'},
    {'Name': 'Во время еды'},
    {'Name': 'Натощак'},
  ];
  static const List<Map<String, dynamic>> testDrugs = [
    {
      'Name': 'Амоксициллин',
      'Prescription': 'Растворить в стакане воды, принимать после еды',
      'Quantity_in_package': 20,
      'Current_quantity': 20,
      'Color': '#FF5733',
      'Drug_type_ID': 1,
    },
    {
      'Name': 'Ибупрофен',
      'Prescription': 'Рассосать под языком, за 30 минут до еды',
      'Quantity_in_package': 30,
      'Current_quantity': 30,
      'Color': '#33FF57',
      'Drug_type_ID': 1,
    },
    {
      'Name': 'Парацетамол',
      'Prescription': 'Запить большим количеством воды, во время еды',
      'Quantity_in_package': 10,
      'Current_quantity': 10,
      'Color': '#3357FF',
      'Drug_type_ID': 1,
    },
    {
      'Name': 'Тетропромизанопрафол',
      'Prescription': null,
      'Quantity_in_package': 50,
      'Current_quantity': 50,
      'Color': '#F033FF',
      'Drug_type_ID': 2,
    },
    {
      'Name': 'Витамин D',
      'Prescription': 'Не разжевывать, запить водой',
      'Quantity_in_package': 15,
      'Current_quantity': 15,
      'Color': '#FF33F0',
      'Drug_type_ID': 5,
    },
  ];
  static List<Map<String, dynamic>> getTestIntakePlans() {
    final now = DateTime.now();
    final startDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final nextMonth = DateTime(now.year, now.month + 1, now.day);
    final endDate = '${nextMonth.year}-${nextMonth.month.toString().padLeft(2, '0')}-${nextMonth.day.toString().padLeft(2, '0')}';

    return [
      {
        'Drug_ID': 1,
        'Start_date': startDate,
        'End_date': endDate,
        'Repeat_cycle': null,
        'Is_active': 1,
      },
      {
        'Drug_ID': 2,
        'Start_date': startDate,
        'End_date': null,
        'Repeat_cycle': null,
        'Is_active': 1,
      },
      {
        'Drug_ID': 3,
        'Start_date': startDate,
        'End_date': endDate,
        'Repeat_cycle': null,
        'Is_active': 1,
      },
      {
        'Drug_ID': 4,
        'Start_date': startDate,
        'End_date': null,
        'Repeat_cycle': 3,
        'Is_active': 1,
      },
      {
        'Drug_ID': 5,
        'Start_date': startDate,
        'End_date': endDate,
        'Repeat_cycle': null,
        'Is_active': 0,
      },
    ];
  }
  static const List<Map<String, dynamic>> testTimeSchedules = [
    {
      'Intake_time': '08:00:00',
      'Days_of_week': null,
      'Intake_plan_ID': 1,
    },
    {
      'Intake_time': '20:00:00',
      'Days_of_week': null,
      'Intake_plan_ID': 1,
    },
    {
      'Intake_time': '09:00:00',
      'Days_of_week': '1,2,3,4,5',
      'Intake_plan_ID': 2,
    },
    {
      'Intake_time': '10:00:00',
      'Days_of_week': '6,7',
      'Intake_plan_ID': 2,
    },
    {
      'Intake_time': '14:00:00',
      'Days_of_week': null,
      'Intake_plan_ID': 3,
    },
    {
      'Intake_time': '21:00:00',
      'Days_of_week': '1,3,5',
      'Intake_plan_ID': 3,
    },
    {
      'Intake_time': '12:00:00',
      'Days_of_week': null,
      'Intake_plan_ID': 4,
    },
    {
      'Intake_time': '18:00:00',
      'Days_of_week': null,
      'Intake_plan_ID': 4,
    },
  ];
  static const List<Map<String, dynamic>> testDosageRules = [

    {
      'Day_from_start': 0,
      'Time_schedule_ID': 1,
      'Measurement_unit_ID': 1,
      'Amount': 1.0,
    },
    {
      'Day_from_start': 0,
      'Time_schedule_ID': 2,
      'Measurement_unit_ID': 1,
      'Amount': 2.0,
    },


    {
      'Day_from_start': 1,
      'Time_schedule_ID': 1,
      'Measurement_unit_ID': 1,
      'Amount': 2.0,
    },
    {
      'Day_from_start': 1,
      'Time_schedule_ID': 2,
      'Measurement_unit_ID': 1,
      'Amount': 2.0,
    },

    {
      'Day_from_start': 0,
      'Time_schedule_ID': 3,
      'Measurement_unit_ID': 2,
      'Amount': 5.0,
    },
    {
      'Day_from_start': 0,
      'Time_schedule_ID': 4,
      'Measurement_unit_ID': 2,
      'Amount': 5.0,
    },


    {
      'Day_from_start': 0,
      'Time_schedule_ID': 5,
      'Measurement_unit_ID': 1,
      'Amount': 2.0,
    },
    {
      'Day_from_start': 0,
      'Time_schedule_ID': 6,
      'Measurement_unit_ID': 1,
      'Amount': 1.0,
    },


    {
      'Day_from_start': 0,
      'Time_schedule_ID': 7,
      'Measurement_unit_ID': 3,
      'Amount': 100.0,
    },
    {
      'Day_from_start': 0,
      'Time_schedule_ID': 8,
      'Measurement_unit_ID': 3,
      'Amount': 50.0,
    },
  ];
  static const List<Map<String, dynamic>> testFoodIntakeConditions = [
    {
      'Time_schedule_ID': 1,
      'Food_condition_type_ID': 2,
    },
    {
      'Time_schedule_ID': 2,
      'Food_condition_type_ID': 2,
    },
    {
      'Time_schedule_ID': 3,
      'Food_condition_type_ID': 1,
    },
    {
      'Time_schedule_ID': 4,
      'Food_condition_type_ID': 4,
    },
    {
      'Time_schedule_ID': 5,
      'Food_condition_type_ID': 3,
    },
    {
      'Time_schedule_ID': 6,
      'Food_condition_type_ID': 2,
    },
    {
      'Time_schedule_ID': 7,
      'Food_condition_type_ID': 1,
    },
    {
      'Time_schedule_ID': 8,
      'Food_condition_type_ID': 4,
    },
  ];
  static List<Map<String, dynamic>> generateTestScheduledIntakes() {
    final now = DateTime.now();

    String format(DateTime d, String time) {
      final dateStr =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      return '$dateStr $time';
    }


    final yesterday = now.subtract(const Duration(days: 1));
    final today = now;
    final tomorrow = now.add(const Duration(days: 1));
    final future = now.add(const Duration(days: 3));

    List<Map<String, dynamic>> data = [


      {
        'Intake_plan_ID': 1,
        'Time_schedule_ID': 1,
        'Scheduled_date': format(yesterday, '08:00:00'),
        'Status': 1,
      },
      {
        'Intake_plan_ID': 2,
        'Time_schedule_ID': 3,
        'Scheduled_date': format(yesterday, '10:00:00'),
        'Status': 0,
      },
      {
        'Intake_plan_ID': 3,
        'Time_schedule_ID': 5,
        'Scheduled_date': format(yesterday, '14:00:00'),
        'Status': 1,
      },


      {
        'Intake_plan_ID': 1,
        'Time_schedule_ID': 1,
        'Scheduled_date': format(today, '08:00:00'),
        'Status': 1,
      },
      {
        'Intake_plan_ID': 2,
        'Time_schedule_ID': 4,
        'Scheduled_date': format(today, '10:00:00'),
        'Status': 0,
      },
      {
        'Intake_plan_ID': 1,
        'Time_schedule_ID': 2,
        'Scheduled_date': format(today, '20:00:00'),
        'Status': 0,
      },


      {
        'Intake_plan_ID': 3,
        'Time_schedule_ID': 6,
        'Scheduled_date': format(tomorrow, '09:00:00'),
        'Status': 0,
      },
      {
        'Intake_plan_ID': 4,
        'Time_schedule_ID': 7,
        'Scheduled_date': format(tomorrow, '12:00:00'),
        'Status': 0,
      },


      {
        'Intake_plan_ID': 2,
        'Time_schedule_ID': 3,
        'Scheduled_date': format(future, '10:00:00'),
        'Status': 0,
      },
      {
        'Intake_plan_ID': 1,
        'Time_schedule_ID': 2,
        'Scheduled_date': format(future, '20:00:00'),
        'Status': 0,
      },
    ];


    data.shuffle();

    return data;
  }
  static List<Map<String, dynamic>> getTestActualIntakes() {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return [
      {
        'Scheduled_intake_ID': 1,
        'Actual_date': todayStr,
        'Actual_time': '08:15:00',
        'Reason': null,
        'Drug_ID': 1,
      },
      {
        'Scheduled_intake_ID': null,
        'Actual_date': todayStr,
        'Actual_time': '14:30:00',
        'Reason': 'Принял внепланово, так как забыл утром',
        'Drug_ID': 2,
      },
    ];
  }
}