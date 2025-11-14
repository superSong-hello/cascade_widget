/// Represents a single item in a dropdown menu, which can have nested children.
class DropDownMenuModel {
  /// Creates a model for a dropdown menu item.
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

  /// Creates a [DropDownMenuModel] from a JSON object.
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

  /// A unique identifier for the item.
  String id;

  /// The display name of the item.
  String name;

  /// An optional type identifier for the item.
  String type;

  /// A list of child items, representing the next level in the hierarchy.
  List<DropDownMenuModel> children = [];

  /// The selection state of the item.
  /// `true` for selected, `false` for unselected, `null` for indeterminate (e.g., some children are selected).
  bool? isSelected;

  /// Indicates if the item is currently clicked, used for highlighting in the UI.
  bool isClicked;

  /// The hierarchical level of the item in the tree (0-based).
  int level;

  /// The full path name of the item, typically used for display and search.
  /// (e.g., "Level 1/Level 2/Item").
  String pathName;

  /// Creates a copy of this model but with the given fields replaced with the new values.
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

  /// Creates a deep copy of this [DropDownMenuModel] and all its descendants.
  DropDownMenuModel deepCopy() {
    return copyWith(
      children: children.map((child) => child.deepCopy()).toList(),
    );
  }

  /// Creates a deep copy of a list of [DropDownMenuModel] items.
  static List<DropDownMenuModel> deepCopyList(List<DropDownMenuModel> list) {
    return list.map((item) => item.deepCopy()).toList();
  }
}
