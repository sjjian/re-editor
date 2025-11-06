part of re_editor;

typedef CodeScrollbarBuilder = Widget Function(BuildContext context, Widget child, ScrollableDetails details);

class CodeScrollController {

  final ScrollController verticalScroller;
  final ScrollController horizontalScroller;

  GlobalKey? _editorKey;

  CodeScrollController({
    ScrollController? verticalScroller,
    ScrollController? horizontalScroller,
  }) : verticalScroller = verticalScroller ?? ScrollController(),
    horizontalScroller = horizontalScroller ?? ScrollController();

  void makeCenterIfInvisible(CodeLinePosition position) {
    _render?.makePositionCenterIfInvisible(position);
  }

  void makeVisible(CodeLinePosition position) {
    _render?.makePositionVisible(position);
  }

  void bindEditor(GlobalKey key) {
    _editorKey = key;
  }

  _CodeFieldRender? get _render => _editorKey?.currentContext?.findRenderObject() as _CodeFieldRender?;

  void dispose() {
    _editorKey = null;
  }

}

const double _kScrollbarThickness = 8.0;

class _ScrollBehavior extends MaterialScrollBehavior {

  final _ScrollPhysics physics;
  final CodeScrollbarBuilder? scrollbarBuilder;

  _ScrollBehavior(this.scrollbarBuilder) : physics = _ScrollPhysics();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    final Widget? scrollbar = scrollbarBuilder?.call(context, child, details);
    if (scrollbar != null) {
      return scrollbar;
    }
    final ScrollbarOrientation? orientation;
    if (details.direction == AxisDirection.down) {
      orientation = ScrollbarOrientation.right;
    } else if (details.direction == AxisDirection.right) {
      orientation = ScrollbarOrientation.bottom;
    } else {
      orientation = null;
    }
    if (kIsAndroid || kIsIOS) {
      return Scrollbar(
        controller: details.controller,
        scrollbarOrientation: orientation,
        thumbVisibility: details.direction == AxisDirection.down,
        child: child,
      );
    }
    return _RawScrollbar(
      physics: physics,
      controller: details.controller ?? ScrollController(),
      scrollbarOrientation: orientation,
      thumbVisibility: details.direction == AxisDirection.down,
      child: child,
    );
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return physics;
  }

}

class _RawScrollbar extends RawScrollbar {

  final _ScrollPhysics physics;

  const _RawScrollbar({
    required this.physics,
    required Widget child,
    required ScrollController controller,
    ScrollbarOrientation? scrollbarOrientation,
    required bool thumbVisibility,
  }) : super(
    controller: controller,
    scrollbarOrientation: scrollbarOrientation,
    thumbVisibility: thumbVisibility,
    thickness: _kScrollbarThickness,
    radius: const Radius.circular(10),
    crossAxisMargin: 2,
    child: child,
  );

  @override
  RawScrollbarState<_RawScrollbar> createState() => _RawScrollbarState();

}

class _RawScrollbarState extends RawScrollbarState<_RawScrollbar> {

  Offset? downPosition;
  double? downOffset;

  @override
  void handleThumbPressStart(ui.Offset localPosition) {
    downPosition = localPosition;
    downOffset = widget.controller!.offset;
    super.handleThumbPressStart(localPosition);
  }

  @override
  void handleThumbPressUpdate(Offset localPosition) {
    if (getScrollbarDirection() == Axis.vertical) {
      widget.physics.setScrollPosition(downOffset! + scrollbarPainter.getTrackToScroll(localPosition.dy - downPosition!.dy));
    }
    super.handleThumbPressUpdate(localPosition);
  }

}

// ignore: must_be_immutable
class _ScrollPhysics extends ScrollPhysics {

  double? _position;

  void setScrollPosition(double position) {
    _position = position;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (_position == null) {
      return super.applyBoundaryConditions(position, value);
    }
    return value - _position!;
  }

}