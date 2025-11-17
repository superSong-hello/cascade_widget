import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/chip_decoration.dart';
import '../../config/field_decoration.dart';
import '../../config/layout_config.dart';
import '../../config/popup_config.dart';
import '../../controller/multiple_select_widget_controller.dart';
import '../../model/drop_down_menu_model.dart';
import '../../widgets/bubble_widget.dart';

class MultipleSelectWidget extends StatefulWidget {
  const MultipleSelectWidget({
    super.key,
    required this.list,
    required this.selectedCallBack,
    this.fieldDecoration = const FieldDecoration(),
    this.chipDecoration = const ChipDecoration(),
    this.popupConfig = const PopupConfig(),
    this.layoutConfig = const LayoutConfig(),
    this.controller,
    this.isSingleChoice = false,
    this.selectedIds,
    this.enabled = true,
  });

  final List<DropDownMenuModel> list;

  final ValueChanged<List<DropDownMenuModel>> selectedCallBack;

  final FieldDecoration fieldDecoration;

  final ChipDecoration chipDecoration;

  final PopupConfig popupConfig;

  final LayoutConfig layoutConfig;

  final MultipleSelectWidgetController? controller;

  final bool isSingleChoice;

  final List<String>? selectedIds;

  final bool enabled;

  @override
  State<MultipleSelectWidget> createState() => _MultipleSelectWidgetState();
}

class _MultipleSelectWidgetState extends State<MultipleSelectWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  late final MultipleSelectWidgetController _multipleSelectWidgetController;
  final _textEditingController = TextEditingController();
  bool _isInternalController = false;
  bool _isPopupAbove = false;

  late AnimationController _animationController;
  late Animation<double> _animation;
  late final _listenable = Listenable.merge([
    _multipleSelectWidgetController,
  ]);

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _multipleSelectWidgetController = MultipleSelectWidgetController();
      _isInternalController = true;
    } else {
      _multipleSelectWidgetController = widget.controller!;
    }

    _multipleSelectWidgetController.init(
      widget.list,
      widget.selectedIds,
      widget.selectedCallBack,
    );
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
  void didUpdateWidget(covariant MultipleSelectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.list != oldWidget.list) {
      _multipleSelectWidgetController.setItems(widget.list);
    }

    if (widget.controller != oldWidget.controller) {
      // If the controller is changed, we need to dispose the old one if it was internal
      if (_isInternalController) {
        _multipleSelectWidgetController.dispose();
      }

      _isInternalController = widget.controller == null;
      _multipleSelectWidgetController =
          widget.controller ?? MultipleSelectWidgetController();
      // Initialize the new controller
      _multipleSelectWidgetController.init(
        widget.list,
        widget.selectedIds,
        widget.selectedCallBack,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (_isInternalController) {
      _multipleSelectWidgetController.dispose();
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
    } else {
      // hideOverlay();
    }
  }

  void _textFieldChange() {
    showOverlay();
    _multipleSelectWidgetController.setSearchQuery(_textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (_) async {
        hideOverlay();
      },
      canPop: !_multipleSelectWidgetController.isOpen,
      child: Focus(
        onFocusChange: (value) {
          // debugPrint('$_focusNode: $value');
        },
        onKeyEvent: (_, event) {
          // 监听 Tab 键
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.tab) {
            return KeyEventResult.handled; // 阻止焦点切换
          }
          return KeyEventResult.ignored;
        },
        child: _CustomInputDecorator(
          fieldDecoration: widget.fieldDecoration,
          popupConfig: widget.popupConfig,
          layoutConfig: widget.layoutConfig,
          listenable: _listenable,
          changeOverlay: widget.enabled
              ? (_multipleSelectWidgetController.isOpen
                  ? hideOverlay
                  : showOverlay)
              : null,
          buttonKey: _buttonKey,
          multipleSelectWidgetController: _multipleSelectWidgetController,
          chipDecoration: widget.chipDecoration,
          focusNode: _focusNode,
          textEditingController: _textEditingController,
          hideOverlay: hideOverlay,
          enabled: widget.enabled,
          isPopupAbove: _isPopupAbove,
        ),
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

        // Calculate the actual height of the popup based on the content.
        final itemCount = _multipleSelectWidgetController.filteredList.length;
        final contentHeight = itemCount * _PopupListContentWidget._itemHeight;

        // Use a tolerance to decide if the content is larger than the max height.
        final bool isScrollable =
            (contentHeight - widget.popupConfig.popupHeight) > 0.001;
        final finalHeight =
            isScrollable ? widget.popupConfig.popupHeight : contentHeight;

        final totalPopupHeight = finalHeight + 24;
        final topPosition = _isPopupAbove
            ? position.dy - totalPopupHeight
            : position.dy + height;

        final slideBeginOffset =
            _isPopupAbove ? const Offset(0, 1) : const Offset(0, -1);

        /// 获取屏幕宽度
        double screenWidth = MediaQuery.of(context).size.width;

        /// 获取屏幕高度
        double screenHeight = MediaQuery.of(context).size.height;
        final Color maskColor = widget.popupConfig.overlayColor;

        return Stack(
          children: [
            if (widget.popupConfig.isShowOverlay) ...[
              /// The following four Positioned widgets create a mask around the input field
              /// by creating four rectangles that cover the entire screen except for the area
              /// occupied by the input field. This allows taps outside the popup to be caught
              /// to close it, without preventing interaction with the input field itself.
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
                  onTap: hideOverlay,
                  child: Container(
                    height: position.dy,
                    width: screenWidth,
                    color: maskColor,
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
                    width: position.dx,
                    color: maskColor,
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
                    color: maskColor,
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
                    color: maskColor,
                  ),
                ),
              )
            ],
            Positioned(
              left: position.dx + 0,
              top: topPosition,
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
                                begin: slideBeginOffset, // 从顶部开始
                                end: Offset.zero,
                              ).animate(_animation),
                              child: _PopupListContentWidget(
                                listenable: _listenable,
                                multipleSelectWidgetController:
                                    _multipleSelectWidgetController,
                                listViewHeight: finalHeight,
                                listViewWidth: width.toDouble(),
                                popupDecoration: widget.popupConfig,
                                hideOverlay: hideOverlay,
                                isSingleChoice: widget.isSingleChoice,
                                isPopupAbove: _isPopupAbove,
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

    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  /// show overlay
  void showOverlay() {
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final widgetHeight = renderBox.size.height;
    final screenHeight = MediaQuery.of(context).size.height;
    final popupHeight = widget.popupConfig.popupHeight;

    final spaceBelow = screenHeight - (position.dy + widgetHeight);
    final spaceAbove = position.dy;

    setState(() {
      _isPopupAbove = (spaceBelow < popupHeight) && (spaceAbove >= popupHeight);
    });

    _animationController.forward();
    _multipleSelectWidgetController.isOpen = true;
    showPopup();
  }

  /// hide overlay
  void hideOverlay() {
    _textEditingController.text = '';
    _multipleSelectWidgetController.isOpen = false;
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
    required this.popupConfig,
    required this.layoutConfig,
    required this.multipleSelectWidgetController,
    required this.chipDecoration,
    required this.hideOverlay,
    this.focusNode,
    this.changeOverlay,
    this.buttonKey,
    this.textEditingController,
    this.enabled = true,
    this.isPopupAbove = false,
  });

  final FieldDecoration fieldDecoration;

  final ChipDecoration chipDecoration;

  final PopupConfig popupConfig;

  final LayoutConfig layoutConfig;

  final Listenable listenable;

  final GlobalKey? buttonKey;

  final VoidCallback? changeOverlay;

  final MultipleSelectWidgetController multipleSelectWidgetController;

  final FocusNode? focusNode;

  final TextEditingController? textEditingController;

  final VoidCallback hideOverlay;

  final bool enabled;
  final bool isPopupAbove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
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
                  RenderBox? tapedRenderBox = buttonKey?.currentContext
                      ?.findRenderObject() as RenderBox?;
                  if (tapedRenderBox == null) {
                    hideOverlay();
                    return;
                  }
                  Offset? globalPosition =
                      tapedRenderBox.localToGlobal(Offset.zero);

                  final widgetHeight = tapedRenderBox.size.height;
                  final popupHeight =
                      popupConfig.popupHeight + 16; // Match total height

                  final top =
                      globalPosition.dy - (isPopupAbove ? popupHeight : 0);
                  final totalHeight = widgetHeight + popupHeight;

                  Rect renderBoxFrame = Rect.fromLTWH(
                    globalPosition.dx,
                    top,
                    tapedRenderBox.size.width,
                    totalHeight,
                  );
                  Rect extraRenderBoxFrame = renderBoxFrame.inflate(5);
                  if (extraRenderBoxFrame.contains(event.position)) {
                    return;
                  }
                  hideOverlay();
                },
              );
            },
          ),
        ),
        if (!enabled)
          Positioned.fill(
            child: _MaskLayer(
              fieldDecoration: fieldDecoration,
              popupConfig: popupConfig,
            ),
          ),
      ],
    );
  }

  Widget _buildField() {
    final selectedList = multipleSelectWidgetController.selectedList;
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

    final chipsWidget = list != null && list.isNotEmpty
        ? Wrap(
            spacing: chipDecoration.spacing,
            runSpacing: chipDecoration.runSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: list,
          )
        : null;

    final searchField = popupConfig.isShowSearchInput
        ? TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            style: fieldDecoration.style,
            canRequestFocus: popupConfig.canRequestFocus,
            decoration: InputDecoration(
              contentPadding: layoutConfig.isRow
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(
                      vertical: fieldDecoration.padding?.top ?? 0,
                    ),
              isCollapsed: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
          )
        : null;

    if (layoutConfig.isRow) {
      return Row(
        children: [
          if (chipsWidget != null) chipsWidget,
          if (chipsWidget != null) const SizedBox(width: 5),
          if (searchField != null) Expanded(child: searchField),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chipsWidget != null) chipsWidget,
        if (searchField != null) searchField,
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: chipDecoration.maxWidth,
            ),
            child: Text(
              info.name,
              style: chipDecoration.labelStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (chipDecoration.deleteIcon != null && info.id != '-9999')
            const SizedBox(width: 4),
          if (chipDecoration.deleteIcon != null && info.id != '-9999')
            InkWell(
              onTap: () => multipleSelectWidgetController.checkItemState(
                info,
                isFromChipClick: true,
              ),
              child: SizedBox(
                width: chipDecoration.closeButtonSize,
                height: chipDecoration.closeButtonSize,
                child: chipDecoration.deleteIcon ??
                    Icon(Icons.close, size: chipDecoration.closeButtonSize),
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
      hintText: multipleSelectWidgetController.selectedList.isEmpty &&
              (textEditingController?.text ?? '').isEmpty
          ? fieldDecoration.hintText
          : '',
      hintStyle: fieldDecoration.hintStyle,
      filled: fieldDecoration.backgroundColor != null,
      fillColor: fieldDecoration.backgroundColor,
      border: fieldDecoration.border ?? border,
      disabledBorder: fieldDecoration.border ?? border,
      prefixIcon: prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      contentPadding: fieldDecoration.padding,
    );
  }

  Widget? _buildSuffixIcon() {
    if (fieldDecoration.showClearIcon &&
        multipleSelectWidgetController.selectedList.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          multipleSelectWidgetController.cancelAllSelected();
          if (multipleSelectWidgetController.isOpen) {
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
      turns: multipleSelectWidgetController.isOpen ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: fieldDecoration.suffixIcon,
    );
  }
}

class _PopupListContentWidget extends StatelessWidget {
  const _PopupListContentWidget({
    required this.listenable,
    required this.multipleSelectWidgetController,
    required this.listViewHeight,
    required this.listViewWidth,
    required this.popupDecoration,
    required this.hideOverlay,
    required this.isSingleChoice,
    this.isPopupAbove = false,
  });

  final Listenable listenable;
  final double listViewWidth;
  final double listViewHeight;
  final MultipleSelectWidgetController multipleSelectWidgetController;
  final PopupConfig popupDecoration;
  final VoidCallback hideOverlay;
  final bool isSingleChoice;
  final bool isPopupAbove;
  static const double _itemHeight = 32.0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: listenable,
      builder: (ctx, _) {
        return Container(
          width: listViewWidth,
          height: listViewHeight + 32,
          padding: const EdgeInsets.only(left: 4, bottom: 8, right: 4),
          child: BubbleWidget(
            spineType: isPopupAbove ? SpineType.bottom : SpineType.top,
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
                padding: EdgeInsets.zero,
                children:
                    multipleSelectWidgetController.filteredList.map((item) {
                  return _ListItem(
                    item: item,
                    popupConfig: popupDecoration,
                    multipleSelectWidgetController:
                        multipleSelectWidgetController,
                    hideOverlay: hideOverlay,
                    isSingleChoice: isSingleChoice,
                    callback: (item) {
                      multipleSelectWidgetController.checkItemState(
                        item,
                        isFromChipClick: true,
                        selected: !(item.isSelected ?? false),
                        isSingleChoice: isSingleChoice,
                      );
                      if (isSingleChoice) {
                        hideOverlay();
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ListItem extends StatefulWidget {
  const _ListItem({
    required this.item,
    required this.popupConfig,
    required this.callback,
    required this.multipleSelectWidgetController,
    required this.hideOverlay,
    required this.isSingleChoice,
  });

  final DropDownMenuModel item;

  final ValueChanged<DropDownMenuModel> callback;

  final PopupConfig popupConfig;

  final MultipleSelectWidgetController multipleSelectWidgetController;

  final VoidCallback hideOverlay;

  final bool isSingleChoice;

  @override
  State<StatefulWidget> createState() => _ListItemState();
}

class _ListItemState extends State<_ListItem> {
  var isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHover = false;
        });
      },
      child: InkWell(
          onTap: () => widget.callback(widget.item),
          child: Container(
            height: _PopupListContentWidget._itemHeight,
            color: isHover
                ? (widget.popupConfig.itemBackgroundColor ??
                    defaultActiveColor.withValues(alpha: 0.1))
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                if (!widget.isSingleChoice)
                  Transform.scale(
                    scale: 0.8,
                    child: Checkbox(
                      tristate: true,
                      value: widget.item.isSelected,
                      onChanged: (_) {
                        widget.multipleSelectWidgetController.checkItemState(
                          widget.item,
                          isSingleChoice: widget.isSingleChoice,
                        );
                        if (widget.isSingleChoice) {
                          widget.hideOverlay();
                        }
                      },
                      activeColor: widget.popupConfig.checkBoxActiveColor ??
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
                      widget.item.name,
                      maxLines: 1, // 设置为1行，如果文本过长，则会省略
                      overflow: TextOverflow.ellipsis, // 文本溢出时显示省略号
                      style: widget.item.isClicked ||
                              (widget.item.isSelected !=
                                  false) // This covers true and null
                          ? widget.popupConfig.selectedTextStyle ??
                              TextStyle(
                                color: widget.popupConfig.checkBoxActiveColor ??
                                    defaultActiveColor,
                              )
                          : widget.popupConfig.textStyle ??
                              const TextStyle(
                                color: Colors.black,
                              ),
                    ),
                  ),
                ),
                if (widget.item.children.isNotEmpty)
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
          )),
    );
  }
}

class _MaskLayer extends StatelessWidget {
  const _MaskLayer({
    required this.fieldDecoration,
    required this.popupConfig,
  });

  final FieldDecoration fieldDecoration;
  final PopupConfig popupConfig;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fieldDecoration.disabledColor ?? Colors.black12,
        borderRadius: (fieldDecoration.border != null &&
                fieldDecoration.border is OutlineInputBorder)
            ? (fieldDecoration.border as OutlineInputBorder).borderRadius
            : BorderRadius.circular(4),
      ),
    );
  }
}
