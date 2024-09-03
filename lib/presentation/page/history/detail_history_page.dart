import 'dart:convert';

import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/presentation/controller/c_detail_history.dart';

class DetailHistoryPage extends StatefulWidget {
  const DetailHistoryPage({
    super.key,
    required this.idUser,
    required this.date,
    required this.type,
  });

  final String idUser;
  final String date;
  final String type;

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final cDetailHistory = Get.put(CDetailHistory());

  @override
  void initState() {
    cDetailHistory.getData(widget.idUser, widget.date, widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(() {
          if (cDetailHistory.data.date == null) return DView.nothing();
          return Row(
            children: [
              Expanded(
                child: Text(
                  cDetailHistory.data.date == null
                      ? ''
                      : AppFormat.date(cDetailHistory.data.date!),
                ),
              ),
              cDetailHistory.data.type == "Pemasukan"
                  ? Icon(Icons.south_west, color: Colors.green[300], size: 26)
                  : Icon(Icons.north_east, color: Colors.red[300], size: 26),
              DView.width(),
            ],
          );
        }),
      ),
      body: GetBuilder<CDetailHistory>(
        init: CDetailHistory(),
        builder: (c) {
          if (c.data.date == null) {
            String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
            if (widget.date == today && widget.type == "Pengeluaran") {
              return DView.empty("Belum ada Pengeluaran");
            }
            return DView.nothing();
          }
          List details = jsonDecode(c.data.details!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Total",
                  style: TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Text(
                  AppFormat.currency(c.data.total!),
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              DView.height(20),
              Center(
                child: Container(
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColor.background,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              DView.height(20),
              Expanded(
                child: ListView.separated(
                  itemCount: details.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.black12,
                    thickness: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    Map item = details[index];
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            "${index + 1}.",
                            style: const TextStyle(fontSize: 20),
                          ),
                          DView.width(8),
                          Expanded(
                            child: Text(
                              item['name'],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Text(
                            AppFormat.currency(item['price']),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
