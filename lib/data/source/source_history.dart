// ignore_for_file: use_build_context_synchronously

import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_record/data/model/history.dart';

import '../../config/api.dart';
import '../../config/app_request.dart';

class SourceHistory {
  static Future<Map> analysis(String idUser) async {
    String url = "${Api.history}/analysis.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_user": idUser,
      "today": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    });

    if (responseBody == null) {
      return {
        "today": 0.0,
        "yesterday": 0.0,
        "week": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        "month": {
          "income": 0.0,
          "outcome": 0.0,
        }
      };
    }

    return responseBody;
  }

  static Future<bool> add(
    BuildContext context,
    String idUser,
    String date,
    String type,
    String details,
    String total,
  ) async {
    String url = "${Api.history}/add.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_user": idUser,
      "date": date,
      "type": type,
      "details": details,
      "total": total,
      "created_at": DateTime.now().toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
    });

    if (responseBody == null) return false;

    if (responseBody['success']) {
      DInfo.dialogSuccess(context, "Berhasil Tambah History");
      DInfo.closeDialog(context);
    } else {
      if (responseBody['message'] == 'date') {
        DInfo.dialogError(
            context, "History dengan tanggal tersebut sudah pernah dibuat");
      } else {
        DInfo.dialogError(context, "Gagal Tambah History!");
      }
      DInfo.closeDialog(context);
    }

    return responseBody['success'];
  }

  static Future<bool> update(
    BuildContext context,
    String idHistory,
    String idUser,
    String date,
    String type,
    String details,
    String total,
  ) async {
    String url = "${Api.history}/update.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_history": idHistory,
      "id_user": idUser,
      "date": date,
      "type": type,
      "details": details,
      "total": total,
      "updated_at": DateTime.now().toIso8601String(),
    });

    if (responseBody == null) return false;

    if (responseBody['success']) {
      DInfo.dialogSuccess(context, "Berhasil Ubah History");
      DInfo.closeDialog(context);
    } else {
      if (responseBody['message'] == 'date') {
        DInfo.dialogError(context, "Tanggal History sudah terpakai!");
      } else {
        DInfo.dialogError(context, "Gagal Ubah History!");
      }
      DInfo.closeDialog(context);
    }

    return responseBody['success'];
  }

  static Future<bool> delete(
    BuildContext context,
    String idHistory,
  ) async {
    String url = "${Api.history}/delete.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_history": idHistory,
    });

    if (responseBody == null) return false;
    return responseBody['success'];
  }

  static Future<List<History>> incomeOutcome(String idUser, String type) async {
    String url = "${Api.history}/income_outcome.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_user": idUser,
      "type": type,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((item) => History.fromJson(item)).toList();
    }

    return [];
  }

  static Future<List<History>> incomeOutcomeSearch(
    String idUser,
    String type,
    String date,
  ) async {
    String url = "${Api.history}/income_outcome_search.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_user": idUser,
      "type": type,
      "date": date,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((item) => History.fromJson(item)).toList();
    }

    return [];
  }

  static Future<List<History>> history(String idUser) async {
    String url = "${Api.history}/history.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_user": idUser,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((item) => History.fromJson(item)).toList();
    }

    return [];
  }

  static Future<List<History>> historySearch(
    String idUser,
    String date,
  ) async {
    String url = "${Api.history}/history_search.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_user": idUser,
      "date": date,
    });

    if (responseBody == null) return [];

    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((item) => History.fromJson(item)).toList();
    }

    return [];
  }

  static Future<History?> whereDate(
    String idUser,
    String date,
  ) async {
    String url = "${Api.history}/where_date.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_user": idUser,
      "date": date,
    });

    if (responseBody == null) return null;

    if (responseBody['success']) {
      Map<String, dynamic> data = responseBody['data'];
      return History.fromJson(data);
    }

    return null;
  }

  static Future<History?> detail(
    String idUser,
    String date,
    String type,
  ) async {
    String url = "${Api.history}/where_date.php";
    Map? responseBody = await AppRequest.post(url, {
      "id_user": idUser,
      "date": date,
      "type": type,
    });

    if (responseBody == null) return null;

    if (responseBody['success']) {
      Map<String, dynamic> data = responseBody['data'];
      return History.fromJson(data);
    }

    return null;
  }
}
