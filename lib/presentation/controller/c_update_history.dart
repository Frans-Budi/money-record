import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/data/source/source_history.dart';

import '../../data/model/history.dart';

class CUpdateHistory extends GetxController {
  final RxString _date = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  String get date => _date.value;
  setDate(item) => _date.value = item;

  final RxString _type = "Pemasukan".obs;
  String get type => _type.value;
  setType(item) => _type.value = item;

  final RxList _items = [].obs;
  List get items => _items;
  addItem(item) {
    _items.add(item);
    count();
  }

  delete(index) {
    _items.removeAt(index);
    count();
  }

  final RxDouble _total = 0.0.obs;
  double get total => _total.value;

  count() {
    _total.value = items.map((item) => item['price']).toList().fold<double>(
        0.0, (previousValue, element) => previousValue + double.parse(element));

    update();
  }

  init(idUser, date) async {
    History? history = await SourceHistory.whereDate(idUser, date);
    if (history != null) {
      setDate(history.date);
      setType(history.type);
      _items.value = jsonDecode(history.details!);
      count();
    }
  }
}
