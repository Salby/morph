import 'package:flutter/material.dart';
import '../utils/offset_to_alignment.dart';

/// PageRouteBuilder that uses a parent-child transition.
///
/// [parentKey] is a key that is attached to the widget you
/// want to animate from.
/// You can change the duration if you want to adjust the
/// speed of the transition.
class MorpheusPageRoute extends PageRoute {
  MorpheusPageRoute({
    @required this.builder,
    @required this.parentKey,
    this.transitionDuration = const Duration(milliseconds: 600),
    this.elevation = 8.0,
    this.scrimColor = Colors.transparent,
  })  : renderBoxOffset = _getOffset(parentKey),
        renderBoxSize = _getSize(parentKey);

  final WidgetBuilder builder;
  final GlobalKey parentKey;
  final double elevation;
  final Color scrimColor;
  final Offset renderBoxOffset;
  final Size renderBoxSize;

  static RenderBox _findRenderBox(GlobalKey parentKey) =>
      parentKey.currentContext.findRenderObject();

  static Offset _getOffset(GlobalKey parentKey) {
    return _findRenderBox(parentKey).localToGlobal(Offset.zero);
  }

  static Size _getSize(GlobalKey parentKey) {
    return _findRenderBox(parentKey).size;
  }

  Size _getSizePercent(BuildContext context) {
    final Size displaySize = MediaQuery.of(context).size;
    final Size boxSize = renderBoxSize;
    final percentSize = Size(
      boxSize.width != displaySize.width
          ? boxSize.width / displaySize.width
          : 1.0,
      boxSize.height != displaySize.height
          ? boxSize.height / displaySize.height
          : 1.0,
    );
    return percentSize;
  }

  Alignment _getAlignment(BuildContext context) {
    final Size displaySize = MediaQuery.of(context).size;
    final Alignment alignment = offsetToAlignment(
        renderBoxOffset,
        Size(displaySize.width - renderBoxSize.width,
            displaySize.height - renderBoxSize.height));
    return alignment;
  }

  @override
  final Duration transitionDuration;

  @override
  final bool opaque = true;

  @override
  final bool barrierDismissible = false;

  @override
  final Color barrierColor = null;

  @override
  final String barrierLabel = null;

  @override
  final bool maintainState = true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Builder(builder: builder);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Container(
      color: ColorTween(
        begin: scrimColor.withOpacity(0.0),
        end: scrimColor,
      )
          .animate(CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.2,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
            reverseCurve: Interval(
              0.2,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ))
          .value,
      child: Align(
        alignment: _getAlignment(context),
        child: FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.0,
              0.4,
              curve: Curves.fastOutSlowIn,
            ),
            reverseCurve: Interval(
              0.0,
              0.4,
              curve: Curves.fastOutSlowIn,
            ),
          )),
          child: Material(
            type: MaterialType.card,
            elevation: Tween<double>(
              begin: 0.0,
              end: elevation,
            )
                .animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                  reverseCurve: Curves.fastOutSlowIn,
                ))
                .value,
            child: SizeTransition(
              sizeFactor: Tween<double>(
                begin: _getSizePercent(context).height,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.2,
                  1.0,
                  curve: Curves.fastOutSlowIn,
                ),
                reverseCurve: Interval(
                  0.2,
                  1.0,
                  curve: Curves.fastOutSlowIn,
                ),
              )),
              child: SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: Tween<double>(
                  begin: _getSizePercent(context).width,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Interval(
                    0.2,
                    1.0,
                    curve: Curves.fastOutSlowIn,
                  ),
                  reverseCurve: Interval(
                    0.2,
                    1.0,
                    curve: Curves.fastOutSlowIn,
                  ),
                )),
                child: FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Interval(
                      0.4,
                      0.8,
                      curve: Curves.fastOutSlowIn,
                    ),
                    reverseCurve: Interval(
                      0.4,
                      0.8,
                      curve: Curves.fastOutSlowIn,
                    ),
                  )),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}