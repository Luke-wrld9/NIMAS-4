import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class Profile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String age;

  @HiveField(2)
  String height;

  @HiveField(3)
  String weight;

  @HiveField(4)
  Map<String, String> dailyNutrientGoals; // Added this field

  @HiveField(5)
  String nutrientDeficiencies; // Added this field

  @HiveField(6)
  List<String> dietaryRestrictions; // Added this field

  Profile({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.dailyNutrientGoals,
    required this.nutrientDeficiencies,
    required this.dietaryRestrictions,
  });
}
