import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/counter/cubit/counter_cubit.dart';
import 'package:garden/counter/view/counter_view.dart';
import 'package:garden/module/home/cubit/home_cubit.dart';

class GardenPage extends StatelessWidget {
  const GardenPage({Key? key}) : super(key: key);

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
        // BlocProvider<BlocC>(
        //   create: (BuildContext context) => BlocC(),
        // ),
      ],
      child: const CounterView(),
    );

    // return BlocProvider(
    //   create: (_) => CounterCubit(),
    //   child: CounterView(),
    // );
  }
}