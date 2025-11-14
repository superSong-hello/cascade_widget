import 'package:flutter/material.dart';

import '../../cascade_widget.dart';

class MultipleSelectWidgetController extends ChangeNotifier {
  final List<DropDownMenuModel> _list = [];

  final List<DropDownMenuModel> _selectedList = [];

  List<DropDownMenuModel> _filteredList = [];

  String _searchQuery = '';

  late final ValueChanged<List<DropDownMenuModel>> _selectedCallBack;

  /// 原数据
  List<DropDownMenuModel> get list => _list;

  /// 搜索结果数据
  List<DropDownMenuModel> get filteredList =>
      _searchQuery.isEmpty ? _list : _filteredList;

  /// 选中的数据
  List<DropDownMenuModel> get selectedList => _selectedList;

  /// 选中的数据回调
  ValueChanged<List<DropDownMenuModel>> get selectedCallBack =>
      _selectedCallBack;

  bool isOpen = false;

  /// 初始化
  void init(
    List<DropDownMenuModel> options,
    List<String>? defaultSelectedIds,
    ValueChanged<List<DropDownMenuModel>> selectedCallBack,
  ) {
    if (defaultSelectedIds != null && defaultSelectedIds.isNotEmpty) {
      _updateSelectionFromIds(
        options,
        defaultSelectedIds,
      );
    }

    setItems(options);
    _selectedCallBack = selectedCallBack;
    _updateSelectionAndNotify();
  }

  void setItems(List<DropDownMenuModel> options) {
    _list
      ..clear()
      ..addAll(DropDownMenuModel.deepCopyList(options));
    notifyListeners();
  }

  void _updateSelectionAndNotify() {
    final selected = getSelectedList();
    _selectedCallBack(selected);
    notifyListeners();
  }

  /// 点击输入框中的标签，选择X的时候bool? selectedState要给false
  void checkItemState(
    DropDownMenuModel currentClickItem, {
    bool isFromChipClick = false,
    bool selected = false,
    bool isSingleChoice = false,
  }) {
    if (isSingleChoice) {
      for (var e in _list) {
        e.isSelected = false;
      }
      _selectedList.clear();
    }

    /// 处理当前点击item的所有子节点的状态
    if (!isFromChipClick) {
      final isSelected = currentClickItem.isSelected ?? false;
      currentClickItem.isSelected = !isSelected;
    } else {
      currentClickItem
        ..isSelected = selected
        ..isClicked = false;
    }

    /// call back
    _updateSelectionAndNotify();
  }

  void _updateSelectionFromIds(
    List<DropDownMenuModel> list,
    List<String> ids,
  ) {
    for (final e in list) {
      if (e.children.isEmpty) {
        if (e.id.isNotEmpty && ids.contains(e.id)) {
          e.isSelected = true;
        }
      } else {
        _updateSelectionFromIds(e.children, ids);
      }
    }
  }

  /// 获取所有选中的有效数据
  List<DropDownMenuModel> getSelectedList() {
    final tempSelectList = <DropDownMenuModel>[];
    for (final e in _list) {
      if (e.isSelected == true) {
        tempSelectList.add(e);
      }
    }
    _selectedList
      ..clear()
      ..addAll(tempSelectList);
    return tempSelectList;
  }

  /// 取消所有的选中状态
  void cancelAllSelected() {
    for (final e in _list) {
      if (e.isSelected == true) {
        e.isSelected = false;
      }
    }
    _selectedList.clear();
    _selectedCallBack([]);
    notifyListeners();
  }

  /// 变更搜索词
  void setSearchQuery(String query) {
    _searchQuery = query;
    if (_searchQuery.isEmpty) {
      _filteredList = _list;
    } else {
      _filteredList = _list
          .where(
            (item) =>
                item.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
