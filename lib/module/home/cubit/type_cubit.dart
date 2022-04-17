import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/init_state.dart';
import 'package:garden/database/database_repository.dart';
import 'package:garden/module/home/state/types_state.dart';

class TypeCubit extends Cubit<BlocState> {
  TypeCubit({required this.databaseRepository,}) : super(const InitState());
  final DatabaseRepository databaseRepository;

  Future<void> getPlantTypes(BuildContext context) async {
    final response = await databaseRepository.getPlantTypes();
    response.fold((error) {}, (list) {
      emit(
        TypesState(
          types: list,
        ),
      );
    },);
  }
}
