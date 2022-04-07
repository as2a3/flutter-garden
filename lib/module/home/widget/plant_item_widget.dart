import 'package:flutter/material.dart';
import 'package:garden/common/ui.dart';
import 'package:garden/common/widget/pagination_widget.dart';
import 'package:garden/model/plant.dart';

class PlantItemWidget extends StatelessWidget {
  const PlantItemWidget({
    Key? key,
    this.index = 0,
    this.canPaginate = true,
    required this.items,
    this.onDelete,
  }) : super(key: key);
  final int index;
  final bool canPaginate;
  final List<Plant> items;
  final PlantCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return index == items.length
        ? PaginationWidget(
            canPaginate: canPaginate,
          )
        : Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(6, 6),
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: index == 0 ? 16 : 0,
                  bottom: 16,
                ),
                padding: const EdgeInsets.all(
                  12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                            4,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Text(items[index].getTwoLetters),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTextInCorrectCustomFormat(items[index].name),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              getTextInCorrectCustomFormat(
                                  items[index].type?.name ?? ''),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              getDateInCustomFormat(
                                DateTime.fromMillisecondsSinceEpoch(
                                    items[index].plantingDate),
                                format: 'hh:mm a',
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              getDateInCustomFormat(
                                DateTime.fromMillisecondsSinceEpoch(
                                    items[index].plantingDate),
                                format: 'yyyy MMM dd',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(
                    top: index == 0 ? 8 : 0,
                    right: 4,
                  ),
                  padding: const EdgeInsets.all(
                    4,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => onDelete?.call(items[index]),
                    child: const Icon(Icons.delete,),
                  ),
                ),
              ),
            ],
          );
  }
}
