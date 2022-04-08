import 'package:garden/common/state/bloc_state.dart';

class DateState extends BlocState {
  final DateTime dateTime;
  DateState({
    required this.dateTime,
  });
}
