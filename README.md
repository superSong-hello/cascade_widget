
# Flutter web 级联组件/单选、多选组件
* 组件支持级联选择，支持搜索筛选 (support: Web)
* 组件支持单选多选操作，支持搜索筛选 (support: Web、Android、iOS)

## Preview
![Screenshot 5](assets/screen_5.gif)

## Usage

```dart
/// 级联操作
CascadeWidget(
  list: testList1,
  selectedCallBack: (selectedList) {
    for (final e in selectedList) {
      debugPrint('name:${e.name}, id:${e.id}');
    }
  },
  fieldDecoration: FieldDecoration(
    backgroundColor: Colors.white,
    hintText: '请选择',
    hintStyle: const TextStyle(color: Colors.black45),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    isRow: true,
  ),
  chipDecoration: ChipDecoration(
    backgroundColor: Colors.blueAccent,
    runSpacing: 2,
    spacing: 10,
    labelStyle: TextStyle(
      color: Colors.white,
    ),
    borderRadius: BorderRadius.all(Radius.circular(4)),
    border: Border.all(color: Colors.grey),
    deleteIcon: Icon(Icons.clear_outlined,
    color: Colors.white, size: 16),
    maxWidth: 100,
  ),
  popupConfig: PopupConfig(
    isShowAllSelectedLabel: false,
    selectedIds: selecteds,
  ),
)

```

```dart
MultipleSelectWidget(
  list: mulList,
  selectedCallBack: (selectedList) {
    for (final e in selectedList) {
      debugPrint('name:${e.name}, id:${e.id}');
    }
  },
  fieldDecoration: FieldDecoration(
    hintText: '单选（支持多选）',
    hintStyle: const TextStyle(
      color: Colors.black45,
      fontSize: 14,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    showClearIcon: false,
    clearIcon: const Icon(
      Icons.clear,
      size: 14,
    ),
    style: const TextStyle(
      fontSize: 14,
    ),
  ),
  chipDecoration: const ChipDecoration(
    backgroundColor: Colors.black12,
    padding: EdgeInsets.symmetric(
      horizontal: 6,
      vertical: 2,
    ),
    runSpacing: 0,
    spacing: 5,
    labelStyle: TextStyle(
      color: Colors.black87,
      fontSize: 12,
    ),
  borderRadius: BorderRadius.all(Radius.circular(4)),
// deleteIcon: Icon(
//   Icons.clear_outlined,
//   color: Colors.black54,
//   size: 15,
// ),
  ),
  popupConfig: const PopupConfig(
    isShowFullPathFromSearch: false,
    popupHeight: 300,
    isSingleChoice: true,
  ),
)
```