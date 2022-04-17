import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/date_state.dart';
import 'package:garden/common/state/init_state.dart';
import 'package:garden/common/ui.dart';

class SelectDateCubit extends Cubit<BlocState> {
  SelectDateCubit() : super(const InitState());

  Future<void> chooseDate(BuildContext context) async {
    emit(
      DateState(
        dateTime: await selectDate(context: context),
      ),
    );
  }
}
