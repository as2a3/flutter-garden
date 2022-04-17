import 'package:bloc/bloc.dart';
import 'package:garden/common/ui.dart';
import 'package:garden/database/database_repository.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/module/home/event/home_event.dart';
import 'package:garden/module/home/state/home_state.dart';
import 'package:stream_transform/stream_transform.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.databaseRepository})
      : super(SearchStateEmpty()) {
    on<GetPlantsEvent>(_getMyPlants);
    on<AddPlantEvent>(_addPlant);
    on<EditPlantEvent>(_editPlant);
    on<DeletePlantEvent>(_deletePlant);
    on<TextChanged>(_onTextChanged, transformer: debounce(_duration));
  }
  final DatabaseRepository databaseRepository;

  List<Plant> plants = <Plant>[];
  int page = 0;
  bool canPaginate = false;

  Future<void> refreshData() async {
    page = 0;
    add(const GetPlantsEvent());
  }

  void _onTextChanged(
      TextChanged event,
      Emitter<HomeState> emit,
      ) async {
    final searchTerm = event.text;
    if (searchTerm.isEmpty) return emit(SearchStateEmpty());
    emit(SearchStateLoading());
    try {
      final results = await databaseRepository.searchPlants(searchTerm);
      results.fold((l) => emit(ErrorState(l)), (r) {
        if (r.isEmpty) {
          emit(SearchStateEmpty());
        } else {
          emit(SuccessState(items: r, canPaginate: false));
        }
        },
      );
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  Future<void> _getMyPlants(
      GetPlantsEvent event,
      Emitter<HomeState> emit,
      ) async {
    if (page == 0) {
      emit(SearchStateLoading());
    } else {
      emit(BGLoading(items: plants, canPaginate: canPaginate,));
    }
    if (page != 0 && !canPaginate) {
      return;
    }
    final response = await databaseRepository.getAllPlants(page);
    response.fold((error) {
    }, (list) {
      if (page == 0 && list.isEmpty) {
        emit(EmptyPlantState());
        return;
      }
      else if (page == 0 && list.length < 10) {
        plants = list;
        canPaginate = false;
      }
      else if(list.length < 10) {
        plants.addAll(list);
        canPaginate = false;
      }
      else {
        plants = list;
        canPaginate = true;
      }
      page++;
      emit(
        SuccessState(items: plants, canPaginate: canPaginate,),
      );
    },);
  }

  Future<void> _addPlant(
      AddPlantEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(SearchStateLoading());
    final id = await databaseRepository.database.plantsDAO.insertPlant(
      event.plant,
    );

    final response = await databaseRepository.getPlant(id);
    response.fold(
          (l) => null,
          (plant) {
        plants.add(plant);
        showAppSnackBar(context: event.context, msg: 'Plant ${plant.name} is added.',);
        emit(
          SuccessState(
            items: plants,
            canPaginate: canPaginate,
          ),
        );
      },
    );
  }

  Future<void> _editPlant(
      EditPlantEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(SearchStateLoading());
    await databaseRepository.database.plantsDAO.editPlant(event.plant);
    final response = await databaseRepository.getPlant(event.plant.id!);
    response.fold(
          (l) => emit(ErrorState(l)),
          (plant) {
        final index = plants.indexOf(plants.firstWhere((item) => item.id! == plant.id!));
        plants[index] = plant;
        showAppSnackBar(context: event.context, msg: 'Plant ${plant.name} is updated.',);
        emit(
          SuccessState(
            items: plants,
            canPaginate: canPaginate,
          ),
        );
      },
    );
  }

  Future<void> _deletePlant(
      DeletePlantEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(SearchStateLoading());
    final result = await databaseRepository.deletePlant(event.plant.id!);
    result.fold((l) => null, (r) {
      plants.remove(event.plant);
      showAppSnackBar(context: event.context, msg: 'Plant ${event.plant.name} is deleted.',);
      if (plants.isEmpty) {
        emit(SearchStateEmpty());
      } else {
        emit(
          SuccessState(
            items: plants,
            canPaginate: canPaginate,
          ),
        );
      }
    },);
  }
}