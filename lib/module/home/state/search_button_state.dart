import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';

class SearchButtonState extends BlocState {
  final bool isOpened;
  SearchButtonState({
    required this.isOpened,
  });
}
