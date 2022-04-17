import 'package:flutter/material.dart';
import 'package:garden/common/ui.dart';
import 'package:garden/common/widget/endless_list_view.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/module/home/widget/home_list_item_widget.dart';

class BuildListView extends StatelessWidget {
  const BuildListView({
    Key? key,
    required this.items,
    this.canPaginate = true,
    this.onScrollToEnd,
    this.onDelete,
    this.onClicked,
  }) : super(key: key);

  final List<Plant> items;
  final bool canPaginate;
  final VoidCallback? onScrollToEnd;
  final PlantCallback? onDelete;
  final PlantCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    return EndlessListView(
      length: items.length,
      onScrollToEnd: onScrollToEnd?.call,
      buildItemWidget: (index) {
        return PlantItemWidget(
          index: index,
          items: items,
          canPaginate: canPaginate,
          onDelete: (plant) => onDelete?.call(plant),
          onItemClicked: (plant) => onClicked?.call(plant),
        );
      },
    );
  }
}