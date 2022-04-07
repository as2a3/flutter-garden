import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';
import 'package:intl/intl.dart';

typedef PlantCallback = void Function(Plant plant);
typedef PlantTypeCallback = void Function(PlantType plantType);

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
  return DateFormat(format ?? 'yyyy MMM dd HH:mm').format(date);
}