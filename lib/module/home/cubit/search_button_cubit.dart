import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/init_state.dart';
import 'package:garden/module/home/state/search_button_state.dart';
import 'package:garden/module/home/state/types_state.dart';
import 'package:garden/repository/db_repository.dart';

class SearchButtonCubit extends Cubit<BlocState> {
  SearchButtonCubit() : super(const InitState());

  Future<void> changeButtonState(bool state) async {
    emit(
      SearchButtonState(
        isOpened: state,
      ),
    );
  }
}
