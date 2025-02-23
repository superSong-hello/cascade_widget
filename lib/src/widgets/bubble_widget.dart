import 'dart:math';

import 'package:flutter/material.dart';

/// spineHeight : 针尖高度
/// angle : 针尖角度 (角度值)
/// radius : 圆角半径
/// offset : 偏移
/// spineType : 类型
/// color : 颜色
///
/// 宽高由父容器指定: 如
/// Container(
//     height: 50,
//     width: 100,
//     child: Wrapper()
//  )

typedef SpinePathBuilder = Path Function(
  Canvas canvas,
  SpineType spineType,
  Rect range,
);

class BubbleWidget extends StatelessWidget {
  const BubbleWidget({
    super.key,
    this.spineHeight = 8.0,
    this.angle = 75,
    this.radius = 5.0,
    this.offset = 15,
    this.strokeWidth,
    this.child,
    this.elevation,
    this.shadowColor = Colors.grey,
    this.formEnd = false,
    this.color = Colors.green,
    this.spinePathBuilder,
    this.padding = const EdgeInsets.all(8),
    this.spineType = SpineType.left,
  });

  const BubbleWidget.just({
    super.key,
    this.radius = 5.0,
    this.strokeWidth,
    this.child,
    this.elevation,
    this.shadowColor = Colors.grey,
    this.color = Colors.green,
    this.padding = const EdgeInsets.all(8),
  })  : spineHeight = 0,
        angle = 0,
        offset = 0,
        spineType = SpineType.bottom,
        spinePathBuilder = null,
        formEnd = false;
  final double spineHeight;
  final double angle;

  final double radius;
  final double offset;
  final SpineType spineType;
  final Color color;
  final Widget? child;
  final SpinePathBuilder? spinePathBuilder;

  final double? strokeWidth;

  final bool formEnd;
  final EdgeInsets padding;

  final double? elevation;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    var tempPadding = padding;
    switch (spineType) {
      case SpineType.top:
        tempPadding = padding + EdgeInsets.only(top: spineHeight);
      case SpineType.left:
        tempPadding = padding + EdgeInsets.only(left: spineHeight);
      case SpineType.right:
        tempPadding = padding + EdgeInsets.only(right: spineHeight);
      case SpineType.bottom:
        tempPadding = padding + EdgeInsets.only(bottom: spineHeight);
    }

    return CustomPaint(
      painter: WrapperPainter(
        spineHeight: spineHeight,
        angle: angle,
        radius: radius,
        offset: offset,
        strokeWidth: strokeWidth,
        color: color,
        shadowColor: shadowColor,
        elevation: elevation,
        spineType: spineType,
        formBottom: formEnd,
        spinePathBuilder: spinePathBuilder,
      ),
      child: Padding(
        padding: tempPadding,
        child: child,
      ),
    );
  }
}

enum SpineType { top, left, right, bottom }

class WrapperPainter extends CustomPainter {
  WrapperPainter({
    this.spineHeight = 10.0,
    this.angle = 75,
    this.spinePathBuilder,
    this.radius = 5.0,
    this.offset = 15,
    this.elevation,
    this.strokeWidth,
    this.shadowColor = Colors.grey,
    this.color = Colors.green,
    this.formBottom = false,
    this.spineType = SpineType.left,
  }) : mPaint = Paint()
          ..color = color
          ..style =
              strokeWidth == null ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = strokeWidth ?? 1;
  final Paint mPaint;

  Path path = Path();

  final double? strokeWidth;
  final SpinePathBuilder? spinePathBuilder;

  final double? elevation;
  final Color shadowColor;
  final double spineHeight;
  final double angle;
  final bool formBottom;
  final double radius;
  final double offset;
  final SpineType spineType;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    path = buildBoxBySpineType(
      canvas,
      spineType,
      size.width,
      size.height,
    );

    Path? spinePath;

    if (spinePathBuilder == null) {
      spinePath = buildDefaultSpinePath(canvas, spineHeight, spineType, size);
    } else {
      Rect range;
      switch (spineType) {
        case SpineType.top:
          range = Rect.fromLTRB(0, -spineHeight, size.width, 0);
        case SpineType.left:
          range = Rect.fromLTRB(-spineHeight, 0, 0, size.height);
        case SpineType.right:
          range = Rect.fromLTRB(-spineHeight, 0, 0, size.height).translate(
            size.width,
            0,
          );
        case SpineType.bottom:
          range = Rect.fromLTRB(0, 0, size.width, spineHeight).translate(
            0,
            size.height - spineHeight,
          );
      }
      if (spinePathBuilder != null) {
        spinePath = spinePathBuilder!(canvas, spineType, range);
      }
    }

    if (spinePath != null) {
      path = Path.combine(PathOperation.union, spinePath, path);

      if (elevation != null) {
        canvas.drawShadow(path, shadowColor, elevation!, true);
      }
      canvas.drawPath(path, mPaint);
    }
  }

  Path buildDefaultSpinePath(
    Canvas canvas,
    double spineHeight,
    SpineType spineType,
    Size size,
  ) {
    switch (spineType) {
      case SpineType.top:
        return _drawTop(size.width, size.height, canvas);
      case SpineType.left:
        return _drawLeft(size.width, size.height, canvas);
      case SpineType.right:
        return _drawRight(size.width, size.height, canvas);
      case SpineType.bottom:
        return _drawBottom(size.width, size.height, canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  Path _drawTop(double width, double height, Canvas canvas) {
    final angleRad = pi / 180 * angle;
    final spineMoveX = spineHeight * tan(angleRad / 2);
    final spineMoveY = spineHeight;
    if (spineHeight != 0) {
      return Path()
        ..moveTo(!formBottom ? offset : width - offset - spineHeight, 0)
        ..relativeLineTo(spineMoveX, -spineMoveY)
        ..relativeLineTo(spineMoveX, spineMoveY);
    }
    return Path();
  }

  Path _drawBottom(double width, double height, Canvas canvas) {
    final lineHeight = height - spineHeight;
    final angleRad = pi / 180 * angle;
    final spineMoveX = spineHeight * tan(angleRad / 2);
    final spineMoveY = spineHeight;
    if (spineHeight != 0) {
      return Path()
        ..moveTo(
          !formBottom ? offset : width - offset - spineHeight,
          lineHeight,
        )
        ..relativeLineTo(spineMoveX, spineMoveY)
        ..relativeLineTo(spineMoveX, -spineMoveY);
    }
    return Path();
  }

  Path _drawLeft(double width, double height, Canvas canvas) {
    final angleRad = pi / 180 * angle;
    final spineMoveX = spineHeight;
    final spineMoveY = spineHeight * tan(angleRad / 2);
    if (spineHeight != 0) {
      return Path()
        ..moveTo(0, !formBottom ? offset : height - offset - spineHeight)
        ..relativeLineTo(-spineMoveX, spineMoveY)
        ..relativeLineTo(spineMoveX, spineMoveY);
    }
    return Path();
  }

  Path _drawRight(double width, double height, Canvas canvas) {
    final lineWidth = width - spineHeight;
    final angleRad = pi / 180 * angle;
    final spineMoveX = spineHeight;
    final spineMoveY = spineHeight * tan(angleRad / 2);
    if (spineHeight != 0) {
      return Path()
        ..moveTo(
          lineWidth,
          !formBottom ? offset : height - offset - spineHeight,
        )
        ..relativeLineTo(spineMoveX, spineMoveY)
        ..relativeLineTo(-spineMoveX, spineMoveY);
    }
    return Path();
  }

  Path buildBoxBySpineType(
    Canvas canvas,
    SpineType spineType,
    double width,
    double height,
  ) {
    double lineHeight;
    double lineWidth;

    switch (spineType) {
      case SpineType.top:
        lineHeight = height - spineHeight;
        canvas.translate(0, spineHeight);
        lineWidth = width;
      case SpineType.left:
        lineWidth = width - spineHeight;
        lineHeight = height;
        canvas.translate(spineHeight, 0);
      case SpineType.right:
        lineWidth = width - spineHeight;
        lineHeight = height;
      case SpineType.bottom:
        lineHeight = height - spineHeight;
        lineWidth = width;
    }

    final box = Rect.fromCenter(
      center: Offset(lineWidth / 2, lineHeight / 2),
      width: lineWidth,
      height: lineHeight,
    );

    return Path()..addRRect(RRect.fromRectXY(box, radius, radius));
  }
}
