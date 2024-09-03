// ignore_for_file: use_build_context_synchronously

import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/presentation/controller/c_user.dart';

import '../../controller/c_history.dart';
import 'detail_history_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final cInOut = Get.put(CHistory());
  final cUser = Get.put(CUser());
  final controllerSearch = TextEditingController();

  refresh() {
    cInOut.getList(cUser.data.idUser);
  }

  delete(String idHistory) async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      "Hapus",
      "Yakin untuk menghapus history ini?",
      textNo: "Batal",
      textYes: "Ya",
    );

    if (yes != null && yes) {
      bool success = await SourceHistory.delete(context, idHistory);
      if (success) refresh();
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const Text("Riwayat"),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onTap: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (result != null) {
                      controllerSearch.text =
                          DateFormat("yyyy-MM-dd").format(result);
                    }
                  },
                  controller: controllerSearch,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColor.tint.withOpacity(0.5),
                    suffixIcon: IconButton(
                      onPressed: () {
                        cInOut.search(cUser.data.idUser, controllerSearch.text);
                      },
                      icon: const Icon(Icons.search, color: Colors.white),
                    ),
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    hintText: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            )
          ],
        ),
      ),
      body: GetBuilder<CHistory>(
        init: CHistory(),
        builder: (c) {
          if (c.loading) return DView.loadingCircle();
          if (c.list.isEmpty) return DView.empty("Kosong");
          return RefreshIndicator(
            onRefresh: () async => refresh(),
            child: ListView.builder(
              itemCount: c.list.length,
              itemBuilder: (context, index) {
                History history = c.list[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == c.list.length - 1 ? 16 : 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      Get.to(() => DetailHistoryPage(
                            idUser: cUser.data.idUser!,
                            date: history.date!,
                            type: history.type!,
                          ));
                    },
                    child: Row(
                      children: [
                        DView.width(),
                        history.type == "Pemasukan"
                            ? Icon(Icons.south_west, color: Colors.green[300])
                            : Icon(Icons.north_east, color: Colors.red[300]),
                        DView.width(),
                        Text(
                          AppFormat.date(history.date!),
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppFormat.currency(history.total!),
                            style: const TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        IconButton(
                          onPressed: () => delete(history.idHistory!),
                          icon: Icon(Icons.delete_forever,
                              color: Colors.red[300]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
