## [3.0.0] - 2025-11-14

### BREAKING CHANGES

- Refactored configuration classes for better separation of concerns.
- Moved layout-related properties (`isRow`, `maxHeight`, `minHeight`, `isShowAllSelectedLabel`) into a new `LayoutConfig` class.
- Moved `isSingleChoice` and `selectedIds` from `PopupConfig` to be top-level properties on the `MultipleSelectWidget`.
- Replaced the `disabled` property in `PopupConfig` with a top-level `enabled` property on all widgets for better API clarity.

### Features

- Added a new `LayoutConfig` class to control the layout of the field.
- Improved the example application with more use cases and a clearer, more organized UI.

### Fixes

- Addressed several linter warnings and deprecated API usages.

## [2.1.3]

- Fixed known bugs.
- Updated example and fixed `PopScope` deprecation warning.

## [2.1.2]

- Added option to show the full path in the selected tag for the single-select cascade widget.

## [2.1.1]

- Improved the UI for the single-select widget.

## [2.1.0]

- Added a new `SingleSelectCascadeWidget`.

## [2.0.6]

- Fixed known bugs.

## [2.0.5]

- Added a modal overlay and an option to customize its color.

## [2.0.4]

- Fixed issues with Tab key navigation, preventing multiple popups from opening.

## [2.0.3]

- Exposed more properties for customizing the search input field.

## [2.0.2]

- Fixed an issue with default selections in single and multi-select modes.
- Ensured the popup closes after an item is selected in single-choice mode.

## [2.0.0]

- Refactored the popup configuration class.
- Fixed various UI bugs.

## [1.0.7]

- Added an option to display all selected tags in the field.
- Added a disabled state for the widget.
- Added an option to show or hide the search input field.
- Improved the initialization logic for default selections.

## 1.0.6

- fix multiple_select bug.

## 1.0.5

Exposed the CascadeWidgetController. Then continue to optimize the current class.

## 1.0.4

fix bug

## 1.0.3

fix bug

## 1.0.2

add illustration gif

## 1.0.1

cascade_widget perfect the content

## 1.0.0

cascade_widget publish
