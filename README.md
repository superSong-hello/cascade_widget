
# Flutter web 级联组件/单选、多选组件
* 组件支持级联选择，支持搜索筛选 
* 组件支持单选多选操作，支持搜索筛选

## Preview
![Screenshot 5](assets/screen_5.gif)

## Usage

```dart
/// 级联操作
CascadeWidget(
  list: testList,
  selectedCallBack: (selectedList) {
    for (final e in selectedList) {
      debugPrint('name:${e.name}, id:${e.id}');
    }
    },
  fieldDecoration: FieldDecoration(
    hintText: '请选择',
    hintStyle: const TextStyle(color: Colors.black45),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.black87,
      ),
    ),
  ),
  chipDecoration: const ChipDecoration(
    backgroundColor: Colors.blueAccent,
    runSpacing: 2,
    spacing: 10,
    labelStyle: TextStyle(
      color: Colors.white,
    ),
    deleteIcon: Icon(Icons.clear_outlined,
    color: Colors.white, size: 16)),
),

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
    hintText: '多选',
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
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(
        color: Colors.black87,
      ),
    ),
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
      deleteIcon: Icon(
        Icons.clear_outlined,
        color: Colors.black54,
        size: 15,
      ),
    ),
    popupDecoration: const PopupDecoration(
      isShowFullPathFromSearch: false,
      popupHeight: 300,
    ),
)
```