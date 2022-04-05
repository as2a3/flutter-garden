import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/counter/counter.dart';
import 'package:garden/counter/view/counter_page.dart';
import 'package:garden/home/cubit/home_cubit.dart';
import 'package:garden/home/view/home_view.dart';

class GardenApp extends StatelessWidget {
  const GardenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CounterCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (BuildContext context) => HomeCubit(),
        ),
      ],
      child: const MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        home: HomeView(),
        routes: {},
      ),
    );
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CounterCubit(),
          ),
          BlocProvider<HomeCubit>(
            create: (BuildContext context) => HomeCubit(),
          ),
          // BlocProvider<BlocC>(
          //   create: (BuildContext context) => BlocC(),
          // ),
        ],
        child: const HomeView(),
      ),
    );
  }
}

// class GardenApp extends MaterialApp {
//   const GardenApp({Key? key}) : super(key: key, home: const GardenPage(),);
// }
