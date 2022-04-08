import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/cubit/select_date_cubit.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/date_state.dart';
import 'package:garden/common/state/empty_state.dart';
import 'package:garden/common/state/loading_state.dart';
import 'package:garden/common/ui.dart';
import 'package:garden/common/widget/anim_search_bar_widget.dart';
import 'package:garden/common/widget/endless_list_view.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';
import 'package:garden/module/home/cubit/home_cubit.dart';
import 'package:garden/module/home/cubit/search_button_cubit.dart';
import 'package:garden/module/home/cubit/type_cubit.dart';
import 'package:garden/module/home/state/home_state.dart';
import 'package:garden/module/home/state/search_button_state.dart';
import 'package:garden/module/home/state/types_state.dart';
import 'package:garden/module/home/widget/plant_item_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().getMyPlants(context);
    final textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garden'),
        actions: [
          BlocConsumer<SearchButtonCubit, BlocState>(
            listener: (context, state) {
            },
            builder: (context, state) {
              if (state is SearchButtonState && state.isOpened) {
                return AnimSearchBar(
                  width: MediaQuery.of(context).size.width,
                  textController: textController,
                  color: Theme.of(context).primaryColor,
                  hintText: 'Write plant name',
                  autoFocus: true,
                  closeSearchOnSuffixTap: true,
                  isOpening: true,
                  style: TextStyle(color: Colors.white.withAlpha(175)),
                  hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                  onSuffixTap: () {
                    textController.clear();
                    context.read<HomeCubit>().refreshData(context);
                    context.read<SearchButtonCubit>().changeButtonState(false);
                  },
                  onChanged: (text) {
                    context.read<HomeCubit>().searchPlants(context, text);
                  },
                );
              }
              return IconButton(
                onPressed: () {
                  context.read<SearchButtonCubit>().changeButtonState(true);
                },
                icon: const Icon(Icons.search,),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeCubit>().refreshData(context);
        },
        child: BlocConsumer<HomeCubit, BlocState>(
          listener: (context, state) {
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is EmptyState) {
              return Center(
                child: Text(
                  state.message ?? 'There is no Plants in your Garden',
                ),
              );
            }
            if (state is HomeDataState) {
              print('AhmedLog ${state.plants.length}');
              return EndlessListView(
                length: state.plants.length,
                onScrollToEnd: () => context.read<HomeCubit>().getMyPlants(context),
                buildItemWidget: (index) {
                  return PlantItemWidget(
                    index: index,
                    items: state.plants,
                    canPaginate: state.canPaginate,
                    onDelete: (plant) => context.read<HomeCubit>().deletePlant(context, plant),
                    onItemClicked: (plant) => addOrEditPlantForm(
                      context: context,
                      plant: plant,
                      editPlant: (plant) {
                        context.read<HomeCubit>().editPlant(context, plant);
                      },
                    ),
                  );
                },
              );
            }
            return const Center(
              child: Text('Init'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addOrEditPlantForm(
            context: context,
            addPlant: (plant) {
            context.read<HomeCubit>().addPlant(context, plant);
            },
          );
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

  Future<void> addOrEditPlantForm({
    required BuildContext context,
    Plant? plant,
    PlantCallback? addPlant,
    PlantCallback? editPlant,
  }) async {
    context.read<TypeCubit>().getPlantTypes(context);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return await showDialog(context: context,
        builder: (context){
          final _textEditingController = TextEditingController();
          _textEditingController.text = plant != null ? plant.name : '';
          PlantType? selected = plant?.type;
          final newPlant = plant ?? Plant(
            name: '',
            plantingDate: DateTime.now().millisecondsSinceEpoch,
            typeId: -1,
          );

          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        plant != null ? 'Update Plant' : 'Add Plant',
                      ),
                    ),
                    const Divider(),
                    TextFormField(
                      controller: _textEditingController,
                      validator: (value){
                        return value!.isNotEmpty ? null : "Invalid name";
                      },
                      onChanged: (text) {
                        newPlant.name = text;
                      },
                      decoration: const InputDecoration(hintText: "Enter Plant name"),
                    ),
                    const SizedBox(height: 12,),
                    BlocConsumer<TypeCubit, BlocState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is TypesState) {
                          if (selected != null) {
                            selected = state.types.firstWhere((type) => type.id! == selected!.id!);
                          }
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
                              newPlant.typeId = value!.id!;
                              setState(() {
                                selected = value;
                              });
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    const SizedBox(height: 12,),
                    BlocConsumer<SelectDateCubit, BlocState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is DateState) {
                          newPlant.plantingDate = state.dateTime.millisecondsSinceEpoch;
                        }
                        return ListTile(
                          onTap: () => context.read<SelectDateCubit>().chooseDate(context),
                          leading: const Icon(Icons.access_time),
                          title: Text(
                            getDateInCustomFormat(
                                DateTime.fromMillisecondsSinceEpoch(newPlant.plantingDate),
                                format: 'dd MMM yyyy'
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if(_formKey.currentState!.validate() && selected != null) {
                      if (plant?.id != null) {
                        editPlant?.call(newPlant,);
                      } else {
                        addPlant?.call(newPlant,);
                      }
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
