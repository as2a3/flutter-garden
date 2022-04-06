import 'dart:async';
import 'package:floor/floor.dart';
import 'package:garden/database/dao/plant_dao.dart';
import 'package:garden/database/dao/type_dao.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'garden_database.g.dart';

@Database(version: 1, entities: [Plant, PlantType])
abstract class GardenDatabase extends FloorDatabase {
  PlantDAO get plantsDAO;
  TypeDAO get typeDAO;
}