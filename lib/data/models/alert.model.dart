import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Alerts {
  double? entryprice;
  String? tag;
  double? sp;
  String? symbol;
  Timestamp? timestamp;
  double? tp;

  Alerts({this.entryprice, this.tag, this.sp, this.symbol, this.timestamp, this.tp});

  factory Alerts.fromJson(Map<String, dynamic> json) {
    return Alerts(
      timestamp: json['timestamp'],
      entryprice: json['entryprice'],
      sp: json['sp'],
      tag: json['tag'],
      symbol: json['symbol'],
      tp: json['tp'],
    );
  }
}
