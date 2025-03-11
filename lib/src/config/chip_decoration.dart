import 'package:flutter/material.dart';

/// Configuration class for customizing the appearance of
/// chips in the multi-select dropdown.
class ChipDecoration {
  /// Creates a new instance of [ChipDecoration].
  ///
  /// [deleteIcon] is the icon to display for deleting a chip.
  ///
  /// [backgroundColor] is the background color of the chip.
  ///
  /// [labelStyle] is the style of the chip label.
  ///
  /// [padding] is the padding around the chip.
  ///
  /// [border] is the border of the chip.
  ///
  /// [spacing] is the spacing between chips.
  ///
  /// [runSpacing] is the spacing between chip rows (when the chips wrap).
  ///
  /// [borderRadius] is the border radius of the chip.
  const ChipDecoration({
    this.deleteIcon,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.border = const Border(),
    this.spacing = 8,
    this.runSpacing = 12,
    this.labelStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  /// The icon to display for deleting a chip.
  final Icon? deleteIcon;

  /// The background color of the chip.
  final Color? backgroundColor;

  /// The style of the chip label.
  final TextStyle? labelStyle;

  /// The padding around the chip.
  final EdgeInsets padding;

  /// The border of the chip.
  final BoxBorder border;

  /// The spacing between chips.
  final double spacing;

  /// The spacing between chip rows (when the chips wrap).
  final double runSpacing;

  /// The border radius of the chip.
  final BorderRadiusGeometry borderRadius;
}
