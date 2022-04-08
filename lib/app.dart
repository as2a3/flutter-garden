import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/module/home/cubit/search_button_cubit.dart';
import 'package:garden/common/cubit/select_date_cubit.dart';
import 'package:garden/module/home/cubit/type_cubit.dart';
import 'package:garden/repository/db_repository.dart';
import 'package:garden/module/home/cubit/home_cubit.dart';
import 'package:garden/route/app_pages.dart';
import 'package:garden/route/app_routes.dart';

class GardenApp extends StatelessWidget {
  const GardenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DatabaseRepository(),),
        BlocProvider(create: (BuildContext context) => HomeCubit(),),
        BlocProvider(create: (BuildContext context) => TypeCubit(),),
        BlocProvider(create: (BuildContext context) => SearchButtonCubit(),),
        BlocProvider(create: (BuildContext context) => SelectDateCubit(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.root,
        routes: routes,
      ),
    );
  }
}
