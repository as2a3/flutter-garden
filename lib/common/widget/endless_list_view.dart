import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EndlessListView extends StatefulWidget {
  final int length;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Function(int) buildItemWidget;
  final VoidCallback? onScrollToTop;
  final VoidCallback? onScrollToEnd;
  final Function(ScrollDirection)? scrollDirectionListener;

  const EndlessListView({
    Key? key,
    required this.length,
    required this.buildItemWidget,
    this.shrinkWrap = false,
    this.onScrollToTop,
    this.onScrollToEnd,
    this.scrollDirectionListener,
    this.physics,
  }) : super(key: key);

  @override
  _EndlessListViewState createState() => _EndlessListViewState();
}

class _EndlessListViewState extends State<EndlessListView> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(listenScrolling);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void listenScrolling() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels != 0) {
        widget.onScrollToEnd?.call();
      } else {
        widget.onScrollToTop?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        widget.scrollDirectionListener?.call(notification.direction);
        return true;
      },
      child: ListView.builder(
        shrinkWrap: widget.shrinkWrap,
        controller: scrollController,
        // physics: const AlwaysScrollableScrollPhysics(),
        physics: widget.physics,
        itemCount: widget.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return widget.buildItemWidget(index) as Widget;
        },
      ),
    );
  }
}
