import 'package:garden/common/state/bloc_state.dart';

class EmptyState extends BlocState {
  const EmptyState({this.message,});
  final String? message;
}
