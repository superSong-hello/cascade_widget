class DropDownMenuModel {
  DropDownMenuModel({
    required this.name,
    required this.id,
    required this.children,
    this.level = 0,
    this.isSelected = false,
    this.isClicked = false,
    this.pathName = '',
  });

  /// id
  String id;

  /// label name
  String name;

  /// children
  List<DropDownMenuModel> children = [];

  /// is selected
  /// true: ☑
  /// false: □
  /// null:
  bool? isSelected;

  /// item is clicked
  bool isClicked;

  /// tier
  int level;

  /// 全路径，供搜索使用
  String pathName;

  @override
  String toString() {
    return 'DropDownMenuModel(name: $name, id: $id, pathName: $pathName)';
  }
}
