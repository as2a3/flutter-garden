import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:garden/app.dart';
import 'package:garden/garden_bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(
      const GardenApp(),
    ),
    blocObserver: GardenBlocObserver(),
  );
}
