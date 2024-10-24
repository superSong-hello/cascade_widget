import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum CustomTextOverflow {
  clip,
  fade,
  ellipsisMiddle,
  ellipsisEnd,
  visible,
}

class CustomText extends Text {
  CustomText(
    this.text, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    this.wxOverflow = CustomTextOverflow.ellipsisMiddle,
    super.textScaleFactor,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
  }) : super(text);

  final String text;

  final CustomTextOverflow wxOverflow;

  static const double defaultFontSize = 14;

  final RenderParagraph __renderParagraph = RenderParagraph(
    const TextSpan(
      text: '',
      style: TextStyle(
        fontSize: 14,
      ),
    ),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraint) {
        return Text(
          wxOverflow != CustomTextOverflow.ellipsisMiddle
              ? text
              : _finalString(
                  boxConstraint.maxWidth,
                  text,
                ),
          style: style ??
              TextStyle(
                color: style?.color ?? Colors.grey[900],
                fontSize: style?.fontSize ?? defaultFontSize,
              ),
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: _getOverflow(wxOverflow),
          maxLines: 1,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
        );
      },
    );
  }

  TextOverflow? _getOverflow(CustomTextOverflow overflow) {
    TextOverflow? textOverflow;
    if (overflow == CustomTextOverflow.ellipsisEnd ||
        overflow == CustomTextOverflow.ellipsisMiddle) {
      textOverflow = TextOverflow.ellipsis;
    } else if (overflow == CustomTextOverflow.clip) {
      textOverflow = TextOverflow.clip;
    } else if (overflow == CustomTextOverflow.visible) {
      textOverflow = TextOverflow.visible;
    } else if (overflow == CustomTextOverflow.fade) {
      textOverflow = TextOverflow.fade;
    }
    return textOverflow;
  }

  RenderParagraph _renderParagraph(String text) {
    __renderParagraph.text = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: style?.fontSize ?? 14.0,
      ),
    );
    return __renderParagraph;
  }

  String _finalString(double maxWidth, String text) {
    final tempMaxWidth = maxWidth - 20;
    var startIndex = 0;
    var endIndex = text.length;

    /// 计算当前text的宽度
    final width = _renderParagraph(text).computeMinIntrinsicWidth(
      style?.fontSize ?? defaultFontSize,
    );

    /// 当前text的宽度小于最大宽度，直接返回
    if (width < tempMaxWidth) return text;

    /// 计算...的宽度
    final ellipsisWidth = _renderParagraph('...').computeMinIntrinsicWidth(
      style?.fontSize ?? defaultFontSize,
    );
    final leftWidth = (tempMaxWidth - ellipsisWidth) * 0.5;
    var s = startIndex;
    var e = endIndex;

    /// 计算显示...的开始位置
    while (s < e) {
      final m = ((s + e) * 0.5).floor();
      final width =
          _renderParagraph(text.substring(0, m)).computeMinIntrinsicWidth(
        style?.fontSize ?? defaultFontSize,
      );
      if (width > leftWidth) {
        e = m;
      } else {
        s = m;
      }
      if (e - s <= 1) {
        startIndex = s;
        break;
      }
    }

    s = startIndex;
    e = endIndex;

    /// 计算显示...的结束位置
    while (s < e) {
      final m = ((s + e) * 0.5).ceil();
      final width = _renderParagraph(text.substring(m, endIndex))
          .computeMinIntrinsicWidth(
        style?.fontSize ?? defaultFontSize,
      );
      if (width > leftWidth) {
        s = m;
      } else {
        e = m;
      }
      if (e - s <= 1) {
        endIndex = e;
        break;
      }
    }
    final leftW = _renderParagraph(text.substring(0, startIndex))
        .computeMinIntrinsicWidth(
      style?.fontSize ?? defaultFontSize,
    );
    final rightW = _renderParagraph(text.substring(endIndex, text.length))
        .computeMinIntrinsicWidth(
      style?.fontSize ?? defaultFontSize,
    );

    final margin = tempMaxWidth - leftW - rightW - ellipsisWidth;
    final startNext =
        _renderParagraph(text.substring(startIndex, startIndex + 1))
            .computeMinIntrinsicWidth(
      style?.fontSize ?? defaultFontSize,
    );
    var endBefore = _renderParagraph(text.substring(endIndex - 1, endIndex))
        .computeMinIntrinsicWidth(
      style?.fontSize ?? defaultFontSize,
    );

    /// 总体margin 可以再填下一个字符，将该字符填进去
    if (margin >= startNext && margin >= endBefore) {
      if (startNext >= endBefore) {
        startIndex = startIndex + 1;
      } else {
        endBefore = endBefore - 1;
      }
    } else if (margin >= startNext) {
      startIndex = startIndex + 1;
    } else if (margin >= endBefore) {
      endIndex = endIndex - 1;
    }
    return text.replaceRange(startIndex, endIndex, '...');
  }
}
