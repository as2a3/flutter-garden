import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/init_state.dart';
import 'package:garden/module/home/state/types_state.dart';
import 'package:garden/repository/db_repository.dart';

class TypeCubit extends Cubit<BlocState> {
  TypeCubit() : super(const InitState());

  Future<void> getPlantTypes(BuildContext context) async {
    final response = await context.read<DatabaseRepository>().getPlantTypes();
    response.fold((error) {}, (list) {
      emit(
        TypesState(
          types: list,
        ),
      );
    },);
  }
}
