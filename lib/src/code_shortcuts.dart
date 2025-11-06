part of re_editor;

enum CodeShortcutType {
  selectAll,
  cut,
  copy,
  paste,
  delete,
  backspace,
  undo,
  redo,
  lineSelect,
  lineDelete,
  lineDeleteForward,
  lineDeleteBackward,
  lineMoveUp,
  lineMoveDown,
  cursorMoveUp,
  cursorMoveDown,
  cursorMoveForward,
  cursorMoveBackward,
  cursorMoveLineStart,
  cursorMoveLineEnd,
  cursorMovePageStart,
  cursorMovePageEnd,
  cursorMovePageUp,
  cursorMovePageDown,
  cursorMoveWordBoundaryForward,
  cursorMoveWordBoundaryBackward,
  selectionExtendUp,
  selectionExtendDown,
  selectionExtendForward,
  selectionExtendBackward,
  selectionExtendLineStart,
  selectionExtendLineEnd,
  selectionExtendPageStart,
  selectionExtendPageEnd,
  selectionExtendWordBoundaryForward,
  selectionExtendWordBoundaryBackward,
  wordDeleteForward,
  wordDeleteBackward,
  indent,
  outdent,
  newLine,
  transposeCharacters,
  singleLineComment,
  multiLineComment,
  find,
  findToggleMatchCase,
  findToggleRegex,
  replace,
  save,
  esc,
}

abstract class CodeShortcutsActivatorsBuilder {

  const CodeShortcutsActivatorsBuilder();

  List<ShortcutActivator>? build(CodeShortcutType type);

}

class DefaultCodeShortcutsActivatorsBuilder extends CodeShortcutsActivatorsBuilder {

  const DefaultCodeShortcutsActivatorsBuilder();

  @override
  List<ShortcutActivator>? build(CodeShortcutType type) {
    return kIsMacOS ? _kDefaultMacCodeShortcutsActivators[type] :
      _kDefaultCommonCodeShortcutsActivators[type];
  }

}

abstract class CodeShortcutEditableIntent extends Intent {
  const CodeShortcutEditableIntent();
}

class CodeShortcutSelectAllIntent extends Intent {
  const CodeShortcutSelectAllIntent();
}

class CodeShortcutCopyIntent extends Intent {
  const CodeShortcutCopyIntent();
}

class CodeShortcutCutIntent extends CodeShortcutEditableIntent {
  const CodeShortcutCutIntent();
}

class CodeShortcutPasteIntent extends CodeShortcutEditableIntent {
  const CodeShortcutPasteIntent();
}

class CodeShortcutUndoIntent extends CodeShortcutEditableIntent {
  const CodeShortcutUndoIntent();
}

class CodeShortcutRedoIntent extends CodeShortcutEditableIntent {
  const CodeShortcutRedoIntent();
}

class CodeShortcutLineSelectIntent extends Intent {
  const CodeShortcutLineSelectIntent();
}

class ShortcutLineDeleteIntent extends CodeShortcutEditableIntent {
  const ShortcutLineDeleteIntent();
}

class ShortcutLineMoveIntent extends CodeShortcutEditableIntent {
  final VerticalDirection direction;
  const ShortcutLineMoveIntent(this.direction);
}

class ShortcutLineDeleteDirectionIntent extends CodeShortcutEditableIntent {
  final bool forward;
  const ShortcutLineDeleteDirectionIntent(this.forward);
}

class CodeShortcutIndentIntent extends CodeShortcutEditableIntent {
  const CodeShortcutIndentIntent();
}

class CodeShortcutOutdentIntent extends CodeShortcutEditableIntent {
  const CodeShortcutOutdentIntent();
}

class CodeShortcutCommentIntent extends CodeShortcutEditableIntent {
  final bool single;
  const CodeShortcutCommentIntent(this.single);
}

class CodeShortcutCursorMoveIntent extends Intent {
  final AxisDirection direction;
  const CodeShortcutCursorMoveIntent(this.direction);
}

class CodeShortcutCursorMoveLineEdgeIntent extends Intent {
  final bool forward;
  const CodeShortcutCursorMoveLineEdgeIntent(this.forward);
}

class CodeShortcutCursorMoveDocEdgeIntent extends Intent {
  final bool forward;
  const CodeShortcutCursorMoveDocEdgeIntent(this.forward);
}

class CodeShortcutCursorMovePageIntent extends Intent {
  final bool forward;
  const CodeShortcutCursorMovePageIntent(this.forward);
}

class CodeShortcutCursorMoveWordBoundaryIntent extends Intent {
  final bool forward;
  const CodeShortcutCursorMoveWordBoundaryIntent(this.forward);
}

class CodeShortcutSelectionExtendIntent extends Intent {
  final AxisDirection direction;
  const CodeShortcutSelectionExtendIntent(this.direction);
}

class CodeShortcutSelectionExtendLineEdgeIntent extends Intent {
  final bool forward;
  const CodeShortcutSelectionExtendLineEdgeIntent(this.forward);
}

class CodeShortcutSelectionExtendPageEdgeIntent extends Intent {
  final bool forward;
  const CodeShortcutSelectionExtendPageEdgeIntent(this.forward);
}

class CodeShortcutSelectionExtendWordBoundaryIntent extends Intent {
  final bool forward;
  const CodeShortcutSelectionExtendWordBoundaryIntent(this.forward);
}

class ShortcutWordDeleteDirectionIntent extends CodeShortcutEditableIntent {
  final bool forward;
  const ShortcutWordDeleteDirectionIntent(this.forward);
}

class CodeShortcutDeleteIntent extends CodeShortcutEditableIntent {
  final bool forward;
  const CodeShortcutDeleteIntent(this.forward);
}

class CodeShortcutNewLineIntent extends CodeShortcutEditableIntent {
  const CodeShortcutNewLineIntent();
}

class CodeShortcutTransposeCharactersIntent extends CodeShortcutEditableIntent {
  const CodeShortcutTransposeCharactersIntent();
}

class CodeShortcutFindIntent extends Intent {
  const CodeShortcutFindIntent();
}

class CodeShortcutFindToggleMatchCaseIntent extends Intent {
  const CodeShortcutFindToggleMatchCaseIntent();
}

class CodeShortcutFindToggleRegexIntent extends Intent {
  const CodeShortcutFindToggleRegexIntent();
}

class CodeShortcutReplaceIntent extends CodeShortcutEditableIntent {
  const CodeShortcutReplaceIntent();
}

class CodeShortcutSaveIntent extends Intent {
  const CodeShortcutSaveIntent();
}

class CodeShortcutEscIntent extends Intent {
  const CodeShortcutEscIntent();
}

const Map<CodeShortcutType, Intent> kCodeShortcutIntents = {
  CodeShortcutType.selectAll: CodeShortcutSelectAllIntent(),
  CodeShortcutType.cut: CodeShortcutCutIntent(),
  CodeShortcutType.copy: CodeShortcutCopyIntent(),
  CodeShortcutType.paste: CodeShortcutPasteIntent(),
  CodeShortcutType.delete: CodeShortcutDeleteIntent(true),
  CodeShortcutType.backspace: CodeShortcutDeleteIntent(false),
  CodeShortcutType.undo: CodeShortcutUndoIntent(),
  CodeShortcutType.redo: CodeShortcutRedoIntent(),
  CodeShortcutType.lineSelect: CodeShortcutLineSelectIntent(),
  CodeShortcutType.lineDelete: ShortcutLineDeleteIntent(),
  CodeShortcutType.lineDeleteForward: ShortcutLineDeleteDirectionIntent(true),
  CodeShortcutType.lineDeleteBackward: ShortcutLineDeleteDirectionIntent(false),
  CodeShortcutType.lineMoveUp: ShortcutLineMoveIntent(VerticalDirection.up),
  CodeShortcutType.lineMoveDown: ShortcutLineMoveIntent(VerticalDirection.down),
  CodeShortcutType.cursorMoveUp: CodeShortcutCursorMoveIntent(AxisDirection.up),
  CodeShortcutType.cursorMoveDown: CodeShortcutCursorMoveIntent(AxisDirection.down),
  CodeShortcutType.cursorMoveForward: CodeShortcutCursorMoveIntent(AxisDirection.right),
  CodeShortcutType.cursorMoveBackward: CodeShortcutCursorMoveIntent(AxisDirection.left),
  CodeShortcutType.cursorMoveLineStart: CodeShortcutCursorMoveLineEdgeIntent(false),
  CodeShortcutType.cursorMoveLineEnd: CodeShortcutCursorMoveLineEdgeIntent(true),
  CodeShortcutType.cursorMovePageStart: CodeShortcutCursorMoveDocEdgeIntent(false),
  CodeShortcutType.cursorMovePageEnd: CodeShortcutCursorMoveDocEdgeIntent(true),
  CodeShortcutType.cursorMovePageUp: CodeShortcutCursorMovePageIntent(false),
  CodeShortcutType.cursorMovePageDown: CodeShortcutCursorMovePageIntent(true),
  CodeShortcutType.cursorMoveWordBoundaryForward: CodeShortcutCursorMoveWordBoundaryIntent(true),
  CodeShortcutType.cursorMoveWordBoundaryBackward: CodeShortcutCursorMoveWordBoundaryIntent(false),
  CodeShortcutType.selectionExtendUp: CodeShortcutSelectionExtendIntent(AxisDirection.up),
  CodeShortcutType.selectionExtendDown: CodeShortcutSelectionExtendIntent(AxisDirection.down),
  CodeShortcutType.selectionExtendForward: CodeShortcutSelectionExtendIntent(AxisDirection.right),
  CodeShortcutType.selectionExtendBackward: CodeShortcutSelectionExtendIntent(AxisDirection.left),
  CodeShortcutType.selectionExtendLineStart: CodeShortcutSelectionExtendLineEdgeIntent(false),
  CodeShortcutType.selectionExtendLineEnd: CodeShortcutSelectionExtendLineEdgeIntent(true),
  CodeShortcutType.selectionExtendPageStart: CodeShortcutSelectionExtendPageEdgeIntent(false),
  CodeShortcutType.selectionExtendPageEnd: CodeShortcutSelectionExtendPageEdgeIntent(true),
  CodeShortcutType.selectionExtendWordBoundaryForward: CodeShortcutSelectionExtendWordBoundaryIntent(true),
  CodeShortcutType.selectionExtendWordBoundaryBackward: CodeShortcutSelectionExtendWordBoundaryIntent(false),
  CodeShortcutType.wordDeleteForward: ShortcutWordDeleteDirectionIntent(true),
  CodeShortcutType.wordDeleteBackward: ShortcutWordDeleteDirectionIntent(false),
  CodeShortcutType.indent: CodeShortcutIndentIntent(),
  CodeShortcutType.outdent: CodeShortcutOutdentIntent(),
  CodeShortcutType.newLine: CodeShortcutNewLineIntent(),
  CodeShortcutType.transposeCharacters: CodeShortcutTransposeCharactersIntent(),
  CodeShortcutType.singleLineComment: CodeShortcutCommentIntent(true),
  CodeShortcutType.multiLineComment: CodeShortcutCommentIntent(false),
  CodeShortcutType.find: CodeShortcutFindIntent(),
  CodeShortcutType.findToggleMatchCase: CodeShortcutFindToggleMatchCaseIntent(),
  CodeShortcutType.findToggleRegex: CodeShortcutFindToggleRegexIntent(),
  CodeShortcutType.replace: CodeShortcutReplaceIntent(),
  CodeShortcutType.save: CodeShortcutSaveIntent(),
  CodeShortcutType.esc: CodeShortcutEscIntent(),
};

const Map<CodeShortcutType, List<ShortcutActivator>> _kDefaultMacCodeShortcutsActivators = {
  CodeShortcutType.selectAll: [
    SingleActivator(LogicalKeyboardKey.keyA, meta: true)
  ],
  CodeShortcutType.cut: [
    SingleActivator(LogicalKeyboardKey.keyX, meta: true)
  ],
  CodeShortcutType.copy: [
    SingleActivator(LogicalKeyboardKey.keyC, meta: true)
  ],
  CodeShortcutType.paste: [
    SingleActivator(LogicalKeyboardKey.keyV, meta: true)
  ],
  CodeShortcutType.delete: [
    SingleActivator(LogicalKeyboardKey.delete,),
    SingleActivator(LogicalKeyboardKey.delete, shift: true),
  ],
  CodeShortcutType.backspace: [
    SingleActivator(LogicalKeyboardKey.backspace,),
    SingleActivator(LogicalKeyboardKey.backspace, shift: true),
  ],
  CodeShortcutType.undo: [
    SingleActivator(LogicalKeyboardKey.keyZ, meta: true)
  ],
  CodeShortcutType.redo: [
    SingleActivator(LogicalKeyboardKey.keyZ, meta: true, shift: true)
  ],
  CodeShortcutType.lineSelect: [
    SingleActivator(LogicalKeyboardKey.keyL, meta: true)
  ],
  CodeShortcutType.lineDelete: [
    SingleActivator(LogicalKeyboardKey.keyD, meta: true)
  ],
  CodeShortcutType.lineDeleteForward: [
    SingleActivator(LogicalKeyboardKey.delete, meta: true)
  ],
  CodeShortcutType.lineDeleteBackward: [
    SingleActivator(LogicalKeyboardKey.backspace, meta: true)
  ],
  CodeShortcutType.lineMoveUp: [
    SingleActivator(LogicalKeyboardKey.arrowUp, alt: true)
  ],
  CodeShortcutType.lineMoveDown: [
    SingleActivator(LogicalKeyboardKey.arrowDown, alt: true)
  ],
  CodeShortcutType.cursorMoveUp: [
    SingleActivator(LogicalKeyboardKey.arrowUp)
  ],
  CodeShortcutType.cursorMoveDown: [
    SingleActivator(LogicalKeyboardKey.arrowDown)
  ],
  CodeShortcutType.cursorMoveForward: [
    SingleActivator(LogicalKeyboardKey.arrowRight)
  ],
  CodeShortcutType.cursorMoveBackward: [
    SingleActivator(LogicalKeyboardKey.arrowLeft)
  ],
  CodeShortcutType.cursorMoveLineStart: [
    SingleActivator(LogicalKeyboardKey.arrowLeft, meta: true),
    SingleActivator(LogicalKeyboardKey.home)
  ],
  CodeShortcutType.cursorMoveLineEnd: [
    SingleActivator(LogicalKeyboardKey.arrowRight, meta: true),
    SingleActivator(LogicalKeyboardKey.end),
  ],
  CodeShortcutType.cursorMovePageStart: [
    SingleActivator(LogicalKeyboardKey.arrowUp, meta: true),
    SingleActivator(LogicalKeyboardKey.home, control: true)
  ],
  CodeShortcutType.cursorMovePageEnd: [
    SingleActivator(LogicalKeyboardKey.arrowDown, meta: true),
    SingleActivator(LogicalKeyboardKey.end, control: true)
  ],
  CodeShortcutType.cursorMoveWordBoundaryBackward: [
    SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true)
  ],
  CodeShortcutType.cursorMoveWordBoundaryForward: [
    SingleActivator(LogicalKeyboardKey.arrowRight, alt: true)
  ],
  CodeShortcutType.selectionExtendUp: [
    SingleActivator(LogicalKeyboardKey.arrowUp, shift: true)
  ],
  CodeShortcutType.selectionExtendDown: [
    SingleActivator(LogicalKeyboardKey.arrowDown, shift: true)
  ],
  CodeShortcutType.selectionExtendForward: [
    SingleActivator(LogicalKeyboardKey.arrowRight, shift: true)
  ],
  CodeShortcutType.selectionExtendBackward: [
    SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true)
  ],
  CodeShortcutType.selectionExtendPageStart: [
    SingleActivator(LogicalKeyboardKey.arrowUp, shift: true, meta: true),
    SingleActivator(LogicalKeyboardKey.home, shift: true, meta: true)
  ],
  CodeShortcutType.selectionExtendPageEnd: [
    SingleActivator(LogicalKeyboardKey.arrowDown, shift: true, meta: true),
    SingleActivator(LogicalKeyboardKey.end, shift: true, meta: true)
  ],
  CodeShortcutType.selectionExtendLineStart: [
    SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true, meta: true),
    SingleActivator(LogicalKeyboardKey.home, shift: true)
  ],
  CodeShortcutType.selectionExtendLineEnd: [
    SingleActivator(LogicalKeyboardKey.arrowRight, shift: true, meta: true),
    SingleActivator(LogicalKeyboardKey.end, shift: true)
  ],
  CodeShortcutType.selectionExtendWordBoundaryForward: [
    SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true, alt: true)
  ],
  CodeShortcutType.selectionExtendWordBoundaryBackward: [
    SingleActivator(LogicalKeyboardKey.arrowRight, shift: true, alt: true)
  ],
  CodeShortcutType.wordDeleteForward: [
    SingleActivator(LogicalKeyboardKey.delete, alt: true),
    SingleActivator(LogicalKeyboardKey.delete, alt: true, shift: true),
    SingleActivator(LogicalKeyboardKey.delete, meta: true, shift: true)
  ],
  CodeShortcutType.wordDeleteBackward: [
    SingleActivator(LogicalKeyboardKey.backspace, alt: true),
    SingleActivator(LogicalKeyboardKey.backspace, alt: true, shift: true),
    SingleActivator(LogicalKeyboardKey.backspace, meta: true, shift: true)
  ],
  CodeShortcutType.indent: [
    SingleActivator(LogicalKeyboardKey.tab)
  ],
  CodeShortcutType.outdent: [
    SingleActivator(LogicalKeyboardKey.tab, shift: true)
  ],
  CodeShortcutType.newLine: [
    SingleActivator(LogicalKeyboardKey.enter),
    SingleActivator(LogicalKeyboardKey.enter, shift: true),
    SingleActivator(LogicalKeyboardKey.enter, meta: true),
    SingleActivator(LogicalKeyboardKey.enter, meta: true, shift: true)
  ],
  CodeShortcutType.transposeCharacters: [
    SingleActivator(LogicalKeyboardKey.keyT, control: true)
  ],
  CodeShortcutType.singleLineComment: [
    SingleActivator(LogicalKeyboardKey.slash, meta: true)
  ],
  CodeShortcutType.multiLineComment: [
    SingleActivator(LogicalKeyboardKey.slash, meta: true, shift: true)
  ],
  CodeShortcutType.find: [
    SingleActivator(LogicalKeyboardKey.keyF, meta: true)
  ],
  CodeShortcutType.findToggleMatchCase: [
    SingleActivator(LogicalKeyboardKey.keyC, meta: true, alt: true)
  ],
  CodeShortcutType.findToggleRegex: [
    SingleActivator(LogicalKeyboardKey.keyR, meta: true, alt: true)
  ],
  CodeShortcutType.replace: [
    SingleActivator(LogicalKeyboardKey.keyF, meta: true, alt: true)
  ],
  CodeShortcutType.save: [
    SingleActivator(LogicalKeyboardKey.keyS, meta: true)
  ],
  CodeShortcutType.esc: [
    SingleActivator(LogicalKeyboardKey.escape)
  ],
};

const Map<CodeShortcutType, List<ShortcutActivator>> _kDefaultCommonCodeShortcutsActivators = {
  CodeShortcutType.selectAll: [
    SingleActivator(LogicalKeyboardKey.keyA, control: true)
  ],
  CodeShortcutType.cut: [
    SingleActivator(LogicalKeyboardKey.keyX, control: true)
  ],
  CodeShortcutType.copy: [
    SingleActivator(LogicalKeyboardKey.keyC, control: true)
  ],
  CodeShortcutType.paste: [
    SingleActivator(LogicalKeyboardKey.keyV, control: true)
  ],
  CodeShortcutType.delete: [
    SingleActivator(LogicalKeyboardKey.delete,),
    SingleActivator(LogicalKeyboardKey.delete, shift: true),
  ],
  CodeShortcutType.backspace: [
    SingleActivator(LogicalKeyboardKey.backspace,),
    SingleActivator(LogicalKeyboardKey.backspace, shift: true),
  ],
  CodeShortcutType.undo: [
    SingleActivator(LogicalKeyboardKey.keyZ, control: true)
  ],
  CodeShortcutType.redo: [
    SingleActivator(LogicalKeyboardKey.keyZ, control: true, shift: true)
  ],
  CodeShortcutType.lineSelect: [
    SingleActivator(LogicalKeyboardKey.keyL, control: true)
  ],
  CodeShortcutType.lineDelete: [
    SingleActivator(LogicalKeyboardKey.keyD, control: true)
  ],
  CodeShortcutType.lineDeleteForward: [
    SingleActivator(LogicalKeyboardKey.delete, control: true)
  ],
  CodeShortcutType.lineDeleteBackward: [
    SingleActivator(LogicalKeyboardKey.backspace, control: true)
  ],
  CodeShortcutType.lineMoveUp: [
    SingleActivator(LogicalKeyboardKey.arrowUp, alt: true)
  ],
  CodeShortcutType.lineMoveDown: [
    SingleActivator(LogicalKeyboardKey.arrowDown, alt: true)
  ],
  CodeShortcutType.cursorMoveUp: [
    SingleActivator(LogicalKeyboardKey.arrowUp)
  ],
  CodeShortcutType.cursorMoveDown: [
    SingleActivator(LogicalKeyboardKey.arrowDown)
  ],
  CodeShortcutType.cursorMoveForward: [
    SingleActivator(LogicalKeyboardKey.arrowRight)
  ],
  CodeShortcutType.cursorMoveBackward: [
    SingleActivator(LogicalKeyboardKey.arrowLeft)
  ],
  CodeShortcutType.cursorMoveLineStart: [
    SingleActivator(LogicalKeyboardKey.arrowLeft, control: true),
    SingleActivator(LogicalKeyboardKey.home)
  ],
  CodeShortcutType.cursorMoveLineEnd: [
    SingleActivator(LogicalKeyboardKey.arrowRight, control: true),
    SingleActivator(LogicalKeyboardKey.end)
  ],
  CodeShortcutType.cursorMovePageStart: [
    SingleActivator(LogicalKeyboardKey.arrowUp, control: true),
    SingleActivator(LogicalKeyboardKey.home, control: true)
  ],
  CodeShortcutType.cursorMovePageEnd: [
    SingleActivator(LogicalKeyboardKey.arrowDown, control: true),
    SingleActivator(LogicalKeyboardKey.end, control: true)
  ],
  CodeShortcutType.cursorMoveWordBoundaryBackward: [
    SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true)
  ],
  CodeShortcutType.cursorMoveWordBoundaryForward: [
    SingleActivator(LogicalKeyboardKey.arrowRight, alt: true)
  ],
  CodeShortcutType.selectionExtendUp: [
    SingleActivator(LogicalKeyboardKey.arrowUp, shift: true)
  ],
  CodeShortcutType.selectionExtendDown: [
    SingleActivator(LogicalKeyboardKey.arrowDown, shift: true)
  ],
  CodeShortcutType.selectionExtendForward: [
    SingleActivator(LogicalKeyboardKey.arrowRight, shift: true)
  ],
  CodeShortcutType.selectionExtendBackward: [
    SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true)
  ],
  CodeShortcutType.selectionExtendPageStart: [
    SingleActivator(LogicalKeyboardKey.home, shift: true, control: true)
  ],
  CodeShortcutType.selectionExtendPageEnd: [
    SingleActivator(LogicalKeyboardKey.end, shift: true, control: true)
  ],
  CodeShortcutType.selectionExtendLineStart: [
    SingleActivator(LogicalKeyboardKey.home, shift: true)
  ],
  CodeShortcutType.selectionExtendLineEnd: [
    SingleActivator(LogicalKeyboardKey.end, shift: true)
  ],
  CodeShortcutType.selectionExtendWordBoundaryForward: [
    SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true, alt: true)
  ],
  CodeShortcutType.selectionExtendWordBoundaryBackward: [
    SingleActivator(LogicalKeyboardKey.arrowRight, shift: true, alt: true)
  ],
  CodeShortcutType.wordDeleteForward: [
    SingleActivator(LogicalKeyboardKey.delete, alt: true),
    SingleActivator(LogicalKeyboardKey.delete, alt: true, shift: true),
    SingleActivator(LogicalKeyboardKey.delete, control: true),
  ],
  CodeShortcutType.wordDeleteBackward: [
    SingleActivator(LogicalKeyboardKey.backspace, alt: true),
    SingleActivator(LogicalKeyboardKey.backspace, alt: true, shift: true),
    SingleActivator(LogicalKeyboardKey.backspace, control: true),
  ],
  CodeShortcutType.indent: [
    SingleActivator(LogicalKeyboardKey.tab)
  ],
  CodeShortcutType.outdent: [
    SingleActivator(LogicalKeyboardKey.tab, shift: true)
  ],
  CodeShortcutType.newLine: [
    SingleActivator(LogicalKeyboardKey.enter),
    SingleActivator(LogicalKeyboardKey.enter, shift: true),
    SingleActivator(LogicalKeyboardKey.enter, control: true),
    SingleActivator(LogicalKeyboardKey.enter, control: true, shift: true)
  ],
  CodeShortcutType.transposeCharacters: [
    SingleActivator(LogicalKeyboardKey.keyT, control: true)
  ],
  CodeShortcutType.singleLineComment: [
    SingleActivator(LogicalKeyboardKey.slash, control: true)
  ],
  CodeShortcutType.multiLineComment: [
    SingleActivator(LogicalKeyboardKey.slash, control: true, shift: true)
  ],
  CodeShortcutType.find: [
    SingleActivator(LogicalKeyboardKey.keyF, control: true)
  ],
  CodeShortcutType.findToggleMatchCase: [
    SingleActivator(LogicalKeyboardKey.keyC, control: true, alt: true)
  ],
  CodeShortcutType.findToggleRegex: [
    SingleActivator(LogicalKeyboardKey.keyR, control: true, alt: true)
  ],
  CodeShortcutType.replace: [
    SingleActivator(LogicalKeyboardKey.keyF, control: true, alt: true)
  ],
  CodeShortcutType.save: [
    SingleActivator(LogicalKeyboardKey.keyS, control: true)
  ],
  CodeShortcutType.esc: [
    SingleActivator(LogicalKeyboardKey.escape)
  ],
};

class _CodeShortcuts extends StatefulWidget {

  final CodeShortcutsActivatorsBuilder builder;
  final Widget child;

  const _CodeShortcuts({
    required this.builder,
    required this.child
  });

  @override
  State<StatefulWidget> createState() => _CodeShortcutsState();

}

class _CodeShortcutsState extends State<_CodeShortcuts> {

  late final Map<ShortcutActivator, Intent> _shortcuts;

  @override
  void initState() {
    super.initState();
    _shortcuts = {};
    _buildShortcuts();
  }

  @override
  void didUpdateWidget (_CodeShortcuts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.builder != widget.builder) {
      _buildShortcuts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: widget.child
    );
  }

  void _buildShortcuts() {
    _shortcuts.clear();
    for (final CodeShortcutType type in CodeShortcutType.values) {
      if (type == CodeShortcutType.backspace) {
        if (kIsAndroid || kIsIOS) {
          continue;
        }
      }
      final List<ShortcutActivator>? activators = widget.builder.build(type);
      if (activators == null || activators.isEmpty) {
        continue;
      }
      for (final ShortcutActivator activator in activators) {
        _shortcuts[activator] = kCodeShortcutIntents[type]!;
      }
    }
    // Protect space key go to the IME.
    _shortcuts.addAll({
      const SingleActivator(LogicalKeyboardKey.space): const DoNothingAndStopPropagationTextIntent(),
    });
  }

}

class _CodeShortcutActions extends StatelessWidget {

  final CodeLineEditingController editingController;
  final _CodeInputController inputController;
  final CodeFindController? findController;
  final CodeCommentFormatter? commentFormatter;
  final Map<Type, Action<Intent>>? overrideActions;
  final bool readOnly;
  final Widget child;

  const _CodeShortcutActions({
    required this.editingController,
    required this.inputController,
    this.findController,
    this.commentFormatter,
    required this.overrideActions,
    required this.readOnly,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Map<Type, Action<Intent>> actions = {};
    for (final Intent intent in kCodeShortcutIntents.values) {
      // Do not add editable actions when read only.
      if (intent is CodeShortcutEditableIntent && readOnly) {
        continue;
      }
      if (intent is CodeShortcutEscIntent) {
        // Do not enable ESC key when nothing the eidtor can do.
        actions[intent.runtimeType] = _EscCallbackAction(
          controller: editingController,
          findController: findController,
          onInvoke: (intent) {
            return _onAction(context, intent);
          },
        );
        continue;
      }
      actions[intent.runtimeType] = _CompoDoNothingCallbackAction(
        controller: editingController,
        onInvoke: (intent) {
          return _onAction(context, intent);
        },
      );
    }
    return Actions(
      actions: {
        ...actions,
        ...{
          DoNothingAndStopPropagationTextIntent: DoNothingAction(consumesKey: false),
        },
        if (overrideActions != null)
          ...overrideActions!
      },
      child: child
    );
  }

  Object? _onAction(BuildContext context, Intent intent) {
    final Action<Intent>? action = Actions.maybeFind(context, intent: intent);
    if (action != null && action.isActionEnabled && action.consumesKey(intent)) {
      if (action is CallbackAction) {
        action.invoke(intent);
      }
      return null;
    }
    if (intent is CodeShortcutEditableIntent && readOnly) {
      return null;
    }
    if (editingController.isComposing) {
      return null;
    }
    bool keepAutoCompleateState = false;
    switch (intent.runtimeType) {
      case CodeShortcutSelectAllIntent: {
        editingController.selectAll();
        break;
      }
      case CodeShortcutLineSelectIntent: {
        editingController.selectLines(editingController.selection.baseIndex, editingController.selection.extentIndex);
        break;
      }
      case CodeShortcutCutIntent: {
        editingController.cut();
        break;
      }
      case CodeShortcutCopyIntent: {
        editingController.copy();
        break;
      }
      case CodeShortcutPasteIntent: {
        editingController.paste();
        break;
      }
      case CodeShortcutUndoIntent: {
        editingController.undo();
        break;
      }
      case CodeShortcutRedoIntent: {
        editingController.redo();
        break;
      }
      case ShortcutLineDeleteIntent: {
        editingController.deleteSelectionLines(true);
        break;
      }
      case ShortcutLineDeleteDirectionIntent: {
        if ((intent as ShortcutLineDeleteDirectionIntent).forward) {
          editingController.deleteLineForward();
        } else {
          editingController.deleteLineBackward();
        }
        break;
      }
      case ShortcutLineMoveIntent: {
        if ((intent as ShortcutLineMoveIntent).direction == VerticalDirection.up) {
          editingController.moveSelectionLinesUp();
        } else {
          editingController.moveSelectionLinesDown();
        }
        break;
      }
      case CodeShortcutIndentIntent: {
        editingController.applyIndent();
        break;
      }
      case CodeShortcutOutdentIntent: {
        editingController.applyOutdent();
        break;
      }
      case CodeShortcutCommentIntent: {
        final CodeLineEditingValue? value = commentFormatter?.format(
          editingController.value, editingController.options.indent,
          (intent as CodeShortcutCommentIntent).single);
        if (value != null) {
          editingController.runRevocableOp(() {
            editingController.value = value;
          });
        }
        break;
      }
      case CodeShortcutCursorMoveIntent: {
        editingController.moveCursor((intent as CodeShortcutCursorMoveIntent).direction);
        break;
      }
      case CodeShortcutCursorMoveLineEdgeIntent: {
        if ((intent as CodeShortcutCursorMoveLineEdgeIntent).forward) {
          editingController.moveCursorToLineEnd();
        } else {
          editingController.moveCursorToLineStart();
        }
        break;
      }
      case CodeShortcutCursorMoveDocEdgeIntent: {
        if ((intent as CodeShortcutCursorMoveDocEdgeIntent).forward) {
          editingController.moveCursorToPageEnd();
        } else {
          editingController.moveCursorToPageStart();
        }
        break;
      }
      case CodeShortcutCursorMovePageIntent: {
        if ((intent as CodeShortcutCursorMovePageIntent).forward) {
          editingController.moveCursorToPageDown();
        } else {
          editingController.moveCursorToPageUp();
        }
        break;
      }
      case CodeShortcutCursorMoveWordBoundaryIntent: {
        if ((intent as CodeShortcutCursorMoveWordBoundaryIntent).forward) {
          editingController.moveCursorToWordBoundaryForward();
        } else {
          editingController.moveCursorToWordBoundaryBackward();
        }
        break;
      }
      case CodeShortcutSelectionExtendIntent: {
        editingController.extendSelection((intent as CodeShortcutSelectionExtendIntent).direction);
        break;
      }
      case CodeShortcutSelectionExtendLineEdgeIntent: {
        if ((intent as CodeShortcutSelectionExtendLineEdgeIntent).forward) {
          editingController.extendSelectionToLineEnd();
        } else {
          editingController.extendSelectionToLineStart();
        }
        break;
      }
      case CodeShortcutSelectionExtendPageEdgeIntent: {
        if ((intent as CodeShortcutSelectionExtendPageEdgeIntent).forward) {
          editingController.extendSelectionToPageEnd();
        } else {
          editingController.extendSelectionToPageStart();
        }
        break;
      }
      case CodeShortcutSelectionExtendWordBoundaryIntent: {
        if ((intent as CodeShortcutSelectionExtendWordBoundaryIntent).forward) {
          editingController.extendSelectionToWordBoundaryForward();
        } else {
          editingController.extendSelectionToWordBoundaryBackward();
        }
        break;
      }
      case ShortcutWordDeleteDirectionIntent: {
        if ((intent as ShortcutWordDeleteDirectionIntent).forward) {
          editingController.deleteWordForward();
        } else {
          editingController.deleteWordBackward();
        }
        break;
      }
      case CodeShortcutDeleteIntent: {
        if ((intent as CodeShortcutDeleteIntent).forward) {
          editingController.deleteForward();
        } else {
          editingController.deleteBackward();
        }
        inputController.notifyListeners();
        keepAutoCompleateState = true;
        break;
      }
      case CodeShortcutNewLineIntent: {
        editingController.applyNewLine();
        break;
      }
      case CodeShortcutTransposeCharactersIntent: {
        editingController.transposeCharacters();
        break;
      }
      case CodeShortcutFindIntent: {
        findController?.findMode();
        break;
      }
      case CodeShortcutFindToggleMatchCaseIntent: {
        findController?.toggleCaseSensitive();
        break;
      }
      case CodeShortcutFindToggleRegexIntent: {
        findController?.toggleRegex();
        break;
      }
      case CodeShortcutReplaceIntent: {
        findController?.replaceMode();
        break;
      }
      case CodeShortcutEscIntent: {
        if (findController?.value != null) {
          findController?.close();
        } else {
          editingController.cancelSelection();
        }
        break;
      }
    }
    if (!keepAutoCompleateState) {
      final _CodeAutocompleteState? autocompleteState = context.findAncestorStateOfType<_CodeAutocompleteState>();
      autocompleteState?.dismiss();
    }
    return intent;
  }

}

class _CompoDoNothingCallbackAction<T extends Intent> extends CallbackAction<T> {

  final CodeLineEditingController controller;

  _CompoDoNothingCallbackAction({
    required this.controller,
    required super.onInvoke,
  });

  @override
  bool consumesKey(T intent) {
    return !controller.isComposing;
  }

}

class _EscCallbackAction<T extends Intent> extends CallbackAction<T> {

  final CodeLineEditingController controller;
  final CodeFindController? findController;

  _EscCallbackAction({
    required this.controller,
    required this.findController,
    required super.onInvoke,
  });

  @override
  bool isEnabled(T intent) {
    return !controller.isComposing && (findController?.value != null || !controller.selection.isCollapsed);
  }

}