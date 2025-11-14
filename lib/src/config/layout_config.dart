/// Configuration for the popup menu's appearance and behavior.
class LayoutConfig {
  /// Creates a configuration for the layout of the dropdown field.
  const LayoutConfig({
    this.isRow = true,
    this.maxHeight = 200,
    this.minHeight = 28,
    this.isShowAllSelectedLabel = false,
  });

  /// The layout direction of the chips within the field.
  /// If `true`, chips are laid out in a row. If `false`, in a column.
  final bool isRow;

  /// The maximum height constraint for the field when `isShowAllSelectedLabel` is `true`.
  final double maxHeight;

  /// The minimum height constraint for the field when `isShowAllSelectedLabel` is `true`.
  final double minHeight;

  /// Determines how selected items are displayed in the field.
  /// If `true`, all selected item chips are displayed.
  /// If `false`, only the first item is shown, followed by a "+N" count.
  final bool isShowAllSelectedLabel;
}
