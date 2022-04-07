import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';

class TypesState extends BlocState {
  final List<PlantType> types;
  TypesState({
    required this.types,
  });
}
