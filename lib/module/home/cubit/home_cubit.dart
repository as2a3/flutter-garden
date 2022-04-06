import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/module/common/db_cubit.dart';
import 'package:garden/module/home/state/home_state.dart';
import 'package:garden/state/bloc_state.dart';
import 'package:garden/state/empty_state.dart';
import 'package:garden/state/init_state.dart';
import 'package:garden/state/loading_state.dart';

class HomeCubit extends Cubit<BlocState> {
  HomeCubit() : super(const InitState());

  List<Plant> plants = <Plant>[];
  int page = 0;
  bool canPaginate = false;

  Future<void> getMyPlants(BuildContext context) async {
    emit(const LoadingState());
    if (context.read<DatabaseCubit>().database == null) {
      await context.read<DatabaseCubit>().initDatabase();
    }
    final list = await context.read<DatabaseCubit>().database!.plantsDAO.retrievePlants(page);
    if (page == 0) {
      if (list.isEmpty) {
        emit(const EmptyState());
      } else if (list.length < 10) {
        plants = list;
        canPaginate = false;
        emit(
          HomeDataState(
            plants: plants,
            canPaginate: canPaginate,
          ),
        );
      } else {
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
  }

  Future<void> addPlant(BuildContext context, Plant? plant) async {
    final id = await context.read<DatabaseCubit>().database!.plantsDAO.insertPlant(
      Plant(
        typeId: 2,
        name: 'Test 1',
        plantingDate: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    final plant = await context.read<DatabaseCubit>().database!.plantsDAO.getPlantById(id);
    if (plant != null) {
      plants.add(plant);
    }

    emit(
      HomeDataState(
        plants: plants,
        canPaginate: canPaginate,
      ),
    );
  }
}
