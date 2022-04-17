import 'package:equatable/equatable.dart';
import 'package:garden/model/plant.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends HomeState {}

class SearchStateLoading extends HomeState {}

class BGLoading extends HomeState {
  const BGLoading({
    required this.items,
    this.canPaginate = true,
  });

  final List<Plant> items;
  final bool canPaginate;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: $items }';
}

class EmptyPlantState extends HomeState {}

class SuccessState extends HomeState {
  const SuccessState({
    required this.items,
    this.canPaginate = true,
  });

  final List<Plant> items;
  final bool canPaginate;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: $items }';
}

class ErrorState extends HomeState {
  const ErrorState(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

// class GetPlantTypesState extends HomeState {
//   const GetPlantTypesState({
//     required this.items,
//   });
//   final List<PlantType> items;
//
//   @override
//   List<Object> get props => [items];
//
//   @override
//   String toString() => 'GetPlantTypesState { items: $items} }';
// }

