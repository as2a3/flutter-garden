import 'package:flutter/material.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';
import 'package:intl/intl.dart';

typedef BoolCallBack = void Function(bool value);
typedef PlantCallback = void Function(Plant plant);
typedef PlantTypeCallback = void Function(PlantType plantType);
typedef StringCallback = void Function(String value);

String getTextInCorrectCustomFormat(String text) {
  if (text.length > 1) {
    final splitText = text.trim().split(' ');
    final buffer = StringBuffer('');
    
    for (final t in splitText) {
      if (t.length > 1) {
        buffer.write(' ${t.substring(0, 1).toUpperCase()}${t.substring(1).toLowerCase()}');
      } else {
        buffer.write(' ${t.toUpperCase()}');
      }
    }
    return buffer.toString();
  }
  return text.toUpperCase();
}

String getDateInCustomFormat(DateTime date, {String? format}) {
  return DateFormat(format ?? 'dd MMM yyyy').format(date);
}

void showAppSnackBar({required BuildContext context, String msg = '',}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

Future<DateTime> selectDate({
  required BuildContext context,
  DateTime? initial,
  DateTime? first,
  DateTime? last,
}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initial ?? DateTime.now(),
    firstDate: DateTime(1000),
    lastDate: last ?? DateTime(3000),
  );
  if (picked != null) {
    return picked;
  }
  return DateTime.now();
}