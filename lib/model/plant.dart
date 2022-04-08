import 'package:floor/floor.dart';
import 'package:garden/model/type.dart';

@Entity(
  tableName: 'plant',
  foreignKeys: [
    ForeignKey(
      childColumns: ['type_id'],
      parentColumns: ['id'],
      onDelete: ForeignKeyAction.cascade,
      entity: PlantType,
    )
  ],
)
class Plant {
  @PrimaryKey(autoGenerate: true)
  int? id;
  late String name;
  @ColumnInfo(name: 'planting_date')
  late int plantingDate;
  @ColumnInfo(name: 'type_id')
  late int typeId;
  @ignore
  PlantType? type;

  Plant({
    this.id,
    required this.name,
    required this.plantingDate,
    required this.typeId,
    this.type,
  });

  Plant.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        plantingDate = res['planting_date'],
        typeId = res['typeId'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'planting_date': DateTime.fromMillisecondsSinceEpoch(plantingDate),
      'type_id': typeId,
    };
  }

  String get getTwoLetters {
    if (name.isEmpty) {
      return '';
    }
    if (name.length == 1) {
      return name.toUpperCase();
    }
    return '${name[0].toUpperCase()}${name[name.length - 1].toUpperCase()}';
  }
}
