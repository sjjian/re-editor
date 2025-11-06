part of re_editor;

typedef PointerEnterEventWithRectListener = void Function(PointerEnterEvent event, int id, List<Rect> rects);

typedef PointerExitEventWithRectListener = void Function(PointerExitEvent event, int id, List<Rect> rects);

@immutable
class MouseTrackerAnnotationTextSpan extends TextSpan {

  final PointerEnterEventWithRectListener onEnterWithRect;
  final PointerExitEventWithRectListener onExitWithRect;

  const MouseTrackerAnnotationTextSpan({
    super.text,
    super.children,
    super.style,
    super.recognizer,
    super.mouseCursor,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
    required this.onEnterWithRect,
    required this.onExitWithRect,
  });

}

@immutable
class _MouseTrackerAnnotationTextSpan extends TextSpan {

  final int id;
  final MouseTrackerAnnotationTextSpan span;
  final List<Rect> rects;

  const _MouseTrackerAnnotationTextSpan({
    required this.id,
    required this.rects,
    required this.span,
  });

  @override
  PointerEnterEventListener? get onEnter => (event) {
    span.onEnterWithRect(event, id, rects);
  };

  @override
  PointerExitEventListener? get onExit => (event) {
    span.onExitWithRect(event, id, rects);
  };

  @override
  int get hashCode => span.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _MouseTrackerAnnotationTextSpan && span == other.span &&
      id == other.id;
  }

}

class CodeLinesTextSpan {
  List<TextSpan> lines;

  CodeLinesTextSpan():lines = [TextSpan(children: [])];

  void add(TextSpan span) {
    span.visitChildren((child) {
      String text = child.toPlainText(); // 获取纯文本
      List<String> ts = text.split(TextLineBreak.lf.value);
      for (var i = 0; i < ts.length; i++) {
        lines.last.children!.add(TextSpan(text: ts[i], style: child.style));
        // 最后一个
        if (i != ts.length -1) {
          lines.add(TextSpan(children: []));
        }
      }
      return true;
    });
  }
}