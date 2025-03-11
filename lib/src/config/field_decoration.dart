import 'package:flutter/material.dart';

/// Represents the decoration for the dropdown field.
class FieldDecoration {
  /// Creates a new instance of [FieldDecoration].
  ///
  /// [hintText] is the hint text to display in the dropdown field. The default
  /// value is 'Select'.
  ///
  /// [border] is the border of the dropdown field.
  ///
  /// [suffixIcon] is the icon to display at the end of dropdown field. The
  /// default value is Icon(Icons.arrow_drop_down).
  ///
  /// [prefixIcon] is the icon to display at the start of dropdown field.
  ///
  /// [labelStyle] is the style of the label text.
  ///
  /// [hintStyle] is the style of the hint text.
  ///
  /// [borderRadius] is the border radius of the dropdown field. The default
  /// value is 12.
  ///
  /// [animateSuffixIcon] is whether to animate the suffix icon or not when
  /// dropdown is opened/closed. The default value is true.
  ///
  /// [suffixIcon] is the icon to display at the end of dropdown field.
  ///
  /// [prefixIcon] is the icon to display at the start of dropdown field.
  ///
  /// [padding] is the padding around the dropdown field.
  ///
  /// [backgroundColor] is the background color of the dropdown field.
  const FieldDecoration({
    this.hintText = 'Select',
    this.border,
    this.suffixIcon = const Icon(
      Icons.keyboard_arrow_down_rounded,
      color: Color(0xff8C8C8C),
      size: 16,
    ),
    this.prefixIcon,
    this.borderRadius = 12,
    this.hintStyle,
    this.animateSuffixIcon = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.backgroundColor,
    this.showClearIcon = true,
    this.style,
    this.clearIcon,
    this.isRow = true,
    this.maxHeight = 200,
    this.minHeight = 28,
  });

  /// The hint text to display in the dropdown field.
  final String? hintText;

  /// The border of the dropdown field.
  final InputBorder? border;

  /// The icon to display at the end of dropdown field.
  final Widget? suffixIcon;

  /// The icon to display at the start of dropdown field.
  final Widget? prefixIcon;

  /// The style of the hint text.
  final TextStyle? hintStyle;

  /// The border radius of the dropdown field.
  final double borderRadius;

  /// animate the icon or not
  final bool animateSuffixIcon;

  /// padding around the dropdown field
  final EdgeInsets? padding;

  /// background color of the dropdown field
  final Color? backgroundColor;

  /// show clear icon or not in the dropdown field
  final bool showClearIcon;

  /// The style of the input text.
  final TextStyle? style;

  /// clear icon
  final Widget? clearIcon;

  /// textField layout is row and column
  final bool isRow;

  /// [PopupDecoration().isShowAllSelectedLabel == true]
  /// field widget max height
  final double maxHeight;

  /// /// field widget min height
  final double minHeight;
}
