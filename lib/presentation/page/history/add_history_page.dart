import 'dart:convert';

import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/presentation/controller/c_add_history.dart';
import 'package:money_record/presentation/controller/c_user.dart';

class AddHistoryPage extends StatelessWidget {
  const AddHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cAddHistory = Get.put(CAddHistory());
    final cUser = Get.put(CUser());

    final controllerName = TextEditingController();
    final controllerPrice = TextEditingController();

    addHistory() async {
      bool success = await SourceHistory.add(
        context,
        cUser.data.idUser!,
        cAddHistory.date,
        cAddHistory.type,
        jsonEncode(cAddHistory.items),
        cAddHistory.total.toString(),
      );

      if (success) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          Get.back(result: true);
        });
      }
    }

    return Scaffold(
      appBar: DView.appBarLeft("Tambah Baru"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //secation date
          const Text(
            "Tanggal",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Obx(() {
                return Text(
                  cAddHistory.date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
              DView.width(),
              ElevatedButton.icon(
                onPressed: () async {
                  DateTime? result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(cAddHistory.date),
                    firstDate: DateTime(2024, 01, 01),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (result != null) {
                    cAddHistory
                        .setDate(DateFormat("yyyy-MM-dd").format(result));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  iconColor: Colors.white,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                icon: const Icon(Icons.event),
                label: const Text("Pilh"),
              ),
            ],
          ),
          DView.height(),
          //section Type
          const Text(
            "Tipe",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DView.height(4),
          Obx(() {
            return DropdownButtonFormField(
              value: cAddHistory.type,
              items: ["Pemasukan", "Pengeluaran"].map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: (value) {
                cAddHistory.setType(value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            );
          }),
          DView.height(),
          //section sale
          DInput(
            controller: controllerName,
            hint: "Isi judul pengeluan Kamu!",
            title: "Sumber/Object Pengeluaran",
          ),
          DView.height(),
          //section price
          DInput(
            controller: controllerPrice,
            hint: "Isi harga pengeluaran tersebut!",
            title: "Harga",
            inputType: TextInputType.number,
          ),
          DView.height(20),
          //add to items Button
          ElevatedButton(
            onPressed: () {
              cAddHistory.addItem({
                'name': controllerName.text,
                'price': controllerPrice.text,
              });
              controllerName.clear();
              controllerPrice.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Tambah ke Items"),
          ),
          DView.height(),
          Center(
            child: Container(
              width: 100,
              height: 6,
              decoration: BoxDecoration(
                color: AppColor.background,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          //section item
          DView.height(),
          const Text(
            "Items",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DView.height(8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black54),
            ),
            child: GetBuilder<CAddHistory>(
              init: CAddHistory(),
              builder: (c) {
                return Wrap(
                  spacing: 12,
                  runSpacing: 5,
                  children: List.generate(c.items.length, (index) {
                    return Chip(
                      label: Text(c.items[index]['name']),
                      deleteIcon: const Icon(Icons.clear),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onDeleted: () => c.delete(index),
                    );
                  }),
                );
              },
            ),
          ),
          DView.height(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Total:",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              DView.width(8),
              Obx(
                () => Text(
                  AppFormat.currency(cAddHistory.total.toString()),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                ),
              ),
            ],
          ),
          DView.height(30),
          Material(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                addHistory();
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "SUBMIT",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
