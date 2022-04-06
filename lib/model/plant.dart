import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
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
  final String name;
  @ColumnInfo(name: 'planting_date')
  final int plantingDate;
  @ColumnInfo(name: 'type_id')
  final int typeId;
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

  Future<Map<String, Object?>> toMap(BuildContext? context) async {
    return {
      'id': id,
      'name': name,
      'planting_date': DateTime.fromMillisecondsSinceEpoch(plantingDate),
      'type_id': typeId,
    };
  }
}
