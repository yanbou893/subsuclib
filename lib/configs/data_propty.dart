import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataProrty extends State<StatefulWidget> {
  @override
Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final padding = MediaQuery
        .of(context)
        .padding;
    var maxHeight = size.height - padding.top - padding.bottom;

    // アプリ描画エリアの縦サイズを取得
    if (Platform.isAndroid) {
      maxHeight = size.height - padding.top - kToolbarHeight;
    } else if (Platform.isIOS) {
      maxHeight = size.height - padding.top - padding.bottom - 22;
    }

    // Resultエリアの縦サイズ
    final heightA = maxHeight * (15 / 100);
    // テンキーエリアの縦サイズ
    final heightB = maxHeight * (10 / 100);
    final widthB = size.width * (70 / 100);
    final heightC = maxHeight * (10 / 100);
    final widthC = size.width * (95 / 100);
    final heightD = maxHeight * (55 / 100);
    final widthD = size.width * (50 / 100);
  }


}