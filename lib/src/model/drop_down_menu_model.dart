class DropDownMenuModel {
  DropDownMenuModel({
    required this.name,
    required this.id,
    required this.children,
    this.level = 0,
    this.isSelected = false,
    this.isClicked = false,
    this.pathName = '',
    this.type = '',
  });

  factory DropDownMenuModel.fromJson(Map<String, dynamic> json) {
    return DropDownMenuModel(
      name: json['name'] as String,
      id: json['id'] as String,
      type: json.keys.contains('type') ? json['type'] as String : '',
      children: (json['children'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(DropDownMenuModel.fromJson)
          .toList(),
    );
  }

  /// id
  String id;

  /// label name
  String name;

  /// type
  String type;

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

  DropDownMenuModel copyWith({
    String? id,
    String? name,
    String? type,
    List<DropDownMenuModel>? children,
    bool? isSelected,
    bool? isClicked,
    int? level,
    String? pathName,
  }) {
    return DropDownMenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      children:
          children ?? this.children.map((child) => child.copyWith()).toList(),
      isSelected: isSelected ?? this.isSelected,
      isClicked: isClicked ?? this.isClicked,
      level: level ?? this.level,
      pathName: pathName ?? this.pathName,
    );
  }

  @override
  String toString() {
    return 'DropDownMenuModel(name: $name, id: $id, '
        'pathName: $pathName, children: $children)';
  }

  /// deepCopyList List<DropDownMenuModel>
  static List<DropDownMenuModel> deepCopyList(List<DropDownMenuModel> list) {
    return list.map((item) => item.copyWith()).toList();
  }
}
