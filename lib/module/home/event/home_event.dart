import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:garden/model/plant.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class TextChanged extends HomeEvent {
  const TextChanged({required this.text});
  final String text;

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'TextChanged { text: $text }';
}

class GetPlantsEvent extends HomeEvent {
  const GetPlantsEvent();

  @override
  List<Object> get props => [];
}

class AddPlantEvent extends HomeEvent {
  const AddPlantEvent({this.context, required this.plant});
  final BuildContext? context;
  final Plant plant;

  @override
  List<Object> get props => [plant];

  @override
  String toString() => 'Add Plant { Plant: $plant }';
}

class EditPlantEvent extends HomeEvent {
  const EditPlantEvent({required this.context, required this.plant});
  final BuildContext context;
  final Plant plant;

  @override
  List<Object> get props => [plant];

  @override
  String toString() => 'Edit Plant { Plant: $plant }';
}

class DeletePlantEvent extends HomeEvent {
  const DeletePlantEvent({required this.context, required this.plant});
  final BuildContext context;
  final Plant plant;

  @override
  List<Object> get props => [plant];

  @override
  String toString() => 'Add Plant { Plant: $plant }';
}
