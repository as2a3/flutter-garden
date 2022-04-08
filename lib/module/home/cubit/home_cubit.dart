import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/empty_state.dart';
import 'package:garden/common/state/init_state.dart';
import 'package:garden/common/state/loading_state.dart';
import 'package:garden/common/ui.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/repository/db_repository.dart';
import 'package:garden/module/home/state/home_state.dart';

class HomeCubit extends Cubit<BlocState> {
  HomeCubit() : super(const InitState());

  List<Plant> plants = <Plant>[];
  int page = 0;
  bool canPaginate = false;

  Future<void> refreshData(BuildContext context) async {
    page = 0;
    await getMyPlants(context);
  }

  Future<void> getMyPlants(BuildContext context) async {
    if (page == 0) {
      emit(const LoadingState());
    }
    if (page != 0 && !canPaginate) {
      return;
    }
    if (context.read<DatabaseRepository>().database == null) {
      await context.read<DatabaseRepository>().initDatabase();
    }
    final response = await context.read<DatabaseRepository>().getAllPlants(page);
    response.fold((error) {
    }, (list) {
      if (page == 0 && list.isEmpty) {
        emit(const EmptyState());
        return;
      }
      else if (page == 0 && list.length < 10) {
        plants = list;
        canPaginate = false;
      }
      else if(list.length < 10) {
        plants.addAll(list);
        canPaginate = false;
      }
      else {
        plants = list;
        canPaginate = true;
      }
      page++;
      emit(
        HomeDataState(
          plants: plants,
          canPaginate: canPaginate,
        ),
      );
    },);
  }

  Future<void> addPlant(BuildContext context, Plant newPlant) async {
    final id = await context.read<DatabaseRepository>()
        .database!
        .plantsDAO
        .insertPlant(newPlant);

    final response = await context.read<DatabaseRepository>().getPlant(id);
    response.fold(
      (l) => null,
      (plant) {
        plants.add(plant);
        showAppSnackBar(context: context, msg: 'Plant ${newPlant.name} is added.');
        emit(
          HomeDataState(
            plants: plants,
            canPaginate: canPaginate,
          ),
        );
      },
    );
  }

  Future<void> editPlant(BuildContext context, Plant plant) async {
    await context.read<DatabaseRepository>()
        .database!
        .plantsDAO
        .editPlant(plant);

    final response = await context.read<DatabaseRepository>().getPlant(plant.id!);
    response.fold(
          (l) => null,
          (plant) {
        final index = plants.indexOf(plants.firstWhere((item) => item.id! == plant.id!));
        plants[index] = plant;
        showAppSnackBar(context: context, msg: 'Plant ${plant.name} is updated.');
        emit(
          HomeDataState(
            plants: plants,
            canPaginate: canPaginate,
          ),
        );
      },
    );
  }

  Future<void> deletePlant(BuildContext context, Plant plant) async {
    final result = await context.read<DatabaseRepository>().deletePlant(plant.id!);
    result.fold((l) => null, (r) {
      plants.remove(plant);
      if (plants.isEmpty) {
        emit(const EmptyState());
      } else {
        emit(
          HomeDataState(
            plants: plants,
            canPaginate: canPaginate,
          ),
        );
      }
    },);
  }

  Future<void> searchPlants(BuildContext context, String key) async {
    emit(const LoadingState());
    if (context.read<DatabaseRepository>().database == null) {
      await context.read<DatabaseRepository>().initDatabase();
    }
    final response = await context.read<DatabaseRepository>().searchPlants(key);
    response.fold((error) {
    }, (list) {
      if (list.isEmpty) {
        emit(const EmptyState(message: 'There is no plants contains this letter',));
      } else {
        plants = list;
        canPaginate = false;
        emit(
          HomeDataState(
            plants: plants,
            canPaginate: canPaginate,
          ),
        );
      }
    },);
  }
}
