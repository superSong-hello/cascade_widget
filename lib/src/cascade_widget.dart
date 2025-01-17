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
    this.controller,
  });

  final List<DropDownMenuModel> list;

  final ValueChanged<List<DropDownMenuModel>> selectedCallBack;

  final FieldDecoration fieldDecoration;

  final ChipDecoration chipDecoration;

  final PopupDecoration popupDecoration;

  final CascadeWidgetController? controller;

  @override
  State<CascadeWidget> createState() => _CascadeWidgetState();
}

class _CascadeWidgetState extends State<CascadeWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  late final CascadeWidgetController _cascadeController = widget.controller ?? CascadeWidgetController();
  final _textEditingController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;
  late final _listenable = Listenable.merge([
    _cascadeController,
  ]);

  OverlayEntry? _overlayEntry;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Your code to execute after the widget is rendered
      widget.selectedCallBack(_cascadeController.selectedList);
    });
  }

  // @override
  // void didUpdateWidget(covariant CascadeWidget oldWidget) {
  //   debugPrint('=== cascade widget didUpdateWidget');
  //   if (oldWidget.controller != widget.controller) {
  //     _cascadeController.dispose();
  //
  //     _cascadeController = widget.controller ?? CascadeWidgetController();
  //     _cascadeController
  //       ..init(widget.list, widget.selectedCallBack)
  //       ..refreshPopup = () {
  //       Future.delayed(const Duration(milliseconds: 100), showPopup);
  //     };
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.controller == null) {
      _cascadeController.dispose();
    }
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
      // ignore: deprecated_member_use
      onPopInvoked: (_) async {
        hideOverlay();
      },
      child: _CustomInputDecorator(
        fieldDecoration: widget.fieldDecoration,
        popupDecoration: widget.popupDecoration,
        listenable: _listenable,
        changeOverlay: _cascadeController.isOpen ? hideOverlay : showOverlay,
        hideOverlay: hideOverlay,
        buttonKey: _buttonKey,
        cascadeController: _cascadeController,
        chipDecoration: widget.chipDecoration,
        focusNode: _focusNode,
        textEditingController: _textEditingController,
      ),
    );
  }

  void showPopup() {
    /// 更新OverlayEntry数据需要清空之后重新构建
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return ListenableBuilder(
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
            if (renderBox == null || !renderBox.attached) {
              debugPrint('Failed to build the dropdown\nCode: 08');
              return const SizedBox.shrink();
            }
            final position = renderBox.localToGlobal(Offset.zero);
            final height = renderBox.size.height;
            final width = renderBox.size.width;

            return Stack(
              children: [
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
                                  child: _textEditingController.text.isNotEmpty
                                      ? _PopupListContentWidget(
                                          cascadeController: _cascadeController,
                                          listViewHeight: widget
                                              .popupDecoration.popupHeight,
                                          listViewWidth: width.toDouble(),
                                          popupDecoration:
                                              widget.popupDecoration,
                                        )
                                      : _PopupTreeContentWidget(
                                          cascadeController: _cascadeController,
                                          listViewHeight: widget
                                              .popupDecoration.popupHeight,
                                          listViewWidth:
                                              widget.popupDecoration.popupWidth,
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
        );
      },
    );

    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  /// show overlay
  void showOverlay() {
    setState(() {
      _animationController.forward();
    });
    _cascadeController.isOpen = true;
    showPopup();
  }

  /// hide overlay
  void hideOverlay() {
    _textEditingController.text = '';
    _cascadeController.isOpen = false;
    _animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }
}

class _CustomInputDecorator extends StatelessWidget {
  const _CustomInputDecorator({
    required this.fieldDecoration,
    required this.listenable,
    required this.cascadeController,
    required this.chipDecoration,
    required this.popupDecoration,
    required this.hideOverlay,
    this.changeOverlay,
    this.buttonKey,
    this.focusNode,
    this.textEditingController,
  });

  final FieldDecoration fieldDecoration;

  final ChipDecoration chipDecoration;

  final PopupDecoration popupDecoration;

  final Listenable listenable;

  final GlobalKey? buttonKey;

  final VoidCallback? changeOverlay;

  final CascadeWidgetController cascadeController;

  final FocusNode? focusNode;

  final TextEditingController? textEditingController;

  final VoidCallback hideOverlay;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.grab,
      onTap: changeOverlay,
      borderRadius: _getFieldBorderRadius(fieldDecoration),
      child: ListenableBuilder(
        listenable: listenable,
        builder: (ctx, _) {
          return TapRegion(
            child: InputDecorator(
              key: buttonKey,
              isEmpty: true,
              decoration: _buildDecoration(context),
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              child: _buildField(),
            ),
            onTapInside: (PointerDownEvent event) {},
            onTapOutside: (PointerDownEvent event) {
              RenderBox? tapedRenderBox =
                  buttonKey?.currentContext?.findRenderObject() as RenderBox?;
              Offset? globalPosition =
                  tapedRenderBox?.localToGlobal(Offset.zero);

              final contentWidth = cascadeController.isShopSearchView
                  ? (tapedRenderBox?.size.width ?? 0)
                  : (popupDecoration.popupWidth *
                      cascadeController.uiList.length);
              Rect renderBoxFrame = Rect.fromLTWH(
                globalPosition?.dx ?? 0,
                (globalPosition?.dy ?? 0) + (tapedRenderBox?.size.height ?? 0),
                contentWidth,
                (tapedRenderBox?.size.height ?? 0) +
                    popupDecoration.popupHeight,
              );
              Rect extraRenderBoxFrame = renderBoxFrame.inflate(5);
              if (extraRenderBoxFrame.contains(event.position) &&
                  cascadeController.isOpen) {
                return;
              }
              hideOverlay();
            },
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

    if (fieldDecoration.isRow) {
      return Row(
        children: [
          if (list != null && list.isNotEmpty)
            Wrap(
              spacing: chipDecoration.spacing,
              runSpacing: chipDecoration.runSpacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: list,
            ),
          if (list != null && list.isNotEmpty)
            const SizedBox(
              width: 5,
            ),
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              style: fieldDecoration.style,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
                border: InputBorder.none, // 设置边框为无
                // 如果需要在焦点变化时或者输入有错误时也不显示边框，可以设置以下两个属性
                enabledBorder: InputBorder.none, // 输入框没有焦点时的边框
                focusedBorder: InputBorder.none, // 输入框有焦点时的边框
                // 如果有错误提示也不需要边框，可以设置以下属性
                errorBorder: InputBorder.none, // 当输入有错误时的边框
                focusedErrorBorder: InputBorder.none, // 当输入有错误且输入框有焦点时的边框
              ),
            ),
          ),
        ],
      );
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
          style: fieldDecoration.style,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: fieldDecoration.padding?.top ?? 0,
            ),
            isCollapsed: true,
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
      isCollapsed: true,
      enabled: false,
      labelText: fieldDecoration.labelText,
      labelStyle: fieldDecoration.labelStyle,
      hintText: cascadeController.selectedList.isEmpty &&
              (textEditingController?.text ?? '').isEmpty
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
        child: fieldDecoration.clearIcon ??
            const Icon(
              Icons.clear,
              size: 14,
            ),
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
                  height: 32,
                  color: item.isClicked
                      ? defaultActiveColor.withOpacity(0.1)
                      : Colors.white,
                  padding: const EdgeInsets.only(left: 5, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          popupDecoration.isShowFullPathFromSearch
                              ? item.pathName
                              : item.name,
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
                            color: Color(0xffF7F7F7),
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
                            height: 32,
                            color: item.isClicked
                                ? (popupDecoration.itemBackgroundColor ??
                                    defaultActiveColor.withOpacity(0.1))
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Checkbox(
                                    tristate: true,
                                    value: item.isSelected,
                                    onChanged: (_) => cascadeController
                                        .checkAllItemState(item),
                                    activeColor:
                                        popupDecoration.checkBoxActiveColor ??
                                            defaultActiveColor,
                                    side: const BorderSide(
                                      color: Color(0xffD9D9D9),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
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
                                ),
                                if (item.children.isNotEmpty)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: Color(0xff8C8C8C),
                                    ),
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
