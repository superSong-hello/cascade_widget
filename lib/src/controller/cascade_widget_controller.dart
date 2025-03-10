import 'package:flutter/material.dart';

import '../model/drop_down_menu_model.dart';

class CascadeWidgetController extends ChangeNotifier {
  final List<DropDownMenuModel> _list = [];

  final List<List<DropDownMenuModel>> _uiList = [];

  final List<DropDownMenuModel> _selectedList = [];

  final List<DropDownMenuModel> _searchList = [];

  List<DropDownMenuModel> _filteredList = [];

  String _searchQuery = '';

  late final ValueChanged<List<DropDownMenuModel>> _selectedCallBack;

  late final VoidCallback refreshPopup;

  /// 树形结构原数据
  List<DropDownMenuModel> get list => _list;

  /// 一维结构的原数据
  List<DropDownMenuModel> get searchList => _searchList;

  /// 搜索结果数据
  List<DropDownMenuModel> get filteredList =>
      _searchQuery.isEmpty ? _searchList : _filteredList;

  /// 渲染UI，点击Item的时候UI会向右侧扩展显示子选项
  List<List<DropDownMenuModel>> get uiList => _uiList;

  /// 选中的数据
  List<DropDownMenuModel> get selectedList => _selectedList;

  /// 选中的数据回调
  ValueChanged<List<DropDownMenuModel>> get selectedCallBack =>
      _selectedCallBack;

  bool isOpen = false;

  /// 每次变更刷新
  bool isRealTimeRefresh = false;

  bool get isShopSearchView => isOpen && _searchQuery.isNotEmpty;

  /// 初始化
  void init(
    List<DropDownMenuModel> options,
    List<String>? defaultSelectedIds,
    ValueChanged<List<DropDownMenuModel>> selectedCallBack,
  ) {
    if (defaultSelectedIds != null && defaultSelectedIds.isNotEmpty) {
      final selectedArray = _getAllSelectedListFromIds(
          options, defaultSelectedIds, <DropDownMenuModel>[]);
      for (final e in selectedArray) {
        checkCurrentItemFatherNodeState(
            treeFindPath(options, e, <DropDownMenuModel>[]));
      }
    }
    setItems(options);
    setLevelForAllItems(options, 0, '');
    _uiList.addAll([options]);
    _selectedCallBack = selectedCallBack;
    getSelectedList(list, []);
    notifyListeners();
  }

  void setItems(List<DropDownMenuModel> options) {
    _list
      ..clear()
      ..addAll(options);
    notifyListeners();
  }

  void setUIItems(List<List<DropDownMenuModel>> options) {
    _uiList
      ..clear()
      ..addAll(options);
    notifyListeners();
  }

  /// 点击输入框中的标签，选择X的时候bool? selectedState要给false
  void checkAllItemState(
    DropDownMenuModel currentClickItem, {
    bool isFromChipClick = false,
    bool selected = false,
  }) {
    final selectedNum = _selectedList.length;

    /// 处理当前点击item的所有子节点的状态
    if (!isFromChipClick) {
      final isSelected = currentClickItem.isSelected ?? false;
      treeFindSubset(
        currentClickItem,
        isSelected: !isSelected,
      );
    } else {
      currentClickItem
        ..isSelected = selected
        ..isClicked = false;
    }

    /// 处理当前点击item的父节点状态
    final paths = treeFindPath(
      _list,
      currentClickItem,
      <DropDownMenuModel>[],
    );
    checkCurrentItemFatherNodeState(paths);

    /// call back
    final tempSelectList = getSelectedList(list, []);
    selectedCallBack(tempSelectList);

    if (isRealTimeRefresh) {
      refreshPopup.call();
    } else {
      /// 重新刷新弹层UI
      if ((selectedNum == 0 && _selectedList.isNotEmpty) ||
          (selectedNum != 0 && _selectedList.isEmpty)) {
        refreshPopup.call();
      }
    }
  }

  /// 第一次传入数据的时候，遍历所有的数据，赋值层级
  void setLevelForAllItems(
    List<DropDownMenuModel> options,
    int level,
    String pathName,
  ) {
    final tempLevel = level + 1;
    for (final item in options) {
      item
        ..level = tempLevel
        ..pathName = pathName.isEmpty ? item.name : '$pathName/${item.name}';
      if (item.children.isNotEmpty) {
        setLevelForAllItems(item.children, tempLevel, item.pathName);
      }
      if (item.children.isEmpty) {
        _searchList.add(item);
      }
    }
  }

  /// 获取所有选中的有效数据
  List<DropDownMenuModel> getSelectedList(
    List<DropDownMenuModel> originList,
    List<DropDownMenuModel> targetList,
  ) {
    for (final e in originList) {
      if (e.id.isNotEmpty && e.children.isEmpty && (e.isSelected ?? true)) {
        targetList.add(e);
      }
      if (e.children.isNotEmpty) {
        getSelectedList(e.children, targetList);
      }
    }
    _selectedList
      ..clear()
      ..addAll(targetList);
    return targetList;
  }

  List<DropDownMenuModel> _getAllSelectedListFromIds(
    List<DropDownMenuModel> list,
    List<String> ids,
    List<DropDownMenuModel> selectList,
  ) {
    for (final e in list) {
      if (e.children.isEmpty) {
        if (e.id.isNotEmpty && ids.contains(e.id)) {
          e.isSelected = true;
          selectList.add(e);
        }
      } else {
        _getAllSelectedListFromIds(e.children, ids, selectList);
      }
    }
    return selectList;
  }

  /// 获取所有选中或者待全选的数据
  List<DropDownMenuModel> _getSelectedList(
    List<DropDownMenuModel> originList,
    List<DropDownMenuModel> targetList,
  ) {
    for (final e in originList) {
      if (e.isClicked || (e.isSelected ?? true)) {
        targetList.add(e);
      }
      if (e.children.isNotEmpty) {
        _getSelectedList(e.children, targetList);
      }
    }
    return targetList;
  }

  /// 取消所有的选中状态
  void cancelAllSelected() {
    _getSelectedList(list, []).forEach((e) {
      e
        ..isSelected = false
        ..isClicked = false;
    });
    selectedList.clear();
    uiList
      ..clear()
      ..addAll([list]);
    selectedCallBack([]);
    notifyListeners();
  }

  /// 找到当前点击的item及其父类路径
  List<DropDownMenuModel> treeFindPath(
    List<DropDownMenuModel> originList,
    DropDownMenuModel clickItem,
    List<DropDownMenuModel> pathArray,
  ) {
    if (originList.isEmpty) return [];
    for (final item in originList) {
      pathArray.add(item);
      if (item == clickItem) return pathArray;
      if (item.children.isNotEmpty) {
        final findChildren = treeFindPath(item.children, clickItem, pathArray);
        if (findChildren.isNotEmpty) return findChildren;
      }
      pathArray.remove(item);
    }
    return [];
  }

  /// 处理当前点击item的所有子节点的状态
  void treeFindSubset(DropDownMenuModel clickItem, {bool isSelected = false}) {
    clickItem.isSelected = isSelected;
    if (clickItem.children.isNotEmpty) {
      treeFindSubsetChangeState(clickItem.children, isSelected: isSelected);
    }
  }

  void treeFindSubsetChangeState(
    List<DropDownMenuModel> list, {
    bool isSelected = false,
  }) {
    for (final e in list) {
      e.isSelected = isSelected;
      if (e.children.isNotEmpty) {
        treeFindSubsetChangeState(e.children, isSelected: isSelected);
      }
    }
  }

  /// 处理当前点击item的父节点状态
  void checkCurrentItemFatherNodeState(
    List<DropDownMenuModel> pathArray,
  ) {
    for (var i = pathArray.length - 1; i > 0; i--) {
      /// 获取当前节点的所有同级节点
      final fatherNode = pathArray[i - 1];
      final siblingNodes = fatherNode.children;
      bool? isAllSelected = true;
      var selectedNum = 0;
      var unSelectedNum = 0;
      for (final item in siblingNodes) {
        if (item.isSelected ?? false) {
          selectedNum++;
        } else if (item.isSelected == false) {
          unSelectedNum++;
        }
      }
      isAllSelected = selectedNum == siblingNodes.length
          ? true
          : unSelectedNum == siblingNodes.length
              ? false
              : null;
      fatherNode.isSelected = isAllSelected;
    }
    notifyListeners();
  }

  /// cancel all item clicked state
  void cancelAllClickedState(List<DropDownMenuModel> originList) {
    for (final item in originList) {
      item.isClicked = false;
      if (item.children.isNotEmpty) {
        cancelAllClickedState(item.children);
      }
    }
  }

  /// 变更搜索词
  void setSearchQuery(String query) {
    _searchQuery = query;
    if (_searchQuery.isEmpty) {
      _filteredList = _searchList;
    } else {
      _filteredList = _searchList
          .where(
            (item) =>
                item.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
