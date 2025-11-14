# Cascade Widget

A versatile Flutter cascade selection widget, offering multi-level cascading dropdowns with single and multiple selection options. Ideal for web and desktop applications.

> **Note:** The `CascadeWidget` and `SingleSelectCascadeWidget` are primarily designed and optimized for Web. The `MultipleSelectWidget` supports Web, Android, and iOS.

## Preview

![Preview GIF](assets/screen_5.gif)

## Features

- Multi-level cascade selection (Web optimized).
- Single and multiple selection modes.
- Search filtering for easy navigation.
- Highly customizable UI for input fields, chips, and popups.
- External controller support for programmatic control (e.g., clearing selections).
- Supports Web, Android, and iOS (`MultipleSelectWidget`).

## Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  cascade_widget: ^2.1.3 # Replace with the latest version
```

Then run `flutter pub get`.

## Usage

Here is a basic example of how to use the `CascadeWidget`:

```dart
import 'package:cascade_widget/cascade_widget.dart';

// ...

CascadeWidget(
  list: yourDataList, // Your List<DropDownMenuModel>
  selectedCallBack: (selectedList) {
    // Handle the selected items
    for (final e in selectedList) {
      debugPrint('name:${e.name}, id:${e.id}');
    }
  },
  fieldDecoration: FieldDecoration(
    backgroundColor: Colors.white,
    hintText: 'Please select',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Colors.grey),
    ),
  ),
  chipDecoration: ChipDecoration(
    backgroundColor: Colors.blueAccent,
    labelStyle: const TextStyle(color: Colors.white),
    deleteIcon: const Icon(Icons.clear_outlined, color: Colors.white, size: 16),
  ),
  layoutConfig: const LayoutConfig(
    isShowAllSelectedLabel: false,
  ),
)
```

### Multiple Select Example

To use it as a standard multi-select or single-select dropdown (non-cascading):

```dart
MultipleSelectWidget(
  list: yourSimpleList,
  isSingleChoice: true, // Set to false for multiple selections
  selectedCallBack: (selectedList) {
    // Handle selection
  },
  fieldDecoration: FieldDecoration(
    hintText: 'Select an option',
  ),
  chipDecoration: const ChipDecoration(
    backgroundColor: Colors.black12,
  ),
  popupConfig: const PopupConfig(
    isShowFullPathFromSearch: false,
    popupHeight: 300,
  ),
)
```

For more detailed examples, please check out the `/example` folder in the repository.
