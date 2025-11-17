import 'package:flutter/widgets.dart';

/// Configuration class for customizing the appearance of selected item chips.
class ChipDecoration {
  /// Creates a configuration for chip appearance.
  const ChipDecoration({
    this.deleteIcon,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.border = const Border(),
    this.spacing = 8,
    this.runSpacing = 12,
    this.labelStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.maxWidth = 160.0,
    this.closeButtonSize = 16.0,
    this.isShowFullPathFromSelectedTag = false,
  });

  /// The icon used for the delete button on a chip.
  final Icon? deleteIcon;

  /// The background color of the chip.
  final Color? backgroundColor;

  /// The text style for the chip's label.
  final TextStyle? labelStyle;

  /// The padding around the content of the chip.
  final EdgeInsets padding;

  /// The border to draw around the chip.
  final BoxBorder border;

  /// The spacing between chips in the same row.
  final double spacing;

  /// The spacing between rows of chips.
  final double runSpacing;

  /// The border radius for the chip's corners.
  final BorderRadiusGeometry borderRadius;

  /// The maximum width for a single chip.
  final double maxWidth;

  /// The size of the close button icon.
  final double closeButtonSize;

  /// Whether to display the full path of a selected item in the chip label.
  /// (e.g., "Level 1/Level 2/Item").
  final bool isShowFullPathFromSelectedTag;
}
