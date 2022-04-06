import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/module/common/endless_list_view.dart';
import 'package:garden/module/home/cubit/home_cubit.dart';
import 'package:garden/module/home/state/home_state.dart';
import 'package:garden/module/home/widget/plant_item_widget.dart';
import 'package:garden/state/bloc_state.dart';
import 'package:garden/state/empty_state.dart';
import 'package:garden/state/init_state.dart';
import 'package:garden/state/loading_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().getMyPlants(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garden'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search),),
        ],
      ),
      body: BlocConsumer<HomeCubit, BlocState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EmptyState) {
            return const Center(
              child: Text('There is no Plants in your Garden'),
            );
          }
          if (state is HomeDataState) {
            return EndlessListView(
              length: state.plants.length,
              onScrollToEnd: () => context.read<HomeCubit>().getMyPlants(context),
              buildItemWidget: (index) {
                return PlantItemWidget(
                  index: index,
                  items: state.plants,
                  canPaginate: state.canPaginate,
                );
              },
            );
          }
          return const Center(
            child: Text('Init'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<HomeCubit>().addPlant(context, null);
        },
        label: Row (
          children: const [
            Icon(Icons.add),
            SizedBox(width: 12,),
            Text('Add Plant'),
          ],
        ),
      ),
    );
  }
}
