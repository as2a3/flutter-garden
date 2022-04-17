import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/cubit/select_date_cubit.dart';
import 'package:garden/database/database_repository.dart';
import 'package:garden/module/home/cubit/type_cubit.dart';
import 'package:garden/module/home/bloc/home_bloc.dart';
import 'package:garden/module/home/view/home_view.dart';

class GardenApp extends StatelessWidget {
  const GardenApp({
    Key? key,
    required this.databaseRepository,
  }) : super(key: key);
  final DatabaseRepository databaseRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc(databaseRepository: databaseRepository),),
        BlocProvider(create: (_) => TypeCubit(databaseRepository: databaseRepository),),
        BlocProvider(create: (_) => SelectDateCubit(),),
      ],
      child: const MaterialApp(
        title: 'Garden App',
        debugShowCheckedModeBanner: false,
        home: HomeView(),
      ),
    );
  }
}
