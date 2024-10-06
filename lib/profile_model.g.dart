// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// ************************************************************************** 
// TypeAdapterGenerator 
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 0; // Update typeId to match the one used in profile_model.dart

  @override
  Profile read(BinaryReader reader) {
    return Profile(
      name: reader.readString(),
      age: reader.readString(),
      height: reader.readString(),
      weight: reader.readString(),
      dailyNutrientGoals: Map<String, String>.from(reader.readMap()), // Read new field
      nutrientDeficiencies: reader.readString(), // Read new field
      dietaryRestrictions: List<String>.from(reader.readList()), // Read new field
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.age);
    writer.writeString(obj.height);
    writer.writeString(obj.weight);
    writer.writeMap(obj.dailyNutrientGoals); // Write new field
    writer.writeString(obj.nutrientDeficiencies); // Write new field
    writer.writeList(obj.dietaryRestrictions); // Write new field
  }
}
