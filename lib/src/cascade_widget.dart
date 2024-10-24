import 'package:flutter/material.dart';

import 'config/chip_decoration.dart';
import 'config/field_decoration.dart';
import 'config/popup_decoration.dart';
import 'controller/cascade_widget_controller.dart';
import 'model/drop_down_menu_model.dart';
import 'widgets/bubble_widget.dart';
import 'widgets/custom_text.dart';

class CascadeWidget extends StatefulWidget {
  const CascadeWidget({
    super.key,
    required this.list,
    required this.selectedCallBack,
    this.fieldDecoration = const FieldDecoration(),
    this.chipDecoration = const ChipDecoration(),
    this.popupDecoration = const PopupDecoration(),
  });

  final List<DropDownMenuModel> list;

  final ValueChanged<List<DropDownMenuModel>> selectedCallBack;

  final FieldDecoration fieldDecoration;

  final ChipDecoration chipDecoration;

  final PopupDecoration popupDecoration;

  @override
  State<CascadeWidget> createState() => _CascadeWidgetState();
}

class _CascadeWidgetState extends State<CascadeWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  final _cascadeController = CascadeWidgetController();
  final _textEditingController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;
  late final _listenable = Listenable.merge([
    _cascadeController,
  ]);

  OverlayEntry? _overlayEntry;
  final Color _maskColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _cascadeController
      ..init(widget.list, widget.selectedCallBack)
      ..refreshPopup = () {
        Future.delayed(const Duration(milliseconds: 100), showPopup);
      };
    _focusNode.addListener(_focusChange);
    _textEditingController.addListener(_textFieldChange);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // 设置动画持续时间
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(_animationController); // 定义动画的值范围
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cascadeController.dispose();
    _focusNode
      ..removeListener(_focusChange)
      ..dispose();
    _textEditingController
      ..removeListener(_textFieldChange)
      ..dispose();
    super.dispose();
  }

  void _focusChange() {
    if (_focusNode.hasFocus) {
      /// 获取焦点
      showOverlay();
    }
  }

  void _textFieldChange() {
    showOverlay();
    _cascadeController.setSearchQuery(_textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) async {
        hideOverlay();
      },
      child: _CustomInputDecorator(
        cascadeController: _cascadeController,
        fieldDecoration: widget.fieldDecoration,
        listenable: _listenable,
        changeOverlay: () {
          _cascadeController.isOpen ? hideOverlay() : showOverlay();
        },
        buttonKey: _buttonKey,
        chipDecoration: widget.chipDecoration,
        focusNode: _focusNode,
        textEditingController: _textEditingController,
      ),
    );
  }

  void showPopup() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Focus(
          canRequestFocus: false,
          skipTraversal: true,
          child: ListenableBuilder(
            listenable: _listenable,
            builder: (ctx, _) {
              RenderBox? renderBox;
              final buttonCtx = _buttonKey.currentContext;
              if (buttonCtx != null) {
                final renderObject = buttonCtx.findRenderObject();
                if (renderObject != null) {
                  renderBox = renderObject as RenderBox;
                }
              }
              final position = renderBox != null
                  ? renderBox.localToGlobal(Offset.zero)
                  : Offset.zero;
              final height = renderBox != null ? renderBox.size.height : 0;
              final width = renderBox != null ? renderBox.size.width : 0;

              /// 获取屏幕宽度
              double screenWidth = MediaQuery.of(context).size.width;

              /// 获取屏幕高度
              double screenHeight = MediaQuery.of(context).size.height;

              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: hideOverlay,
                      child: Container(
                        height: position.dy,
                        width: screenWidth,
                        color: _maskColor,
                      ),
                    ),
                  ),
                  Positioned(
                    top: position.dy,
                    left: 0,
                    child: GestureDetector(
                      onTap: hideOverlay,
                      child: Container(
                        height: height.toDouble(),
                        width: screenWidth - position.dx - width,
                        color: _maskColor,
                      ),
                    ),
                  ),
                  Positioned(
                    top: position.dy,
                    left: position.dx + width,
                    child: GestureDetector(
                      onTap: hideOverlay,
                      child: Container(
                        height: height.toDouble(),
                        width: screenWidth - width - position.dx,
                        color: _maskColor,
                      ),
                    ),
                  ),
                  Positioned(
                    top: position.dy + height,
                    left: 0,
                    child: GestureDetector(
                      onTap: hideOverlay,
                      child: Container(
                        height: screenHeight,
                        width: screenWidth,
                        color: _maskColor,
                      ),
                    ),
                  ),
                  Positioned(
                    left: position.dx + 0,
                    top: position.dy + height,
                    child: Material(
                      color: Colors.transparent,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return SizeTransition(
                                  sizeFactor: _animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, -1), // 从顶部开始
                                      end: Offset.zero,
                                    ).animate(_animation),
                                    child:
                                        _textEditingController.text.isNotEmpty
                                            ? _PopupListContentWidget(
                                                cascadeController:
                                                    _cascadeController,
                                                listViewHeight: widget
                                                    .popupDecoration
                                                    .popupHeight,
                                                listViewWidth: width.toDouble(),
                                                popupDecoration:
                                                    widget.popupDecoration,
                                              )
                                            : _PopupTreeContentWidget(
                                                cascadeController:
                                                    _cascadeController,
                                                listViewHeight: widget
                                                    .popupDecoration
                                                    .popupHeight,
                                                listViewWidth: widget
                                                    .popupDecoration.popupWidth,
                                                popupDecoration:
                                                    widget.popupDecoration,
                                              ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  /// show overlay
  void showOverlay() {
    _animationController.forward();
    if (_overlayEntry == null) {
      _cascadeController.isOpen = true;
      showPopup();
    }
  }

  /// hide overlay
  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    Future.delayed(Duration.zero, () {
      /// TODO: -
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    _textEditingController.text = '';
    _cascadeController.isOpen = false;
    _animationController.reverse();
  }
}

class _CustomInputDecorator extends StatelessWidget {
  const _CustomInputDecorator({
    required this.fieldDecoration,
    required this.listenable,
    this.changeOverlay,
    this.buttonKey,
    required this.cascadeController,
    required this.chipDecoration,
    this.focusNode,
    this.textEditingController,
  });

  final FieldDecoration fieldDecoration;

  final ChipDecoration chipDecoration;

  final Listenable listenable;

  final GlobalKey? buttonKey;

  final VoidCallback? changeOverlay;

  final CascadeWidgetController cascadeController;

  final FocusNode? focusNode;

  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.grab,
      onTap: changeOverlay,
      borderRadius: _getFieldBorderRadius(fieldDecoration),
      child: ListenableBuilder(
        listenable: listenable,
        builder: (ctx, _) {
          return InputDecorator(
            key: buttonKey,
            isEmpty: true,
            decoration: _buildDecoration(context),
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            child: _buildField(),
          );
        },
      ),
    );
  }

  Widget _buildField() {
    final selectedList = cascadeController.selectedList;
    List<Widget>? list;
    if (selectedList.isNotEmpty) {
      list = selectedList.length > 1
          ? [
              _buildChip(selectedList.first),
              _buildChip(
                DropDownMenuModel(
                  id: '-9999',
                  name: '+ ${selectedList.length - 1}',
                  children: [],
                ),
              ),
            ]
          : [_buildChip(selectedList.first)];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (list != null && list.isNotEmpty)
          Wrap(
            spacing: chipDecoration.spacing,
            runSpacing: chipDecoration.runSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: list,
          ),
        TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            border: InputBorder.none, // 设置边框为无
            // 如果需要在焦点变化时或者输入有错误时也不显示边框，可以设置以下两个属性
            enabledBorder: InputBorder.none, // 输入框没有焦点时的边框
            focusedBorder: InputBorder.none, // 输入框有焦点时的边框
            // 如果有错误提示也不需要边框，可以设置以下属性
            errorBorder: InputBorder.none, // 当输入有错误时的边框
            focusedErrorBorder: InputBorder.none, // 当输入有错误且输入框有焦点时的边框
          ),
        ),
      ],
    );
  }

  Widget _buildChip(
    DropDownMenuModel info,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: chipDecoration.borderRadius,
        color: chipDecoration.backgroundColor,
        border: chipDecoration.border,
      ),
      padding: chipDecoration.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(info.name, style: chipDecoration.labelStyle),
          const SizedBox(width: 4),
          if (info.id != '-9999')
            InkWell(
              onTap: () => cascadeController.checkAllItemState(
                info,
                isFromChipClick: true,
              ),
              child: SizedBox(
                width: 16,
                height: 16,
                child: chipDecoration.deleteIcon ??
                    const Icon(Icons.close, size: 16),
              ),
            ),
        ],
      ),
    );
  }

  BorderRadius? _getFieldBorderRadius(FieldDecoration fieldDecoration) {
    if (fieldDecoration.border is OutlineInputBorder) {
      return (fieldDecoration.border! as OutlineInputBorder).borderRadius;
    }

    return BorderRadius.circular(fieldDecoration.borderRadius);
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final theme = Theme.of(context);

    final border = fieldDecoration.border ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            fieldDecoration.borderRadius,
          ),
          borderSide: theme.inputDecorationTheme.border?.borderSide ??
              const BorderSide(),
        );

    final prefixIcon = fieldDecoration.prefixIcon;

    return InputDecoration(
      enabled: false,
      labelText: fieldDecoration.labelText,
      labelStyle: fieldDecoration.labelStyle,
      hintText: (textEditingController?.text ?? '').isEmpty
          ? fieldDecoration.hintText
          : '',
      hintStyle: fieldDecoration.hintStyle,
      filled: fieldDecoration.backgroundColor != null,
      fillColor: fieldDecoration.backgroundColor,
      border: fieldDecoration.border ?? border,
      enabledBorder: fieldDecoration.border ?? border,
      disabledBorder: fieldDecoration.disabledBorder,
      prefixIcon: prefixIcon,
      focusedBorder: fieldDecoration.focusedBorder ?? border,
      suffixIcon: _buildSuffixIcon(),
      contentPadding: fieldDecoration.padding,
    );
  }

  Widget? _buildSuffixIcon() {
    if (fieldDecoration.showClearIcon &&
        cascadeController.selectedList.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          cascadeController.cancelAllSelected();
          if (cascadeController.isOpen) {
            changeOverlay?.call();
          }
        },
        child: const Icon(Icons.clear),
      );
    }

    if (fieldDecoration.suffixIcon == null) {
      return null;
    }

    if (!fieldDecoration.animateSuffixIcon) {
      return fieldDecoration.suffixIcon;
    }

    return AnimatedRotation(
      turns: cascadeController.isOpen ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: fieldDecoration.suffixIcon,
    );
  }
}

class _PopupListContentWidget extends StatelessWidget {
  const _PopupListContentWidget({
    required this.cascadeController,
    required this.listViewHeight,
    required this.listViewWidth,
    required this.popupDecoration,
  });

  final double listViewWidth;
  final double listViewHeight;
  final CascadeWidgetController cascadeController;
  final PopupDecoration popupDecoration;

  static Color defaultActiveColor = const Color(0xff0052D9);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: listViewWidth,
      height: listViewHeight + 16,
      padding: const EdgeInsets.only(left: 4, bottom: 8, right: 4),
      child: BubbleWidget(
        spineType: SpineType.top,
        color: Colors.white,
        elevation: 2,
        child: Container(
          height: listViewHeight,
          width: listViewWidth,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: ListView(
            children: cascadeController.filteredList.map((item) {
              return GestureDetector(
                onTap: () {
                  cascadeController.checkAllItemState(
                    item,
                    isFromChipClick: true,
                    selected: !(item.isSelected ?? false),
                  );
                },
                child: Container(
                  height: 44,
                  color: item.isClicked
                      ? defaultActiveColor.withOpacity(0.1)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          item.pathName,
                          style: item.isClicked || (item.isSelected ?? true)
                              ? (popupDecoration.selectedTextStyle ??
                                  TextStyle(
                                    color: defaultActiveColor,
                                  ))
                              : popupDecoration.textStyle ??
                                  const TextStyle(
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                      if (item.isSelected ?? false)
                        Icon(
                          Icons.check,
                          size: 16,
                          color: popupDecoration.selectedTextStyle?.color ??
                              defaultActiveColor,
                        )
                      else
                        const SizedBox(
                          width: 16,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void listViewItemClick(DropDownMenuModel item) {
    /// 取消之前的被选中的状态
    cascadeController.cancelAllClickedState(
      cascadeController.list,
    );

    /// 找到当前点击的item及其父类路径
    final paths = cascadeController.treeFindPath(
      cascadeController.list,
      item,
      <DropDownMenuModel>[],
    );
    for (final e in paths) {
      e.isClicked = true;
    }

    if (item.level + 1 > cascadeController.uiList.length) {
      if (item.children.isNotEmpty) {
        cascadeController.uiList.add(item.children);
      }
    } else {
      if (item.children.isEmpty) {
        cascadeController.uiList.removeAt(item.level);
      } else {
        cascadeController.uiList[item.level] = item.children;
      }
    }

    /// 移除多余层级
    var level = 0;
    final tempTree = <List<DropDownMenuModel>>[];
    for (final e in cascadeController.uiList) {
      if (level < (item.children.isEmpty ? item.level : item.level + 1)) {
        tempTree.add(e);
      }
      level++;
    }
    cascadeController.setUIItems(tempTree);
  }
}

class _PopupTreeContentWidget extends StatelessWidget {
  const _PopupTreeContentWidget({
    required this.cascadeController,
    required this.listViewHeight,
    required this.listViewWidth,
    required this.popupDecoration,
  });

  final double listViewWidth;
  final double listViewHeight;
  final CascadeWidgetController cascadeController;
  final PopupDecoration popupDecoration;

  static Color defaultActiveColor = const Color(0xff0052D9);

  @override
  Widget build(BuildContext context) {
    var arrayIndex = 0;
    return Container(
      width: listViewWidth * cascadeController.uiList.length + 24,
      height: listViewHeight + 16,
      padding: const EdgeInsets.only(left: 4, bottom: 8, right: 4),
      child: BubbleWidget(
        spineType: SpineType.top,
        color: Colors.white,
        elevation: 2,
        child: Container(
          width: listViewWidth * cascadeController.uiList.length,
          height: listViewHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cascadeController.uiList.map((e) {
              arrayIndex++;
              return Container(
                width: listViewWidth,
                height: listViewHeight,
                padding: const EdgeInsets.only(right: 1),
                decoration: BoxDecoration(
                  border: Border(
                    right: arrayIndex < cascadeController.uiList.length
                        ? const BorderSide(
                            color: Colors.black26,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: e
                      .map(
                        (item) => GestureDetector(
                          onTap: () => listViewItemClick(item),
                          child: Container(
                            height: 44,
                            color: item.isClicked
                                ? (popupDecoration.itemBackgroundColor ??
                                    defaultActiveColor.withOpacity(0.1))
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Checkbox(
                                  tristate: true,
                                  value: item.isSelected,
                                  onChanged: (_) =>
                                      cascadeController.checkAllItemState(item),
                                  activeColor:
                                      popupDecoration.checkBoxActiveColor ??
                                          defaultActiveColor,
                                ),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    maxLines: 1, // 设置为1行，如果文本过长，则会省略
                                    overflow:
                                        TextOverflow.ellipsis, // 文本溢出时显示省略号
                                    style: item.isClicked ||
                                            (item.isSelected ?? true)
                                        ? popupDecoration.selectedTextStyle ??
                                            TextStyle(
                                              color: popupDecoration
                                                      .checkBoxActiveColor ??
                                                  defaultActiveColor,
                                            )
                                        : popupDecoration.textStyle ??
                                            const TextStyle(
                                              color: Colors.black,
                                            ),
                                  ),
                                ),
                                if (item.children.isNotEmpty)
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void listViewItemClick(DropDownMenuModel item) {
    /// 取消之前的被选中的状态
    cascadeController.cancelAllClickedState(
      cascadeController.list,
    );

    /// 找到当前点击的item及其父类路径
    final paths = cascadeController.treeFindPath(
      cascadeController.list,
      item,
      <DropDownMenuModel>[],
    );
    for (final e in paths) {
      e.isClicked = true;
    }

    if (item.level + 1 > cascadeController.uiList.length) {
      if (item.children.isNotEmpty) {
        cascadeController.uiList.add(item.children);
      }
    } else {
      if (item.children.isEmpty) {
        cascadeController.uiList.removeAt(item.level);
      } else {
        cascadeController.uiList[item.level] = item.children;
      }
    }

    /// 移除多余层级
    var level = 0;
    final tempTree = <List<DropDownMenuModel>>[];
    for (final e in cascadeController.uiList) {
      if (level < (item.children.isEmpty ? item.level : item.level + 1)) {
        tempTree.add(e);
      }
      level++;
    }
    cascadeController.setUIItems(tempTree);
  }
}
