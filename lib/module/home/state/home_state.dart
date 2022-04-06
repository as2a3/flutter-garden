import 'package:garden/model/plant.dart';
import 'package:garden/state/bloc_state.dart';

class HomeDataState extends BlocState {
  final List<Plant> plants;
  final bool canPaginate;
  HomeDataState({
    required this.plants,
    this.canPaginate = true,
  });
}
