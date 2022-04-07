import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/model/plant.dart';

class HomeDataState extends BlocState {
  final List<Plant> plants;
  final bool canPaginate;
  HomeDataState({
    required this.plants,
    this.canPaginate = true,
  });
}
