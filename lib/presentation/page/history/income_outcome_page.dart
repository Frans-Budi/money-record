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
import 'package:money_record/presentation/controller/c_income_outcome.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:money_record/presentation/page/history/update_history_page.dart';

import 'detail_history_page.dart';

class IncomeOutcomePage extends StatefulWidget {
  final String type;

  const IncomeOutcomePage({
    super.key,
    required this.type,
  });

  @override
  State<IncomeOutcomePage> createState() => _IncomeOutcomePageState();
}

class _IncomeOutcomePageState extends State<IncomeOutcomePage> {
  final cInOut = Get.put(CIncomeOutcome());
  final cUser = Get.put(CUser());
  final controllerSearch = TextEditingController();

  refresh() {
    cInOut.getList(cUser.data.idUser, widget.type);
  }

  menuOption(String value, History history) async {
    if (value == "update") {
      Get.to(() => UpdateHisotryPage(
            date: history.date!,
            idHistory: history.idHistory!,
          ))?.then((value) {
        if (value ?? false) {
          refresh();
        }
      });
    } else if (value == "delete") {
      bool? yes = await DInfo.dialogConfirmation(
        context,
        "Hapus",
        "Yakin untuk menghapus history ini?",
        textNo: "Batal",
        textYes: "Ya",
      );

      if (yes != null && yes) {
        bool success = await SourceHistory.delete(context, history.idHistory!);
        if (success) refresh();
      }
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
            Text(widget.type),
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
                        cInOut.search(cUser.data.idUser, widget.type,
                            controllerSearch.text);
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
      body: GetBuilder<CIncomeOutcome>(
        init: CIncomeOutcome(),
        initState: (_) {},
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
                        PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: "update", child: Text("Update")),
                            const PopupMenuItem(
                                value: "delete", child: Text("Delete")),
                          ],
                          onSelected: (value) => menuOption(value, history),
                          icon: const Icon(Icons.more_vert),
                        )
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
