import 'package:floor/floor.dart';
import 'package:garden/model/type.dart';

@dao
abstract class TypeDAO {
  @insert
  Future<List<int>> insertType(List<PlantType> types);

  @Query('SELECT * FROM type')
  Future<List<PlantType>> retrieveAllTypes();

  @Query('SELECT * FROM type WHERE id = :id')
  Future<PlantType?> getTypeById(int id);

  @Query('SELECT * FROM type WHERE name = :name')
  Future<List<PlantType>> retrieveTypesByName(String name);
}