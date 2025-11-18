import 'package:flutter/material.dart';

const Color defaultActiveColor = Color(0xff0052D9);

/// Configuration for the popup menu's appearance and behavior.
class PopupConfig {
  /// Creates a configuration for the popup menu.
  const PopupConfig({
    this.popupWidth = 180,
    this.popupHeight = 350,
    this.checkBoxActiveColor,
    this.textStyle,
    this.selectedTextStyle,
    this.itemBackgroundColor,
    this.isShowFullPathFromSearch = true,
    this.isShowSearchInput = true,
    this.canRequestFocus = true,
    this.isShowOverlay = false,
    this.overlayColor = Colors.transparent,
    this.emptyText = 'No data',
    this.emptyTextStyle,
  });

  /// The width of each list view within the popup.
  final double popupWidth;

  /// The height of the popup menu.
  final double popupHeight;

  /// The color for the checkbox when it is active or in a tristate.
  final Color? checkBoxActiveColor;

  /// The default text style for items in the popup list.
  final TextStyle? textStyle;

  /// The text style for selected items in the popup list.
  final TextStyle? selectedTextStyle;

  /// The background color of an item when it is hovered over.
  final Color? itemBackgroundColor;

  /// Whether to show the full hierarchical path for items in the search results.
  /// (e.g., "Level 1/Level 2/Item").
  final bool isShowFullPathFromSearch;

  /// Whether to display the search input field within the popup.
  final bool isShowSearchInput;

  /// Whether the search input field can request focus.
  final bool canRequestFocus;

  /// Whether to show a modal overlay behind the popup.
  final bool isShowOverlay;

  /// The color of the modal overlay.
  final Color overlayColor;

  /// The text to display when the list is empty.
  final String emptyText;

  /// The text style for the empty text.
  final TextStyle? emptyTextStyle;
}
