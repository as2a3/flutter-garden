import 'package:flutter/material.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/module/common/pagination_widget.dart';

class PlantItemWidget extends StatelessWidget {
  const PlantItemWidget({
    Key? key,
    this.index = 0,
    this.canPaginate = true,
    required this.items,
  }) : super(key: key);
  final int index;
  final bool canPaginate;
  final List<Plant> items;

  @override
  Widget build(BuildContext context) {
    return index == items.length
        ? PaginationWidget(
            canPaginate: canPaginate,
          )
        : Container(
            decoration: const BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              top: index == 0 ? 16 : 0,
              bottom: 16,
            ),
            child: ListTile(
              title: Text(
                'ID:${items[index].id}, Name: ${items[index].name}, TypeId: ${items[index].typeId}',
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {},
            ),
          );
  }
}
