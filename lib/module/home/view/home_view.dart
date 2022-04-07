import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/empty_state.dart';
import 'package:garden/common/state/loading_state.dart';
import 'package:garden/common/widget/endless_list_view.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';
import 'package:garden/module/home/cubit/home_cubit.dart';
import 'package:garden/module/home/cubit/type_cubit.dart';
import 'package:garden/module/home/state/home_state.dart';
import 'package:garden/module/home/state/types_state.dart';
import 'package:garden/module/home/widget/plant_item_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
                  onDelete: (plant) => context.read<HomeCubit>().deletePlant(context, plant),
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
          context.read<TypeCubit>().getPlantTypes(context);
          showInformationDialog(context, (plant) {
            context.read<HomeCubit>().addPlant(context, plant);
          },);
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

  Future<void> showInformationDialog(BuildContext context, Function(Plant) addPlant) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return await showDialog(context: context,
        builder: (context){
          final _textEditingController = TextEditingController();
          PlantType? selected;
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value){
                          return value!.isNotEmpty ? null : "Invalid name";
                        },
                        decoration: const InputDecoration(hintText: "Enter Plant name"),
                      ),
                      BlocConsumer<TypeCubit, BlocState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is TypesState) {
                            return DropdownButton<PlantType>(
                              value: selected,
                              hint: const Text('Select Type'),
                              isExpanded: true,
                              items: state.types.map((PlantType value) {
                                return DropdownMenuItem<PlantType>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                // selected = value;
                                setState(() {
                                  selected = value;
                                });
                              },
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: const Text('Okay'),
                  onPressed: (){
                    if(_formKey.currentState!.validate() && selected != null){
                      addPlant.call(
                        Plant(
                          name: _textEditingController.text,
                          plantingDate: DateTime.now().millisecondsSinceEpoch,
                          typeId: selected!.id!,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }
}
