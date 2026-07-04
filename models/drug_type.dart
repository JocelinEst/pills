class DrugType {
  final int id;
  final String name;
  final String measurement;

  DrugType({
    required this.id,
    required this.name,
    required this.measurement,
  });

  factory DrugType.fromMap(Map<String, dynamic> map) {
    return DrugType(
      id: map['ID'],
      name: map['Name'],
      measurement: map['Measurement'] ?? '',
    );
  }
}