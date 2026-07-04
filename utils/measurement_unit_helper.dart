class MeasurementUnitHelper {
  static String getUnit(
      Map<String, dynamic>? drug,
      ) {
    if (drug == null) {
      return 'тб.';
    }

    final measurement = drug['Measurement'];

    if (measurement != null &&
        measurement.toString().isNotEmpty) {
      return measurement.toString();
    }

    final drugType = drug['Drug_type_Name'];

    switch (drugType?.toString().toLowerCase()) {
      case 'таблетки':
        return 'таб.';

      case 'капсулы':
        return 'капс.';

      case 'сироп':
      case 'раствор':
        return 'мл';

      case 'капли':
        return 'кап.';

      default:
        return 'тб.';
    }
  }
}