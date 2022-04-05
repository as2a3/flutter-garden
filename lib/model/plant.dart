import 'package:garden/model/type.dart';

class Plant {
  late String id;
  late String name;
  late Type type;

  Plant({this.id = '', this.name = '', Type? type,}) {
    this.type = type ?? Type(id: '', name: '',);
  }
}
