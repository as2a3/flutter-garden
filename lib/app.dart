import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/counter/counter.dart';
import 'package:garden/module/common/db_cubit.dart';
import 'package:garden/module/home/cubit/home_cubit.dart';
import 'package:garden/route/app_pages.dart';
import 'package:garden/route/app_routes.dart';

class GardenApp extends StatelessWidget {
  const GardenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterCubit(),),
        BlocProvider(create: (_) => DatabaseCubit(),),
        BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.root,
        routes: routes,
      ),
    );
  }
}
