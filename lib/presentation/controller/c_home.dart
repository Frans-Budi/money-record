import 'package:get/get.dart';
import 'package:money_record/data/source/source_history.dart';

class CHome extends GetxController {
  final RxDouble _today = 0.0.obs;
  double get today => _today.value;

  final RxString _todayPercent = "".obs;
  String get todayPercent => _todayPercent.value;

  final RxList<double> _week = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  List<double> get week => _week;

  List<String> get days => ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
  List<String> weekText() {
    DateTime today = DateTime.now();
    return [
      days[today.subtract(const Duration(days: 6)).weekday - 1],
      days[today.subtract(const Duration(days: 5)).weekday - 1],
      days[today.subtract(const Duration(days: 4)).weekday - 1],
      days[today.subtract(const Duration(days: 3)).weekday - 1],
      days[today.subtract(const Duration(days: 2)).weekday - 1],
      days[today.subtract(const Duration(days: 1)).weekday - 1],
      days[today.weekday - 1],
    ];
  }

  final RxDouble _monthIncome = 0.0.obs;
  double get monthIncome => _monthIncome.value;

  final RxDouble _monthOutcome = 0.0.obs;
  double get monthOutcome => _monthOutcome.value;

  final RxString _percentIncome = "".obs;
  String get percentIncome => _percentIncome.value;

  final RxString _monthPercent = "".obs;
  String get monthPercent => _monthPercent.value;

  final RxDouble _differentMonth = 0.0.obs;
  double get differentMonth => _differentMonth.value;

  getAnalysis(String idUser) async {
    Map data = await SourceHistory.analysis(idUser);

    //today outcome
    _today.value = (data['today'] as int).toDouble();
    double yesterday = (data['yesterday'] as int).toDouble();
    double different = (today - yesterday).abs();

    bool isSame = today.isEqual(yesterday);
    bool isPlus = today.isGreaterThan(yesterday);

    double dividerToday = (today + yesterday) == 0 ? 1 : (today + yesterday);
    double percent = (different / dividerToday) * 100;
    _todayPercent.value = isSame
        ? "100% sama dengan kemarin"
        : isPlus
            ? "+${percent.toStringAsFixed(1)}% dibandingkan kemarin"
            : "-${percent.toStringAsFixed(1)}% dibandingkan kemarin";

    _week.value =
        (data['week'] as List).map((item) => (item as int).toDouble()).toList();

    _monthIncome.value = (data['month']['income'] as int).toDouble();
    _monthOutcome.value = (data['month']['outcome'] as int).toDouble();

    _differentMonth.value = (monthIncome - monthOutcome).abs();

    bool isSameMonth = monthIncome.isEqual(monthOutcome);
    bool isPlusMonth = monthIncome.isGreaterThan(monthOutcome);

    double dividerMonth =
        (monthIncome + monthOutcome) == 0 ? 1 : (monthIncome + monthOutcome);
    double percentMonth = (differentMonth / dividerMonth) * 100;
    _percentIncome.value = percentMonth.toStringAsFixed(1);
    _monthPercent.value = isSameMonth
        ? "Pemasukan\n100% sama\ndengan Pengeluaran"
        : isPlusMonth
            ? "Pemasukan\nlebih besar $percentIncome%\ndari pada Pengeluaran"
            : "Pemasukan\nlebih kecil $percentIncome%\ndari pada Pengeluaran";
  }
}
