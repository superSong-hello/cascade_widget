import 'package:flutter/material.dart';

/// Represents the decoration for the dropdown input field.
class FieldDecoration {
  /// Creates a decoration for the dropdown input field.
  ///
  /// [hintText] is the text to display when the dropdown is empty. The default
  /// value is 'Select'.
  ///
  /// [border] is the border to display around the dropdown field.
  ///
  /// [suffixIcon] is the icon to display at the end of the dropdown field. The
  /// default value is Icon(Icons.keyboard_arrow_down_rounded).
  ///
  /// [prefixIcon] is the icon to display at the beginning of the dropdown field.
  ///
  /// [hintStyle] is the style to use for the hint text.
  ///
  /// [borderRadius] is the border radius of the dropdown field's corners. The
  /// default value is 12.
  ///
  /// [animateSuffixIcon] is whether to animate the suffix icon when the dropdown
  /// is opened or closed. The default value is true.
  ///
  /// [padding] is the padding around the dropdown field's content.
  ///
  /// [backgroundColor] is the background color of the dropdown field.
  ///
  /// [showClearIcon] is whether to display a clear icon when items are selected.
  ///
  /// [style] is the text style for the input field.
  ///
  /// [clearIcon] is the icon used to clear all selected items.
  ///
  /// [disabledColor] is the color of the overlay when the widget is disabled.
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
    this.disabledColor,
  });

  /// The text to display when the dropdown is empty.
  final String? hintText;

  /// The border to display around the dropdown field.
  final InputBorder? border;

  /// The icon to display at the end of the dropdown field.
  final Widget? suffixIcon;

  /// The icon to display at the beginning of the dropdown field.
  final Widget? prefixIcon;

  /// The style to use for the hint text.
  final TextStyle? hintStyle;

  /// The border radius of the dropdown field's corners.
  final double borderRadius;

  /// Whether to animate the suffix icon when the dropdown is opened or closed.
  final bool animateSuffixIcon;

  /// The padding around the dropdown field's content.
  final EdgeInsets? padding;

  /// The background color of the dropdown field.
  final Color? backgroundColor;

  /// Whether to display a clear icon when items are selected.
  final bool showClearIcon;

  /// The text style for the input field.
  final TextStyle? style;

  /// The icon used to clear all selected items.
  final Widget? clearIcon;

  /// The color of the overlay when the widget is disabled.
  final Color? disabledColor;
}
