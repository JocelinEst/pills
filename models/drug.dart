class DrugInfo {
  String name;
  String colorHex;
  String intakeTime;
  bool isTaken;
  String? foodRule;
  String? formType;
  int? scheduledIntakeId;
  String? prescription;
  DateTime date;
  int quantityInPackage;
  int currentQuantity;
  int? drugTypeId;
  int? id;
  double? amount;
  String? unit;

  DrugInfo({
    required this.name,
    required this.colorHex,
    required this.intakeTime,
    required this.isTaken,
    required this.date,
    required this.quantityInPackage,
    required this.currentQuantity,
    this.foodRule,
    this.formType,
    this.scheduledIntakeId,
    this.prescription,
    this.drugTypeId,
    this.id,
    this.amount,
    this.unit,
  });

  DrugInfo copyWith({
    String? name,
    String? colorHex,
    String? intakeTime,
    bool? isTaken,
    String? foodRule,
    String? formType,
    int? scheduledIntakeId,
    String? prescription,
    DateTime? date,
    int? quantityInPackage,
    int? currentQuantity,
    int? drugTypeId,
    int? id,
    double? amount,
    String? unit,
  }) {
    return DrugInfo(
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      intakeTime: intakeTime ?? this.intakeTime,
      isTaken: isTaken ?? this.isTaken,
      foodRule: foodRule ?? this.foodRule,
      formType: formType ?? this.formType,
      scheduledIntakeId: scheduledIntakeId ?? this.scheduledIntakeId,
      prescription: prescription ?? this.prescription,
      date: date ?? this.date,
      quantityInPackage: quantityInPackage ?? this.quantityInPackage,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      drugTypeId: drugTypeId ?? this.drugTypeId,
      id: id ?? this.id,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }
}