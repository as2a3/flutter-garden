import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/empty_state.dart';
import 'package:garden/common/state/init_state.dart';
import 'package:garden/common/state/loading_state.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/module/home/state/types_state.dart';
import 'package:garden/repository/db_repository.dart';
import 'package:garden/module/home/state/home_state.dart';

class HomeCubit extends Cubit<BlocState> {
  HomeCubit() : super(const InitState());

  List<Plant> plants = <Plant>[];
  int page = 0;
  bool canPaginate = false;

  Future<void> getMyPlants(BuildContext context) async {
    emit(const LoadingState());
    if (context.read<DatabaseRepository>().database == null) {
      await context.read<DatabaseRepository>().initDatabase();
    }
    final response = await context.read<DatabaseRepository>().getAllPlants(page);
    response.fold((error) {

    }, (list) {
      if (page == 0) {
        if (list.isEmpty) {
          emit(const EmptyState());
        }
        else if (list.length < 10) {
          plants = list;
          canPaginate = false;
          emit(
            HomeDataState(
              plants: plants,
              canPaginate: canPaginate,
            ),
          );
        }
        else {
          plants = list;
          page++;
          canPaginate = true;
          emit(
            HomeDataState(
              plants: plants,
              canPaginate: canPaginate,
            ),
          );
        }
      }
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
      emit(
        HomeDataState(
          plants: plants,
          canPaginate: canPaginate,
        ),
      );
    },);
  }
}
