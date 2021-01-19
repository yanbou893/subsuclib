import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Subsuc {
  String id;
  String name;
  int amount;
  int billingPeriod;
  DateTime startDate;
  int subsuc;
  String billingtext;
  bool textinput;


  DateTime now = new DateTime.now();

  Subsuc({this.id, @required this.name,  @required this.amount, @required this.billingPeriod,
  @required this.startDate, @required this.subsuc, @required this.billingtext,this.textinput});
  Subsuc.newTodo() {
    name = "";
    amount = 0;
    billingPeriod = 0;
    startDate = new DateTime(now.year, now.month, now.day);
    subsuc = 0;
    billingtext ="Monthly";
    textinput = false;
  }

  assignUUID() {
    id = Uuid().v4();
  }

  // staticでも同じ？
  factory Subsuc.fromMap(Map<String, dynamic> json) => Subsuc(
      id: json["id"],
      name: json["name"],
      amount: json["amount"],
      billingPeriod: json["billingPeriod"],
      billingtext: json["billingtext"],
      // DateTime型は文字列で保存されているため、DateTime型に変換し直す
      startDate: DateTime.parse(json["startDate"]).toLocal(),
      subsuc: json["subsuc"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "amount": amount,
    "billingPeriod": billingPeriod,
    "billingtext": billingtext,
    // sqliteではDate型は直接保存できないため、文字列形式で保存する
    "startDate": startDate.toUtc().toIso8601String(),
    "subsuc": subsuc,
  };
}