import 'package:flutter/material.dart';
import 'package:garden/app.dart';
import 'package:garden/database/database_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbRepository = await DatabaseRepository().init();
  runApp(
    GardenApp(
      databaseRepository: dbRepository,
    ),
  );
}
