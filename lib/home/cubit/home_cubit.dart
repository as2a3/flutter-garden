import 'package:bloc/bloc.dart';
import 'package:garden/model/plant.dart';

class HomeCubit extends Cubit<List<Plant>> {
  HomeCubit() : super(<Plant>[]);

  void increment(Plant? plant) {
    state.add(plant ?? Plant());
    emit(state);
  }

  void clear() {
    state.clear();
    emit(state);
  }
}
