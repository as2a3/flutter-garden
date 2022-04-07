import 'package:garden/common/state/bloc_state.dart';

class ErrorState extends BlocState {
  const ErrorState({
    required this.message,
    required this.errorCode,
  });

  final int errorCode;
  final String message;
}
