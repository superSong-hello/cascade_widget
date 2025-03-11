import 'package:flutter/material.dart';

import 'config/chip_decoration.dart';
import 'config/field_decoration.dart';
import 'config/popup_config.dart';
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
    this.popupConfig = const PopupConfig(),
    this.controller,
  });

  final List<DropDownMenuModel> list;

  final ValueChanged<List<DropDownMenuModel>> selectedCallBack;

  final FieldDecoration fieldDecoration;

  final ChipDecoration chipDecoration;

  final PopupConfig popupConfig;

  final CascadeWidgetController? controller;

  @override
  State<CascadeWidget> createState() => _CascadeWidgetState();
}

class _CascadeWidgetState extends State<CascadeWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  late final CascadeWidgetController _cascadeController =
      widget.controller ?? CascadeWidgetController();
  final _textEditingController = TextEditingController();
  final _scrollController = ScrollController();

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
      ..init(
          widget.list, widget.popupConfig.selectedIds, widget.selectedCallBack)
      ..isRealTimeRefresh = widget.popupConfig.isShowAllSelectedLabel
      ..refreshPopup = () {
        Future.delayed(const Duration(milliseconds: 100), showPopup);

        /// 显示所有标签的时候，勾选新的会滑到最底部
        if (widget.popupConfig.isShowAllSelectedLabel) {
          Future.delayed(const Duration(milliseconds: 50), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          });
        }
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
        popupConfig: widget.popupConfig,
        listenable: _listenable,
        changeOverlay: _cascadeController.isOpen ? hideOverlay : showOverlay,
        hideOverlay: hideOverlay,
        buttonKey: _buttonKey,
        cascadeController: _cascadeController,
        chipDecoration: widget.chipDecoration,
        focusNode: _focusNode,
        textEditingController: _textEditingController,
        scrollController: _scrollController,
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
                                          /// 输入框输入值检索的时候，列表显示
                                          cascadeController: _cascadeController,
                                          listViewHeight:
                                              widget.popupConfig.popupHeight,
                                          listViewWidth: width.toDouble(),
                                          popupConfig: widget.popupConfig,
                                        )
                                      : _PopupTreeContentWidget(
                                          /// 级联选择
                                          cascadeController: _cascadeController,
                                          listViewHeight:
                                              widget.popupConfig.popupHeight,
                                          listViewWidth:
                                              widget.popupConfig.popupWidth,
                                          popupConfig: widget.popupConfig,
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

class _CustomInputDecorator extends StatefulWidget {
  const _CustomInputDecorator({
    required this.fieldDecoration,
    required this.listenable,
    required this.cascadeController,
    required this.chipDecoration,
    required this.popupConfig,
    required this.hideOverlay,
    required this.scrollController,
    this.changeOverlay,
    this.buttonKey,
    this.focusNode,
    this.textEditingController,
  });

  final FieldDecoration fieldDecoration;

  final ChipDecoration chipDecoration;

  final PopupConfig popupConfig;

  final Listenable listenable;

  final GlobalKey? buttonKey;

  final VoidCallback? changeOverlay;

  final CascadeWidgetController cascadeController;

  final FocusNode? focusNode;

  final TextEditingController? textEditingController;

  final VoidCallback hideOverlay;

  final ScrollController scrollController;

  @override
  State<StatefulWidget> createState() => __CustomInputDecoratorState();
}

class __CustomInputDecoratorState extends State<_CustomInputDecorator> {
  final GlobalKey _key = GlobalKey();
  double _width = 0;
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _key.currentContext?.findRenderObject() as RenderBox;
      final size = renderBox.size;
      setState(() {
        _width = size.width;
        _height = size.height;
      });
    });

    return Stack(
      children: [
        InkWell(
          key: _key,
          mouseCursor: SystemMouseCursors.grab,
          onTap: widget.changeOverlay,
          borderRadius: _getFieldBorderRadius(widget.fieldDecoration),
          child: ListenableBuilder(
            listenable: widget.listenable,
            builder: (ctx, _) {
              return TapRegion(
                child: InputDecorator(
                  key: widget.buttonKey,
                  isEmpty: true,
                  decoration: _buildDecoration(context),
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  child: _buildField(),
                ),
                onTapInside: (PointerDownEvent event) {},
                onTapOutside: (PointerDownEvent event) {
                  RenderBox? tapedRenderBox = widget.buttonKey?.currentContext
                      ?.findRenderObject() as RenderBox?;
                  Offset? globalPosition =
                      tapedRenderBox?.localToGlobal(Offset.zero);

                  final contentWidth = widget.cascadeController.isShopSearchView
                      ? (tapedRenderBox?.size.width ?? 0)
                      : (widget.popupConfig.popupWidth *
                          widget.cascadeController.uiList.length);
                  Rect renderBoxFrame = Rect.fromLTWH(
                    globalPosition?.dx ?? 0,
                    (globalPosition?.dy ?? 0) +
                        (tapedRenderBox?.size.height ?? 0),
                    contentWidth,
                    (tapedRenderBox?.size.height ?? 0) +
                        widget.popupConfig.popupHeight,
                  );
                  Rect extraRenderBoxFrame = renderBoxFrame.inflate(5);
                  if (extraRenderBoxFrame.contains(event.position) &&
                      widget.cascadeController.isOpen) {
                    return;
                  }
                  widget.hideOverlay();
                },
              );
            },
          ),
        ),
        if (widget.popupConfig.disabled && _width > 0 && _height > 0)
          _MaskLayer(
            fieldDecoration: widget.fieldDecoration,
            popupConfig: widget.popupConfig,
            width: _width,
            height: _height,
          ),
      ],
    );
  }

  Widget _buildField() {
    final selectedList = widget.cascadeController.selectedList;
    List<Widget>? list;
    if (selectedList.isNotEmpty) {
      if (widget.popupConfig.isShowAllSelectedLabel) {
        list = selectedList.map((e) => _buildChip(e)).toList();
      } else {
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
    }

    if (widget.fieldDecoration.isRow) {
      return Row(
        children: [
          if (list != null && list.isNotEmpty)
            Wrap(
              spacing: widget.chipDecoration.spacing,
              runSpacing: widget.chipDecoration.runSpacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: list,
            ),
          if (list != null && list.isNotEmpty)
            const SizedBox(
              width: 5,
            ),
          if (widget.popupConfig.isShowSearchInput)
            Expanded(
              child: TextFormField(
                controller: widget.textEditingController,
                focusNode: widget.focusNode,
                style: widget.fieldDecoration.style,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  border: InputBorder.none,
                  // 设置边框为无
                  // 如果需要在焦点变化时或者输入有错误时也不显示边框，可以设置以下两个属性
                  enabledBorder: InputBorder.none,
                  // 输入框没有焦点时的边框
                  focusedBorder: InputBorder.none,
                  // 输入框有焦点时的边框
                  // 如果有错误提示也不需要边框，可以设置以下属性
                  errorBorder: InputBorder.none,
                  // 当输入有错误时的边框
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
          if (widget.popupConfig.isShowAllSelectedLabel)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.fieldDecoration.maxHeight,
                minHeight: widget.fieldDecoration.minHeight,
              ),
              child: ListView(
                controller: widget.scrollController,
                shrinkWrap: true,
                children: [
                  Wrap(
                    spacing: 8, // 水平方向的间距
                    runSpacing: 4, // 垂直方向的间距
                    children: list,
                  ),
                  // TextField(),
                ],
              ),
            ),
        if (list != null && list.isNotEmpty)
          if (!widget.popupConfig.isShowAllSelectedLabel)
            Wrap(
              spacing: widget.chipDecoration.spacing,
              runSpacing: widget.chipDecoration.runSpacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: list,
            ),
        if (widget.popupConfig.isShowSearchInput)
          TextFormField(
            controller: widget.textEditingController,
            focusNode: widget.focusNode,
            style: widget.fieldDecoration.style,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.fieldDecoration.padding?.top ?? 0,
              ),
              isCollapsed: true,
              border: InputBorder.none,
              // 设置边框为无
              // 如果需要在焦点变化时或者输入有错误时也不显示边框，可以设置以下两个属性
              enabledBorder: InputBorder.none,
              // 输入框没有焦点时的边框
              focusedBorder: InputBorder.none,
              // 输入框有焦点时的边框
              // 如果有错误提示也不需要边框，可以设置以下属性
              errorBorder: InputBorder.none,
              // 当输入有错误时的边框
              focusedErrorBorder: InputBorder.none, // 当输入有错误且输入框有焦点时的边框
            ),
          ),
      ],
    );
  }

  Widget _buildChip(
    DropDownMenuModel info,
  ) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.chipDecoration.borderRadius,
          color: widget.chipDecoration.backgroundColor,
          border: widget.chipDecoration.border,
        ),
        padding: widget.chipDecoration.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(info.name, style: widget.chipDecoration.labelStyle),
            const SizedBox(width: 4),
            if (info.id != '-9999')
              InkWell(
                onTap: () => widget.cascadeController.checkAllItemState(
                  info,
                  isFromChipClick: true,
                ),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: widget.chipDecoration.deleteIcon ??
                      const Icon(Icons.close, size: 16),
                ),
              ),
          ],
        ),
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

    final border = widget.fieldDecoration.border ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.fieldDecoration.borderRadius,
          ),
          borderSide: theme.inputDecorationTheme.border?.borderSide ??
              const BorderSide(),
        );

    final prefixIcon = widget.fieldDecoration.prefixIcon;

    return InputDecoration(
      isCollapsed: true,
      enabled: false,
      hintText: widget.cascadeController.selectedList.isEmpty &&
              (widget.textEditingController?.text ?? '').isEmpty
          ? widget.fieldDecoration.hintText
          : '',
      hintStyle: widget.fieldDecoration.hintStyle,
      filled: widget.fieldDecoration.backgroundColor != null,
      fillColor: widget.fieldDecoration.backgroundColor,
      border: widget.fieldDecoration.border ?? border,
      disabledBorder: widget.fieldDecoration.border ?? border,
      prefixIcon: prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      contentPadding: widget.fieldDecoration.padding,
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.fieldDecoration.showClearIcon &&
        widget.cascadeController.selectedList.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          widget.cascadeController.cancelAllSelected();
          if (widget.cascadeController.isOpen) {
            widget.changeOverlay?.call();
          }
        },
        child: widget.fieldDecoration.clearIcon ??
            const Icon(
              Icons.clear,
              size: 14,
            ),
      );
    }

    if (widget.fieldDecoration.suffixIcon == null) {
      return null;
    }

    if (!widget.fieldDecoration.animateSuffixIcon) {
      return widget.fieldDecoration.suffixIcon;
    }

    return AnimatedRotation(
      turns: widget.cascadeController.isOpen ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: widget.fieldDecoration.suffixIcon,
    );
  }
}

class _PopupListContentWidget extends StatelessWidget {
  const _PopupListContentWidget({
    required this.cascadeController,
    required this.listViewHeight,
    required this.listViewWidth,
    required this.popupConfig,
  });

  final double listViewWidth;
  final double listViewHeight;
  final CascadeWidgetController cascadeController;
  final PopupConfig popupConfig;

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
                          popupConfig.isShowFullPathFromSearch
                              ? item.pathName
                              : item.name,
                          style: item.isClicked || (item.isSelected ?? true)
                              ? (popupConfig.selectedTextStyle ??
                                  TextStyle(
                                    color: defaultActiveColor,
                                  ))
                              : popupConfig.textStyle ??
                                  const TextStyle(
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                      if (item.isSelected ?? false)
                        Icon(
                          Icons.check,
                          size: 16,
                          color: popupConfig.selectedTextStyle?.color ??
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
    required this.popupConfig,
  });

  final double listViewWidth;
  final double listViewHeight;
  final CascadeWidgetController cascadeController;
  final PopupConfig popupConfig;

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
                                ? (popupConfig.itemBackgroundColor ??
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
                                        popupConfig.checkBoxActiveColor ??
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
                                          ? popupConfig.selectedTextStyle ??
                                              TextStyle(
                                                color: popupConfig
                                                        .checkBoxActiveColor ??
                                                    defaultActiveColor,
                                              )
                                          : popupConfig.textStyle ??
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

class _MaskLayer extends StatelessWidget {
  const _MaskLayer({
    required this.fieldDecoration,
    required this.popupConfig,
    this.height,
    this.width,
  });

  final double? height;
  final double? width;
  final FieldDecoration fieldDecoration;
  final PopupConfig popupConfig;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: popupConfig.disabledColor ?? Colors.black12,
        borderRadius: (fieldDecoration.border != null &&
                fieldDecoration.border is OutlineInputBorder)
            ? (fieldDecoration.border as OutlineInputBorder).borderRadius
            : BorderRadius.circular(4),
      ),
    );
  }
}
