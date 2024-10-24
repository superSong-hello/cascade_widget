import 'package:flutter/material.dart';

class PopupDecoration {
  const PopupDecoration({
    this.popupWidth = 180,
    this.popupHeight = 350,
    this.checkBoxActiveColor,
    this.textStyle,
    this.selectedTextStyle,
    this.itemBackgroundColor,
  });

  /// 弹层单个list的宽度
  final double popupWidth;

  /// 弹层的高度
  final double popupHeight;

  /// checkbox 选中及待定的颜色
  final Color? checkBoxActiveColor;

  /// item 文字样式
  final TextStyle? textStyle;

  /// item 选中的文字样式
  final TextStyle? selectedTextStyle;

  /// item点击背景颜色
  final Color? itemBackgroundColor;
}
