import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';


class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  _CustomRefreshIndicatorState createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragOffset = 0.0;
  bool _isRefreshing = false;

  static const double _refreshTriggerDistance = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleScrollUpdate(ScrollNotification notification) {
    if (notification is OverscrollNotification && !_isRefreshing) {
      setState(() {
        _dragOffset -= notification.overscroll;
        if (_dragOffset > _refreshTriggerDistance) {
          _startRefresh();
        }
      });
    } else if (notification is ScrollEndNotification) {
      if (_dragOffset < _refreshTriggerDistance && !_isRefreshing) {
        setState(() {
          _dragOffset = 0.0;
        });
      }
    }
  }

  void _startRefresh() {
    setState(() {
      _isRefreshing = true;
      _controller.repeat();
    });

    widget.onRefresh().then((_) {
      setState(() {
        _isRefreshing = false;
        _dragOffset = 0.0;
        _controller.stop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            _handleScrollUpdate(notification);
            return true;
          },
          child: widget.child,
        ),
        if (_dragOffset > 0 || _isRefreshing)
          Positioned(
            top: 20.0,
            left: MediaQuery.of(context).size.width / 2 - 12.0,
            child: RotationTransition(
              turns: _controller,
              child: const Icon(
                Icons.refresh,  // Replace this with your custom icon
                size: 30.0,
                color: kMainColor,
              ),
            ),
          ),
      ],
    );
  }
}