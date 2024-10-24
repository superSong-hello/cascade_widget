
# Flutter web 级联组件
改组件支持树形结构选择，支持搜索筛选

## Preview
[<img src="https://github.com/superSong-hello/cascade_widget/blob/master/assets/screen_1.png" width="400" alt=""/>](screen_1.png)
[<img src="https://github.com/superSong-hello/cascade_widget/blob/master/assets/screen_2.png" width="400" alt=""/>](screen_2.png)

## Usage

```dart
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
