import 'package:bloc/bloc.dart';
import 'package:garden/database/garden_database.dart';
import 'package:garden/model/type.dart';

class DatabaseCubit extends Cubit<GardenDatabase?> {
  DatabaseCubit() : super(null) {
    initDatabase(addPlants: true,);
  }
  GardenDatabase? database;

  Future<void> initDatabase({bool addPlants = false,}) async {
    database = await $FloorGardenDatabase.databaseBuilder('garden_database.db').build();
    if (addPlants) {
      addPlantTypes();
    }
  }

  Future<void> addPlantTypes() async {
    final types = await database!.typeDAO.retrieveAllTypes();
    if (types.isEmpty) {
      await database!.typeDAO.insertType([
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
  }
}