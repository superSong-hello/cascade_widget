import 'package:flutter/material.dart';

const Color defaultActiveColor = Color(0xff0052D9);

/// Configuration for the popup menu's appearance and behavior.
class PopupConfig {
  /// Creates a configuration for the popup menu.
  const PopupConfig({
    this.popupWidth = 180,
    this.overlayWidth,
    this.popupHeight = 350,
    this.checkBoxActiveColor,
    this.textStyle,
    this.selectedTextStyle,
    this.itemBackgroundColor,
    this.isShowFullPathFromSearch = true,
    this.isShowSearchInput = true,
    this.canRequestFocus = true,
    this.isShowOverlay = true,
    this.overlayColor = Colors.transparent,
    this.emptyText = 'No data',
    this.emptyTextStyle,
  });

  /// The width of each list view within the popup.
  ///
  /// For cascade widgets (e.g. [CascadeWidget], [SingleSelectCascadeWidget])
  /// the popup's total width grows with the number of expanded levels
  /// (`popupWidth * levels`), so it can exceed the screen width faster than
  /// this value alone suggests. As with [overlayWidth], the popup is shifted
  /// left to stay on screen but that shift is capped at the trigger
  /// control's own left edge — a large [popupWidth] combined with many
  /// levels can still overflow on the right.
  final double popupWidth;

  /// The width of the popup overlay for select widgets (e.g. [SingleSelectWidget],
  /// [MultipleSelectWidget]). When null, the overlay automatically matches the
  /// width of the trigger control.
  ///
  /// If the overlay would extend past the right edge of the screen, it is
  /// shifted left just enough to stay fully on screen. That shift is capped
  /// at the trigger control's own left edge, so a value wider than the
  /// available screen width will still overflow on the right — keep
  /// [overlayWidth] within the width of the screens you support.
  final double? overlayWidth;

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
