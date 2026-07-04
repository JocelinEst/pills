class FoodConditionType {
  final int id;
  final String name;

  FoodConditionType({
    required this.id,
    required this.name,
  });

  factory FoodConditionType.fromMap(
      Map<String, dynamic> map,
      ) {
    return FoodConditionType(
      id: map['ID'],
      name: map['Name'],
    );
  }
}