import 'package:floor/floor.dart';
import 'package:garden/model/plant.dart';

@dao
abstract class PlantDAO {
  @insert
  Future<List<int>> insertPlants(List<Plant> plants);

  @insert
  Future<int> insertPlant(Plant plant);

  @Query('SELECT * FROM plant WHERE id = :id')
  Future<Plant?> getPlantById(int id);

  @Query('SELECT * FROM plant LIMIT 10 OFFSET :page')
  Future<List<Plant>> retrievePlants(int page);

  @Query('DELETE FROM plant WHERE id = :id')
  Future<Plant?> deleteUser(int id);
}
