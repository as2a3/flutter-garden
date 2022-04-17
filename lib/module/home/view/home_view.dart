import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden/common/cubit/select_date_cubit.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/date_state.dart';
import 'package:garden/common/ui.dart';
import 'package:garden/common/widget/endless_list_view.dart';
import 'package:garden/common/widget/pagination_widget.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';
import 'package:garden/module/home/cubit/type_cubit.dart';
import 'package:garden/module/home/state/types_state.dart';
import 'package:garden/module/home/bloc/home_bloc.dart';
import 'package:garden/module/home/event/home_event.dart';
import 'package:garden/module/home/state/home_state.dart';
import 'package:garden/module/home/widget/home_list_item_widget.dart';
import 'package:garden/module/home/widget/home_list_view_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeBloc _homeBloc = context.read<HomeBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Garden App')),
      body: Column(
        children: <Widget>[
          _SearchBar(homeBloc: _homeBloc,),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _homeBloc.refreshData();
              },
              child: _PageBody(homeBloc: _homeBloc,),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addOrEditPlantForm(
            context: context,
            addPlant: (plant) {
              _homeBloc.add(AddPlantEvent(context: context, plant: plant));
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
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({Key? key, required this.homeBloc,}):super(key: key);
  final HomeBloc homeBloc;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {

  final _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.homeBloc.add(const GetPlantsEvent());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        if (text.isEmpty) {
          _onClearTapped();
        } else {
          widget.homeBloc.add(
            TextChanged(text: text),
          );
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: _onClearTapped,
          child: const Icon(Icons.clear),
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    widget.homeBloc.refreshData();
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({Key? key, required this.homeBloc,}):super(key: key);
  final HomeBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (ctx, state) {
        if (state is SearchStateEmpty) {
          return const Center(child: Text('No Plants with this text'));
        }
        if (state is EmptyPlantState) {
          return const Center(child: Text('No Plants'));
        }
        if (state is SearchStateLoading) {
          return const CircularProgressIndicator();
        }
        if (state is ErrorState) {
          return Text(state.error);
        }
        if (state is SuccessState || state is BGLoading) {
          late final List<Plant> items;
          late final bool canPaginate;
          if (state is SuccessState) {
            items = state.items;
            canPaginate = state.canPaginate;
          } else if (state is BGLoading) {
            items = state.items;
            canPaginate = state.canPaginate;
          }
          return BuildListView(
            items: items,
            canPaginate: canPaginate,
            onScrollToEnd: () => homeBloc.add(const GetPlantsEvent()),
            onDelete: (plant) => homeBloc.add(DeletePlantEvent(context: context, plant: plant,)),
            onClicked: (plant) => addOrEditPlantForm(
              context: context,
              plant: plant,
              editPlant: (plant) => homeBloc.add(EditPlantEvent(context: context, plant: plant)),
            ),
          );
        }
        return const Text('Init');
      },
    );
  }
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