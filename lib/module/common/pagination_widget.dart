import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final bool canPaginate;

  const PaginationWidget({this.canPaginate = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return canPaginate
        ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
        )
        : Container();
  }
}
