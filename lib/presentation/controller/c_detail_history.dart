import 'package:get/get.dart';
import 'package:money_record/data/source/source_history.dart';

import '../../data/model/history.dart';

class CDetailHistory extends GetxController {
  final Rx<History> _data = History().obs;
  History get data => _data.value;

  getData(idUser, date, type) async {
    History? history = await SourceHistory.detail(idUser, date, type);
    _data.value = history ?? History();
    update();
  }
}
