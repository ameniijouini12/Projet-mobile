import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiatunisie/app/style/app_colors.dart';


//! Extensions on Widget
extension WidgetModifier on Widget {
  Positioned positioned({
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? width,
    double? height,
  }) =>
      Positioned(
          left: left,
          right: right,
          top: top,
          bottom: bottom,
          width: width,
          height: height,
          child: this);

  PopScope captureScopePopping(
    void Function(bool)? onPopInvoked, {
    required bool allowPopping,
  }) =>
      PopScope(
        onPopInvoked: (value) => onPopInvoked?.call(value),
        child: this,
      );

  IgnorePointer ignoreWhen(bool ignoring) => IgnorePointer(
        ignoring: ignoring,
        child: this,
      );

  AbsorbPointer absorbWhen(bool absorbing) => AbsorbPointer(
        absorbing: absorbing,
        child: this,
      );

  SafeArea safeArea({
    final bool safeAreaTop = true,
    final bool safeAreaBottom = true,
    final bool safeAreaRight = true,
    final bool safeAreaLeft = true,
    EdgeInsets minimum = EdgeInsets.zero,
    bool maintainBottomViewPadding = false,
  }) =>
      SafeArea(
          top: safeAreaTop,
          bottom: safeAreaBottom,
          right: safeAreaRight,
          left: safeAreaLeft,
          minimum: minimum,
          maintainBottomViewPadding: maintainBottomViewPadding,
          child: this);

  InkWell onTap(
    VoidCallback? onTap, {
    EdgeInsets padding = EdgeInsets.zero,
    double? radius,
    Color overlayColor = AppColors.overlayColor,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(
            Radius.circular(radius ?? 40.r)),
        overlayColor: WidgetStateProperty.all(overlayColor),
        child: Padding(padding: padding, child: this),
      );

  IconButton asIconButton({required VoidCallback onTap}) => IconButton(
        onPressed: onTap,
        icon: this,
      );

  Padding overallPadding([double value = 16]) =>
      Padding(key: key, padding: EdgeInsets.all(value), child: this);

  Padding symmetricPadding({double horizontal = 0, double vertical = 0}) =>
      Padding(
        key: key,
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  Padding customPadding({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) =>
      Padding(
          key: key,
          padding: EdgeInsets.fromLTRB(left, top, right, bottom),
          child: this);

  ClipRRect clipRRect({
    Key? key,
    BorderRadiusGeometry? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) =>
      ClipRRect(
        key: key,
        borderRadius:
            borderRadius ?? BorderRadius.circular(3.r),
        clipper: clipper,
        clipBehavior: clipBehavior,
        child: this,
      );

  Widget center({
    Key? key,
    bool enabled = true,
    double? widthFactor,
    double? heightFactor,
  }) =>
      enabled
          ? Center(
              key: key,
              widthFactor: widthFactor,
              heightFactor: heightFactor,
              child: this)
          : this;

  ColoredBox coloredBox({
    Key? key,
    required Color color,
    bool top = true,
  }) =>
      ColoredBox(key: key, color: color, child: this);

  Visibility visibleWhen(
    bool visible, {
    Key? key,
    Widget replacement = const SizedBox.shrink(),
    bool maintainState = false,
    bool maintainAnimation = false,
    bool maintainSize = false,
    bool maintainSemantics = false,
    bool maintainInteractivity = false,
  }) =>
      Visibility(
        key: key,
        replacement: replacement,
        visible: visible,
        maintainState: maintainState,
        maintainAnimation: maintainAnimation,
        maintainSize: maintainSize,
        maintainSemantics: maintainSemantics,
        maintainInteractivity: maintainInteractivity,
        child: this,
      );

  Visibility hide({Key? key}) =>
      Visibility(key: key, visible: false, child: this);

  SizedBox resize({Key? key, double? width, double? height}) => SizedBox(
        key: key,
        width: width,
        height: height,
        child: this,
      );

  SizedBox squared({Key? key, double? side}) => SizedBox(
        key: key,
        width: side,
        height: side,
        child: this,
      );

  @Deprecated(
      'Opacity is an expensive operation, as is clipping and should be avoided as much as possible,')

  /// ## Performance considerations for opacity animation
  ///
  /// Animating an [Opacity] widget directly causes the widget (and possibly its
  /// subtree) to rebuild each frame, which is not very efficient. Consider using
  /// an [AnimatedOpacity] or a [FadeTransition] instead.
  /// {  https://docs.flutter.dev/perf/best-practices#minimize-use-of-opacity-and-clipping}
  ///
  Opacity opacity(
    double opacity, {
    Key? key,
    bool alwaysIncludeSemantics = false,
  }) =>
      Opacity(
          key: key,
          opacity: opacity,
          alwaysIncludeSemantics: alwaysIncludeSemantics,
          child: this);

  Flexible flexible({Key? key, int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(key: key, flex: flex, fit: fit, child: this);

  Expanded expanded({Key? key, int flex = 1}) =>
      Expanded(key: key, flex: flex, child: this);

  Align align({
    Key? key,
    AlignmentGeometry alignment = Alignment.center,
    double? widthFactor,
    double? heightFactor,
  }) =>
      Align(
          key: key,
          alignment: alignment,
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          child: this);

  /// Creates a widget that scales and positions its child within itself according to [fit].
  FittedBox makeFitted({
    Key? key,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Clip clipBehavior = Clip.none,
  }) =>
      FittedBox(
          key: key,
          fit: fit,
          alignment: alignment,
          clipBehavior: clipBehavior,
          child: this);

  /// Creates a widget that applies an Blur effect to its child.
  Container applyBlur(
          {Key? key,
          double? width,
          double? height,
          double sigmaX = 2.0,
          double sigmaY = 2.0,
          TileMode tileMode = TileMode.clamp,
          bool enabled = true,
          Color? color}) =>
      Container(
        width: width ?? double.infinity,
        height: height,
        color: color,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: sigmaX, sigmaY: sigmaY, tileMode: tileMode),
            child: this,
          ),
        ),
      );

  /// Creates a backdrop filter.
  ///
  /// The [blendMode] argument will default to [BlendMode.srcOver] and must not be
  /// null if provided.
  BackdropFilter backdropFilter({
    Key? key,
    required ImageFilter filter,
    BlendMode blendMode = BlendMode.srcOver,
  }) =>
      BackdropFilter(
          key: key, filter: filter, blendMode: blendMode, child: this);

  /// Creates a widget that paints a [Decoration].
  ///
  /// The [decoration] and [position] arguments must not be null. By default the
  /// decoration paints behind the child.
  DecoratedBox decoratedBox({
    Key? key,
    required Decoration decoration,
    DecorationPosition position = DecorationPosition.background,
  }) =>
      DecoratedBox(
          key: key, decoration: decoration, position: position, child: this);

  /// Creates a widget that paints a [Decoration].
  ///
  /// The [decoration] and [position] arguments must not be null. By default the
  /// decoration paints behind the child.
  DecoratedBox border({
    Key? key,
    BoxBorder? border,
    BorderRadius? borderRadius ,
  }) =>
      DecoratedBox(
        key: key,
        decoration: BoxDecoration(border: border, borderRadius: borderRadius),
        child: this,
      );

  Transform rotate({
    Key? key,
    required double angle,
    Offset? origin,
    AlignmentGeometry? alignment = Alignment.center,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) =>
      Transform.rotate(
        key: key,
        angle: angle,
        origin: origin,
        alignment: alignment,
        transformHitTests: transformHitTests,
        filterQuality: filterQuality,
        child: this,
      );

  RefreshIndicator onRefresh(
    Future<void> Function() onRefresh, {
    Key? key,
    double displacement = 40.0,
    double edgeOffset = 0.0,
    Color? color,
    Color? backgroundColor,
    bool Function(ScrollNotification) notificationPredicate =
        defaultScrollNotificationPredicate,
    String? semanticsLabel,
    String? semanticsValue,
    double strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    RefreshIndicatorTriggerMode triggerMode =
        RefreshIndicatorTriggerMode.onEdge,
  }) =>
      RefreshIndicator(
        displacement: displacement,
        edgeOffset: edgeOffset,
        onRefresh: onRefresh,
        color: color,
        backgroundColor: backgroundColor,
        notificationPredicate: notificationPredicate,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        strokeWidth: strokeWidth,
        triggerMode: triggerMode,
        child: this,
      );
}

//! Extensions on List<Widget>
extension WidgetListPadder on List<Widget> {
  Padding overallPaddding([double value = 16]) =>
      Padding(padding: EdgeInsets.all(value), child: Column(children: this));

  Padding symmetricPadding({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: Column(children: this),
      );

  Padding customPadding({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) =>
      Padding(
          padding: EdgeInsets.fromLTRB(left, top, right, bottom),
          child: Column(children: this));

  Column wrapWithColumn({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) =>
      Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: this);

  Row wrapWithRow({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) =>
      Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: this);
}

//! Extension on String
extension CircleAvatarCreator on String {
  /// Creates a circle that represents a user.
  CircleAvatar convertToCircularAvatar({
    Key? key,
    Color? backgroundColor,
    Color? foregroundColor,
    String? foregroundImage,
  }) =>
      CircleAvatar(
        key: key,
        backgroundColor: backgroundColor ?? Colors.transparent,
        foregroundColor: foregroundColor ?? Colors.transparent,
        backgroundImage: NetworkImage(this),
        foregroundImage:
            (foregroundImage != null) ? NetworkImage(foregroundImage) : null,
      );
}
