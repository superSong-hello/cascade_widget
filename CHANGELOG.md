## [3.0.8] - 2026-07-17

### Features

- **Customizable Popup Width**: Added `overlayWidth` to `PopupConfig` for `SingleSelectWidget` and `MultipleSelectWidget`. When unset, the popup still auto-matches the trigger control's width (previous default behavior); set it to override with a fixed width.

### Fixes

- **Popup Screen-Edge Overflow**: The popup for `SingleSelectWidget`, `MultipleSelectWidget`, `CascadeWidget`, and `SingleSelectCascadeWidget` is now shifted left when it would otherwise render past the right edge of the screen (e.g. a wide `overlayWidth`, or a cascade with several expanded levels).
- **Cascade Tap-Outside Detection**: Corrected the outside-tap hit-test area in `CascadeWidget` and `SingleSelectCascadeWidget` to account for the popup's actual rendered width/height (including the screen-edge shift above), preventing taps inside the popup from being misread as taps outside it.

## [3.0.7] - 2026-07-16

### Fixes

- `SingleSelectWidget`: Reopening the dropdown while an item is selected now clears the search text (showing the selected value as a placeholder) and resets the search query, so the popup shows the full list instead of the stale filtered result.

## [3.0.6] - 2026-04-14

- `SingleSelectWidget` and `MultipleSelectWidget` add `resetSelectedIds` function.

## [3.0.5] - 2026-02-05

- `SingleSelectWidget` and `MultipleSelectWidget` removed the `onTapOutside` callback from TapRegion.

## [3.0.4] - 2026-01-07

### Fixes

- Fixed an issue where pop-ups caused inaccurate positioning in Flutter Web browser scaling.

## [3.0.3] - 2025-11-19

### Fixes

- **Component Exports**: Ensured that all public components, including the new `SingleSelectWidget`, are correctly exported from the main library file, making them available for import in other projects.

## [3.0.2]

### Fixes

- **Tap Outside Detection**: Corrected the tap detection area for closing the popup (`onTapOutside`), which was incorrect when the popup's height was dynamically adjusted for short lists.

## [3.0.1] - 2025-11-18

### BREAKING CHANGES

- **Refactored `MultipleSelectWidget`**: The original `MultipleSelectWidget` has been split into two separate, more focused widgets:
  - `MultipleSelectWidget`: Now exclusively handles multi-selection logic.
  - `SingleSelectWidget`: A new widget dedicated to single-selection scenarios.
    The `isSingleChoice` parameter has been removed from `MultipleSelectWidget`. Please use `SingleSelectWidget` for single-choice dropdowns.

### Features

- **Upward Popup Display**: The popup layer can now intelligently open upwards when there is not enough space below the widget.
- **Single-Select Searchable Input**: In single-select mode, the input field now displays the selected text and can be edited to search/filter the list. The dropdown is triggered by the suffix icon.
- **Customizable Empty List Text**: Added `emptyText` and `emptyTextStyle` to `PopupConfig` to allow customization of the message shown when the list is empty for both single and multiple select widgets.

### Fixes

- **Adaptive Chip Width**: The width of selection chips in `MultipleSelectWidget` is now adaptive and dynamically calculated, preventing layout overflow on smaller screens or with long text.

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
