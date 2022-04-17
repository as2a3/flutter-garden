import 'package:dartz/dartz.dart';
import 'package:garden/database/garden_database.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';

class DatabaseRepository {
  DatabaseRepository();

  late GardenDatabase database;

  Future<DatabaseRepository> init() async {
    database = await $FloorGardenDatabase.databaseBuilder('garden_database.db').build();
    final response = await getPlantTypes();
    response.fold((l) => null, (r) {
      if (r.isEmpty) {
        addPlantTypes();
      }
    });
    return this;
  }

  Future<void> addPlantTypes() async {
    await database.typeDAO.insertType([
      PlantType(name: 'alpines',),
      PlantType(name: 'aquatic',),
      PlantType(name: 'bulbs',),
      PlantType(name: 'succulents',),
      PlantType(name: 'carnivorous',),
      PlantType(name: 'climbers',),
      PlantType(name: 'ferns',),
      PlantType(name: 'grasses',),
      PlantType(name: 'trees',),
    ]);
  }

  Future<Either<String, bool>> deletePlant(int id) async {
    await database.plantsDAO.deletePlant(id);
    try {
      return const Right(true);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<PlantType>>> getPlantTypes() async {
    try {
      return Right(await database.typeDAO.retrieveAllTypes());
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, Plant>> getPlant(int plantId) async {
    try {
      final plant = await database.plantsDAO.getPlantById(plantId);
      if (plant == null) {
        return const Left('No Item');
      }
      final type = await getPlantType(plant.typeId);
      String error = '';
      type.fold((l) => error = l, (r) => plant.type = r,);
      if (error.isNotEmpty) {
        return Left(error);
      }
      return Right(plant);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<Plant>>> getAllPlants(int page) async {
    try {
      final plants = await database.plantsDAO.retrievePlants(page * 10);
      for(Plant plant in plants) {
        final type = await getPlantType(plant.typeId);
        String error = '';
        type.fold((l) => error = l, (r) => plant.type = r,);
        if (error.isNotEmpty) {
          return Left(error);
        }
      }
      return Right(plants);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, PlantType>> getPlantType(int id) async {
    try {
      final type = await database.typeDAO.getTypeById(id);
      if (type == null) {
        return const Left('No Item');
      }
      return Right(type);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<Plant>>> searchPlants(String key) async {
    try {
      final plants = await database.plantsDAO.searchPlants('%$key%');
      for(Plant plant in plants) {
        final type = await getPlantType(plant.typeId);
        String error = '';
        type.fold((l) => error = l, (r) => plant.type = r,);
        if (error.isNotEmpty) {
          return Left(error);
        }
      }
      return Right(plants);
    } catch (error) {
      return Left(error.toString());
    }
  }
}