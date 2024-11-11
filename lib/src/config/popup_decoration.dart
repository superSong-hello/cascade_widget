import 'package:flutter/material.dart';

class PopupDecoration {
  const PopupDecoration({
    this.popupWidth = 180,
    this.popupHeight = 350,
    this.checkBoxActiveColor,
    this.textStyle,
    this.selectedTextStyle,
    this.itemBackgroundColor,
    this.isShowFullPathFromSearch = true,
    this.isSingleChoice = false,
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

  /// 搜索的时候是否显示全路径（一级/二级/name）
  final bool isShowFullPathFromSearch;

  /// 针对于非级联操作，是否是单选，默认多选
  final bool isSingleChoice;
}
