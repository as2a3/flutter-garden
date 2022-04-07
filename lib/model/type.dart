import 'package:floor/floor.dart';

@Entity(tableName: 'type',)
class PlantType {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String name;

  PlantType({
    this.id,
    required this.name,
  });

  PlantType.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
