part of re_editor;

typedef CodeLineSpanBuilder = TextSpan Function({
  required BuildContext context,
  required CodeLines codeLines,
  required TextStyle style,
});

/// A controller for an editor field.
///
/// Whenever the user modifies a editor field with an associated
/// [CodeLineEditingController], the editor field updates [value] and the controller
/// notifies its listeners. Listeners can then read the [codeLines] and [selection]
/// properties to learn what the user has typed or how the selection has been
/// updated.
///
/// Similarly, if you modify the [codeLines] or [selection] properties, the editor
/// field will be notified and will update itself appropriately.
///
/// A [CodeLineEditingController] can also be used to provide an initial value for a
/// editor field. If you build a editor field with a controller that already has
/// [codeLines], the editor field will use that text as its initial value.
///
/// The [value] (as well as [codeLines] and [selection]) of this controller can be
/// updated from within a listener added to this controller. Be aware of
/// infinite loops since the listener will also be notified of the changes made
/// from within itself. Modifying the composing region from within a listener
/// can also have a bad interaction with some input methods. Gboard, for
/// example, will try to restore the composing region of the text if it was
/// modified programmatically, creating an infinite loop of communications
/// between the framework and the input method.
///
/// If both the [codeLines] or [selection] properties need to be changed, set the
/// controller's [value] instead.
///
/// Remember to [dispose] of the [CodeLineEditingController] when it is no longer
/// needed. This will ensure we discard any resources used by the object.
///
abstract class CodeLineEditingController
    extends ValueNotifier<CodeLineEditingValue> {
  /// Creates a controller for an editor field.
  ///
  /// This constructor treats an empty [codeLines] argument as if it were the empty
  /// string.
  ///
  /// Use [options] to define the linebreak and indent.
  ///
  /// Also, you can use [spanBuilder] to customize and override the code line style.
  ///
  factory CodeLineEditingController({
    CodeLines codeLines = _kInitialCodeLines,
    CodeLineOptions options = const CodeLineOptions(),
    CodeLineSpanBuilder? spanBuilder,
  }) =>
      _CodeLineEditingControllerImpl(
        codeLines: codeLines,
        options: options,
        spanBuilder: spanBuilder,
      );

  /// Creates a controller for a given text.
  factory CodeLineEditingController.fromText(String? text,
          [CodeLineOptions options = const CodeLineOptions()]) =>
      _CodeLineEditingControllerImpl.fromText(text, options);

  /// Creates a controller for a given file path. The file content will read async.
  factory CodeLineEditingController.fromTextAsync(String? text,
          [CodeLineOptions options = const CodeLineOptions()]) =>
      _CodeLineEditingControllerImpl.fromTextAsync(text, options);

  /// Set the current editor codes.
  ///
  /// Setting this will notify all the listeners of this [CodeLineEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  set codeLines(CodeLines newCodeLines);

  /// Set the current editor code selections.
  ///
  /// Setting this will notify all the listeners of this [CodeLineEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  ///
  /// This property can be set from a listener added to this
  /// [CodeLineEditingController]; however, one should not also set [codeLines]
  /// in a separate statement. To change both the [codeLines] and the [selection]
  /// change the controller's [value].
  ///
  /// If the new selection is of non-zero length, or is outside the composing
  /// range, the composing range is cleared.
  set selection(CodeLineSelection newSelection);

  /// Set the current editor code composing.
  ///
  /// Setting this will notify all the listeners of this [CodeLineEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  set composing(TextRange newComposing);

  /// Get the previous editing value.
  CodeLineEditingValue? get preValue;

  /// Get the code line options.
  CodeLineOptions get options;

  /// The current codes the user is editing.
  CodeLines get codeLines;

  /// Get the current editor code selections.
  CodeLineSelection get selection;

  /// Get the range of code that is still being composed.
  TextRange get composing;

  /// The code line at which the selection originates.
  CodeLine get baseLine;

  /// The code line at which the selection terminates.
  CodeLine get extentLine;

  /// The code line at which the selection starts.
  CodeLine get startLine;

  /// The code line at which the selection ends.
  CodeLine get endLine;

  /// Whether the code that is still being composed.
  bool get isComposing;

  /// The current text being edited.
  ///
  /// This Will convert all the code lines into a whole text.
  String get text;

  /// The current text being selected.
  String get selectedText;

  /// How many lines in the editor.
  int get lineCount;

  /// Expanded code selections.
  CodeLineSelection get unforldLineSelection;

  /// Whether the code is empty.
  bool get isEmpty;

  /// Whether all the codes  are selected.
  bool get isAllSelected;

  /// Whether the undo action can be performed.
  bool get canUndo;

  /// Whether the redo action can be performed.
  bool get canRedo;

  /// Set the current editor text.
  ///
  /// Setting this will notify all the listeners of this [CodeLineEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  set text(String value);

  /// Set the current editor text async.
  ///
  /// Setting this will notify all the listeners of this [CodeLineEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  set textAsync(String value);

  /// Only used in internal.
  void bindEditor(GlobalKey key);

  /// Set the current editor value.
  ///
  /// Setting this will notify all the listeners of this [CodeLineEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void edit(TextEditingValue newValue);

  /// Select a code line at the given index.
  void selectLine(int index);

  /// Select some code lines at the given start and end index.
  void selectLines(int base, int extent);

  /// Select all the codes.
  void selectAll();

  /// The selection will be collaposed at the terminate position.
  void cancelSelection();

  /// Move up the selected code lines.
  void moveSelectionLinesUp();

  /// Move down the selected code lines.
  void moveSelectionLinesDown();

  /// Move the cursor to a direction.
  void moveCursor(AxisDirection direction);

  /// Move the cursor to the start of current line.
  void moveCursorToLineStart();

  /// Move the cursor to the end of current line.
  void moveCursorToLineEnd();

  /// Move the cursor to the start of document.
  void moveCursorToPageStart();

  /// Move the cursor to the end of document.
  void moveCursorToPageEnd();

  /// TODO
  void moveCursorToPageUp();

  /// TODO
  void moveCursorToPageDown();

  /// Move the cursor to the start of the word.
  void moveCursorToWordBoundaryForward();

  /// Move the cursor to the end of the word.
  void moveCursorToWordBoundaryBackward();

  /// Extend the selection to a direction.
  void extendSelection(AxisDirection direction);

  /// Extend the selection to the start of current line.
  void extendSelectionToLineStart();

  /// Extend the selection to the end of current line.
  void extendSelectionToLineEnd();

  /// Extend the selection to the start of document.
  void extendSelectionToPageStart();

  /// Extend the selection to the end of document.
  void extendSelectionToPageEnd();

  /// Extend the selection to the start of the word.
  void extendSelectionToWordBoundaryForward();

  /// Extend the selection to the end of the word.
  void extendSelectionToWordBoundaryBackward();

  /// Delete the selected lines.
  void deleteSelectionLines([bool keepExtentOffset = true]);

  /// Delete content before the cursor at the current line.
  void deleteLineForward();

  /// Delete content after the cursor at the current line.
  void deleteLineBackward();

  /// Delete the selected codes.
  ///
  /// Note that this operation will have no effect if the selection is collapsed.
  void deleteSelection();

  /// If the selection is currently collapsed, the character behind the cursor will be deleted.
  /// Otherwise, will delete the selection, same as [deleteSelection].
  ///
  /// Note that if the cursor is between closing symbols, such as braces,
  /// the left and right brace will be deleted together.
  void deleteBackward();

  /// If the selection is currently collapsed, the character in front of the cursor will be deleted.
  /// Otherwise, will delete the selection, same as [deleteSelection].
  ///
  /// Note that if the cursor is between closing symbols, such as braces,
  /// the left and right brace will be deleted together.
  void deleteForward();

  /// Delete the word behind the cursor.
  void deleteWordBackward();

  /// Delete the word in front of the cursor.
  void deleteWordForward();

  /// Insert a newline character.
  void applyNewLine();

  /// Insert a indent.
  void applyIndent();

  /// Delete a indent.
  void applyOutdent();

  /// Transpose characters.
  void transposeCharacters();

  /// Replace the selected code with a new string [replacement].
  void replaceSelection(String replacement, [CodeLineSelection? selection]);

  /// Replaces all substrings that match [pattern] with [replacement].
  void replaceAll(Pattern pattern, String replacement);

  /// Reverts the value on the stack to the previous value.
  void undo();

  /// Updates the value on the stack to the next value.
  void redo();

  /// If the selection is currently collapsed, the whole line will be copied.
  /// Otherwise, copy the selected codes.
  Future<void> copy();

  /// If the selection is currently collapsed, the whole line will be cut.
  /// Otherwise, cut the selected codes.
  void cut();

  /// Paste text from [Clipboard].
  void paste();

  /// Set the composing region to an empty range.
  ///
  /// The composing region is the range of text that is still being composed.
  /// Calling this function indicates that the user is done composing that
  /// region.
  ///
  /// Calling this will notify all the listeners of this [CodeLineEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clearComposing();

  /// Clear the undo and redo history.
  void clearHistory();

  /// Collapse codes form [start] to [end].
  void collapseChunk(int start, int end);

  /// Expand the codes at [index] of lines.
  void expandChunk(int index);

  /// Convert the [index] to the unforld line index.
  int index2lineIndex(int index);

  /// Get code line information at [lineIndex].
  CodeLineIndex lineIndex2Index(int lineIndex);

  /// Scroll the editor to make sure the cursor is visible at center.
  void makeCursorCenterIfInvisible();

  /// Scroll the editor to make sure the cursor is visible.
  void makeCursorVisible();

  /// Scroll the editor to make sure the given position is visible at center.
  void makePositionCenterIfInvisible(CodeLinePosition position);

  /// Scroll the editor to make sure the given position is visible.
  void makePositionVisible(CodeLinePosition position);

  /// Force the render to repaint.
  void forceRepaint();

  /// Perform an operation. If the editor content changes, it will
  /// be recorded in the undo history.
  void runRevocableOp(VoidCallback op);

  /// Builds [TextSpan] from current editing value.
  /// This can override the code syntax highlighting styles.
  TextSpan buildTextSpan(
      {required BuildContext context, required TextStyle style});
}

/// A delegate controller for an editor field.
///
/// We can override some default behaviors of the controller.
class CodeLineEditingControllerDelegate
    extends _CodeLineEditingControllerDelegate {
  CodeLineEditingControllerDelegate({
    required CodeLineEditingController delegate,
  }) {
    super.delegate = delegate;
  }
}

class CodeLine {
  static const CodeLine empty = CodeLine('');

  final String text;
  final List<CodeLine> chunks;

  const CodeLine(this.text, [this.chunks = const []]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeLine &&
        other.text == text &&
        listEquals(other.chunks, chunks);
  }

  @override
  int get hashCode => Object.hash(text, chunks);

  int get length => text.length;

  int get characterLength => text.characters.length;

  bool get chunkParent => chunks.isNotEmpty;

  int get lineCount {
    int count = 1;
    for (final CodeLine codeLine in chunks) {
      count += codeLine.lineCount;
    }
    return count;
  }

  int get charCount {
    int count = length;
    for (final CodeLine codeLine in chunks) {
      count += codeLine.charCount;
    }
    return count;
  }

  @override
  String toString() {
    return text;
  }

  String substring(int start, [int? end]) {
    return start >= length ? '' : text.substring(start, end);
  }

  String takeCharacter(int count) {
    return text.characters.take(count).string;
  }

  String takeLastCharacter(int count) {
    return text.characters.takeLast(count).string;
  }

  String takeCharacterAtLastIndex(int index) {
    return text.characters.elementAt(text.characters.length - 1 - index);
  }

  String takeCharacterAt(int index) {
    return text.characters.elementAt(index);
  }

  String skipCharacter(int count) {
    return text.characters.skip(count).string;
  }

  String skipLastCharacter(int count) {
    return text.characters.skipLast(count).string;
  }

  int codeUnitAt(int index) => text.codeUnitAt(index);

  CodeLine copyWith({String? text, List<CodeLine>? chunks}) {
    return CodeLine(text ?? this.text, chunks ?? this.chunks);
  }

  String asString(int start, TextLineBreak lineBreak) {
    return [substring(start), ...chunks.map((e) => e.asString(0, lineBreak))]
        .join(lineBreak.value);
  }

  List<String> flat() {
    final List<String> codeLines = [text];
    for (final CodeLine child in chunks) {
      codeLines.addAll(child.flat());
    }
    return codeLines;
  }
}

/// The current codes, selection, and composing state for editing a run of text.
class CodeLineEditingValue {
  /// Creates information for editing a run of codes.
  ///
  /// The selection and composing range must be within the codes. This is not
  /// checked during construction, and must be guaranteed by the caller.
  ///
  /// The default value of [selection] is `CodeLineSelection.zero()`.
  /// This indicates that there is no selection at all.
  const CodeLineEditingValue({
    required this.codeLines,
    this.selection = const CodeLineSelection.zero(),
    this.composing = TextRange.empty,
  });

  const CodeLineEditingValue.empty() : this(codeLines: _kInitialCodeLines);

  /// The current codes being edited.
  final CodeLines codeLines;

  /// The range of codes that is currently selected.
  ///
  /// When [selection] is a [CodeLineSelection] that has the same
  /// `base` and `extent` position, the [selection] property represents the
  /// caret position.
  final CodeLineSelection selection;

  /// The range of text that is still being composed.
  ///
  /// Composing regions are created by input methods (IMEs) to indicate the text
  /// within a certain range is provisional. For instance, the Android Gboard
  /// app's English keyboard puts the current word under the caret into a
  /// composing region to indicate the word is subject to autocorrect or
  /// prediction changes.
  ///
  /// Composing regions can also be used for performing multistage input, which
  /// is typically used by IMEs designed for phonetic keyboard to enter
  /// ideographic symbols. As an example, many CJK keyboards require the user to
  /// enter a Latin alphabet sequence and then convert it to CJK characters. On
  /// iOS, the default software keyboards do not have a dedicated view to show
  /// the unfinished Latin sequence, so it's displayed directly in the text
  /// field, inside of a composing region.
  ///
  /// The composing region should typically only be changed by the IME, or the
  /// user via interacting with the IME.
  ///
  /// If the range represented by this property is [TextRange.empty], then the
  /// text is not currently being composed.
  final TextRange composing;

  CodeLineEditingValue copyWith({
    CodeLines? codeLines,
    CodeLineSelection? selection,
    TextRange? composing,
  }) {
    return CodeLineEditingValue(
        codeLines: codeLines ?? this.codeLines,
        selection: selection ?? this.selection,
        composing: composing ?? this.composing);
  }

  bool get isInitial => codeLines == _kInitialCodeLines;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeLineEditingValue &&
        other.codeLines.equals(codeLines) &&
        other.selection == selection &&
        other.composing == composing;
  }

  @override
  int get hashCode => Object.hash(codeLines, selection, composing);

  @override
  String toString() {
    return 'codeLines: $codeLines, selection: $selection, composing: $composing';
  }
}

/// A range of code lines that represents a selection.
class CodeLineSelection {
  /// The line index at which the selection originates.
  final int baseIndex;

  /// The line index at which the selection terminates.
  final int extentIndex;

  /// The offset at which the selection originates.
  ///
  /// Might be larger than, smaller than, or equal to extent.
  final int baseOffset;

  /// The offset at which the selection terminates.
  ///
  /// When the user uses the arrow keys to adjust the selection, this is the
  /// value that changes. Similarly, if the current theme paints a caret on one
  /// side of the selection, this is the location at which to paint the caret.
  ///
  /// Might be larger than, smaller than, or equal to base.
  final int extentOffset;

  /// If the code range is collapsed and has more than one visual location
  /// (e.g., occurs at a line break), which of the two locations to use when
  /// painting the caret.
  final TextAffinity baseAffinity;

  /// If the code range is collapsed and has more than one visual location
  /// (e.g., occurs at a line break), which of the two locations to use when
  /// painting the caret.
  final TextAffinity extentAffinity;

  /// Creates a code selection.
  const CodeLineSelection({
    required this.baseIndex,
    required this.baseOffset,
    required this.extentIndex,
    required this.extentOffset,
    this.baseAffinity = TextAffinity.downstream,
    this.extentAffinity = TextAffinity.downstream,
  });

  /// Creates a collapsed selection at the given line index and offset.
  ///
  /// A collapsed selection starts and ends at the same offset, which means it
  /// contains zero characters but instead serves as an insertion point in the
  /// text.
  const CodeLineSelection.collapsed({
    required int index,
    required int offset,
    TextAffinity affinity = TextAffinity.downstream,
  }) : this(
            baseIndex: index,
            baseOffset: offset,
            extentIndex: index,
            extentOffset: offset,
            baseAffinity: affinity,
            extentAffinity: affinity);

  /// Creates a collapsed selection at the given code position.
  ///
  /// A collapsed selection starts and ends at the same offset, which means it
  /// contains zero characters but instead serves as an insertion point in the
  /// text.
  CodeLineSelection.fromPosition({required CodeLinePosition position})
      : this.collapsed(
          index: position.index,
          offset: position.offset,
          affinity: position.affinity,
        );

  /// Creates a selection at the given line index and range.
  CodeLineSelection.fromRange({required CodeLineRange range})
      : this(
          baseIndex: range.index,
          baseOffset: range.start,
          extentIndex: range.index,
          extentOffset: range.end,
        );

  /// Creates a selection at the given line index and selection.
  CodeLineSelection.fromTextSelection(
      {required int index, required TextSelection selection})
      : this(
          baseIndex: index,
          baseOffset: selection.baseOffset,
          baseAffinity: selection.affinity,
          extentIndex: index,
          extentOffset: selection.extentOffset,
          extentAffinity: selection.affinity,
        );

  /// Creates a collapsed selection at the beginning.
  const CodeLineSelection.zero()
      : this(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 0,
        );

  /// The position at which the selection originates.
  CodeLinePosition get base {
    return CodeLinePosition(
        index: baseIndex, offset: baseOffset, affinity: baseAffinity);
  }

  /// The position at which the selection terminates.
  CodeLinePosition get extent {
    return CodeLinePosition(
        index: extentIndex, offset: extentOffset, affinity: extentAffinity);
  }

  /// The position at which the selection starts.
  CodeLinePosition get start {
    if (baseIndex < extentIndex) {
      return base;
    } else if (baseIndex > extentIndex) {
      return extent;
    } else {
      if (baseOffset < extentOffset) {
        return base;
      } else {
        return extent;
      }
    }
  }

  /// The position at which the selection ends.
  CodeLinePosition get end {
    if (baseIndex < extentIndex) {
      return extent;
    } else if (baseIndex > extentIndex) {
      return base;
    } else {
      if (baseOffset < extentOffset) {
        return extent;
      } else {
        return base;
      }
    }
  }

  /// The line index at which the selection starts.
  int get startIndex => start.index;

  /// The offset at which the selection starts.
  int get startOffset => start.offset;

  /// The line index at which the selection ends.
  int get endIndex => end.index;

  /// The offset at which the selection ends.
  int get endOffset => end.offset;

  /// Whether this range is empty (but still potentially placed inside the text).
  bool get isCollapsed => isSameLine && baseOffset == extentOffset;

  /// Whether this selection is in a same line.
  bool get isSameLine => baseIndex == extentIndex;

  /// Whether this selection contains another selection.
  bool contains(CodeLineSelection selection) {
    if (startIndex < selection.startIndex && endIndex > selection.endIndex) {
      return true;
    }
    if (startIndex > selection.startIndex || endIndex < selection.endIndex) {
      return false;
    }
    final bool startInside;
    if (startIndex == selection.startIndex) {
      startInside = startOffset <= selection.startOffset;
    } else {
      startInside = true;
    }
    final bool endInside;
    if (endIndex == selection.endIndex) {
      endInside = endOffset >= selection.endOffset;
    } else {
      endInside = true;
    }
    return startInside && endInside;
  }

  CodeLineSelection copyWith({
    int? baseIndex,
    int? extentIndex,
    int? baseOffset,
    int? extentOffset,
    TextAffinity? baseAffinity,
    TextAffinity? extentAffinity,
  }) {
    return CodeLineSelection(
      baseIndex: baseIndex ?? this.baseIndex,
      baseOffset: baseOffset ?? this.baseOffset,
      baseAffinity: baseAffinity ?? this.baseAffinity,
      extentIndex: extentIndex ?? this.extentIndex,
      extentOffset: extentOffset ?? this.extentOffset,
      extentAffinity: extentAffinity ?? this.extentAffinity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! CodeLineSelection) {
      return false;
    }
    return other.baseIndex == baseIndex &&
        other.extentIndex == extentIndex &&
        other.baseOffset == baseOffset &&
        other.extentOffset == extentOffset &&
        other.baseAffinity == baseAffinity &&
        other.extentAffinity == extentAffinity;
  }

  @override
  int get hashCode {
    return Object.hash(baseIndex, extentIndex, baseOffset, extentOffset,
        baseAffinity, extentAffinity);
  }

  @override
  String toString() {
    return 'CodeLineSelection(baseIndex: $baseIndex, baseOffset: $baseOffset, baseAffinity: $baseAffinity, '
        'extentIndex: $extentIndex, extentOffset: $extentOffset, extentAffinity: $extentAffinity)';
  }
}

/// A position in a string of code.
///
/// A CodeLinePosition can be used to describe a caret position in between
/// characters. The [index] points to the line index and the [offset] points
/// to the position between `offset - 1` and `offset` characters of the string,
/// and the [affinity] is used to describe which character this position affiliates
/// with.
class CodeLinePosition extends TextPosition {
  /// Creates an object representing a particular position in a code.
  const CodeLinePosition({
    required this.index,
    required super.offset,
    super.affinity = TextAffinity.downstream,
  });

  /// Line index in the codes.
  final int index;

  /// Creates the CodeLinePosition with the line index and text position.
  CodeLinePosition.from({required int index, required TextPosition position})
      : this(
            index: index, offset: position.offset, affinity: position.affinity);

  CodeLinePosition copyWith({int? index, int? offset, TextAffinity? affinity}) {
    return CodeLinePosition(
      index: index ?? this.index,
      offset: offset ?? this.offset,
      affinity: affinity ?? this.affinity,
    );
  }

  /// Get the text position withou line index.
  TextPosition get textPosition =>
      TextPosition(offset: offset, affinity: affinity);

  /// Whether the current code position is before the given position.
  bool isBefore(CodeLinePosition position) {
    if (index < position.index) {
      return true;
    }
    if (index > position.index) {
      return false;
    }
    return offset < position.offset;
  }

  /// Whether the current code position is after the given position.
  bool isAfter(CodeLinePosition position) {
    if (index > position.index) {
      return true;
    }
    if (index < position.index) {
      return false;
    }
    return offset > position.offset;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeLinePosition &&
        other.index == index &&
        other.offset == offset &&
        other.affinity == affinity;
  }

  @override
  int get hashCode => Object.hash(index, offset, affinity);

  @override
  String toString() {
    return 'CodeLinePosition(index: $index, offset: $offset, affinity: $affinity)';
  }
}

/// A range of code that represents a selection.
class CodeLineRange extends TextRange {
  /// Creates a code range.
  const CodeLineRange({
    required this.index,
    required super.start,
    required super.end,
  });

  /// Line index in the codes.
  final int index;

  /// Creates a code range at the given line index and text range.
  factory CodeLineRange.from({required int index, required TextRange range}) {
    return CodeLineRange(index: index, start: range.start, end: range.end);
  }

  /// Creates a collapsed range at the given offset.
  ///
  /// A collapsed range starts and ends at the same offset, which means it
  /// contains zero characters but instead serves as an insertion point in the
  /// text.
  const CodeLineRange.collapsed({required int index, required int offset})
      : this(index: index, start: offset, end: offset);

  /// Creates a collapsed range with negative offset.
  const CodeLineRange.empty() : this(index: 0, start: -1, end: -1);

  /// Creates a new [CodeLineRange] based on the current selection, with the
  /// provided parameters overridden.
  CodeLineRange copyWith({int? index, int? start, int? end}) {
    return CodeLineRange(
      index: index ?? this.index,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  int get hashCode => Object.hash(index, start, end);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeLineRange &&
        other.index == index &&
        other.start == start &&
        other.end == end;
  }

  @override
  String toString() => 'CodeLineRange(index: $index start: $start, end: $end)';
}

/// Some options of the code lines.
class CodeLineOptions {
  static const int _defaultIndentSize = 2;

  const CodeLineOptions(
      {this.lineBreak = TextLineBreak.lf,
      this.indentSize = _defaultIndentSize});

  /// Line break symbols, like LF, CRLF.
  ///
  /// Defaults to [TextLineBreak.lf].
  final TextLineBreak lineBreak;

  /// Indent length, default value is 2.
  final int indentSize;

  CodeLineOptions copyWith({
    TextLineBreak? lineBreak,
    int? indentSize,
  }) {
    return CodeLineOptions(
      lineBreak: lineBreak ?? this.lineBreak,
      indentSize: indentSize ?? this.indentSize,
    );
  }

  @override
  int get hashCode => Object.hash(lineBreak, indentSize);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeLineOptions &&
        other.lineBreak == lineBreak &&
        other.indentSize == indentSize;
  }

  String get indent => ' ' * indentSize;
}

class CodeLineIndex {
  final int index;
  final int chunkIndex;

  const CodeLineIndex(this.index, this.chunkIndex);

  @override
  int get hashCode => Object.hash(index, chunkIndex);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeLineIndex &&
        other.index == index &&
        other.chunkIndex == chunkIndex;
  }

  @override
  String toString() => 'CodeLineIndex(index: $index chunkIndex: $chunkIndex)';
}

class CodeLineRenderParagraph {
  static const double _chunkIndicatorWidth = 15;

  final int index;
  final IParagraph paragraph;
  final Offset offset;
  final bool chunkParent;
  final bool chunkLongText;

  const CodeLineRenderParagraph({
    required this.index,
    required this.paragraph,
    required this.offset,
    required this.chunkParent,
    required this.chunkLongText,
  });

  double get preferredLineHeight => paragraph.preferredLineHeight;

  double get top => offset.dy;

  double get bottom => offset.dy + height;

  double get width =>
      paragraph.width + (chunkParent ? _chunkIndicatorWidth : 0);

  double get height => paragraph.height;

  int get length => paragraph.length;

  bool inVerticalRange(Offset coordinate) =>
      coordinate.dy >= top && coordinate.dy < bottom;

  CodeLinePosition getPosition(Offset offset) => CodeLinePosition.from(
      index: index, position: paragraph.getPosition(offset));

  CodeLineRange getWord(Offset offset) =>
      CodeLineRange.from(index: index, range: paragraph.getWord(offset));

  InlineSpan? getSpanForPosition(Offset offset) =>
      paragraph.getSpanForPosition(getPosition(offset));

  TextRange getRangeForSpan(InlineSpan span) => paragraph.getRangeForSpan(span);

  Offset? getOffset(TextPosition position) => paragraph.getOffset(position);

  List<Rect> getRangeRects(TextRange range) => paragraph.getRangeRects(range);

  void draw(Canvas canvas, Offset offset) {
    paragraph.draw(canvas, offset);
  }

  @override
  int get hashCode => Object.hash(index, paragraph, offset, chunkParent);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeLineRenderParagraph &&
        other.index == index &&
        other.paragraph == paragraph &&
        other.offset == offset &&
        other.chunkParent == chunkParent;
  }

  CodeLineRenderParagraph copyWith({
    int? index,
    IParagraph? paragraph,
    Offset? offset,
    bool? chunkParent,
    bool? chunkLongText,
  }) {
    return CodeLineRenderParagraph(
      index: index ?? this.index,
      paragraph: paragraph ?? this.paragraph,
      offset: offset ?? this.offset,
      chunkParent: chunkParent ?? this.chunkParent,
      chunkLongText: chunkLongText ?? this.chunkLongText,
    );
  }
}

enum TextLineBreak {
  crlf,

  cr,

  lf,
}

extension TextLineBreakExtension on TextLineBreak {
  String get value => const ['\r\n', '\r', '\n'][index];
}

class CodeLineUtils {
  static List<String> toTextLines(String text) {
    return text.replaceAll('\r\n', '\n').replaceAll('\r', '\n').split('\n');
  }

  static CodeLines toCodeLines(String text) {
    return CodeLines.of(toTextLines(text).map((e) => CodeLine(e)));
  }

  static Future<CodeLines> toCodeLinesAsync(String text) async {
    if (text.isEmpty) {
      return _kInitialCodeLines;
    }
    return compute<String, CodeLines>((message) => toCodeLines(message), text);
  }
}

const CodeLines _kInitialCodeLines = CodeLines([
  CodeLineSegment(codeLines: [CodeLine.empty])
]);

const int _kUnitCodeWhitespace = 0x20;
const List<String> _kClosures = ['{}', '[]', '()'];
const List<String> _kClosureAndQuates = ['{}', '[]', '()', '\'\'', '""', '``'];

class _CodeLineEditingControllerImpl extends ValueNotifier<CodeLineEditingValue>
    implements CodeLineEditingController {
  @override
  final CodeLineOptions options;
  final CodeLineSpanBuilder? spanBuilder;
  late final _CodeLineEditingCache _cache;
  late int _preEditLineIndex;
  CodeLineEditingValue? _preValue;
  GlobalKey? _editorKey;

  _CodeLineEditingControllerImpl({
    required CodeLines codeLines,
    required this.options,
    this.spanBuilder,
  }) : super(CodeLineEditingValue(codeLines: codeLines)) {
    _cache = _CodeLineEditingCache(this);
    _preEditLineIndex = -1;
  }

  factory _CodeLineEditingControllerImpl.fromText(String? text,
      [CodeLineOptions options = const CodeLineOptions()]) {
    return _CodeLineEditingControllerImpl(
        codeLines: CodeLineUtils.toCodeLines(text ?? ''), options: options);
  }

  factory _CodeLineEditingControllerImpl.fromTextAsync(String? text,
      [CodeLineOptions options = const CodeLineOptions()]) {
    final _CodeLineEditingControllerImpl controller =
        _CodeLineEditingControllerImpl(
            codeLines: _kInitialCodeLines, options: options);
    CodeLineUtils.toCodeLinesAsync(text ?? '')
        .then((value) => controller.codeLines = value);
    return controller;
  }

  @override
  set value(CodeLineEditingValue value) {
    _preValue = super.value;
    super.value = value;
  }

  @override
  set codeLines(CodeLines newCodeLines) {
    value = value.copyWith(
        codeLines: newCodeLines.isEmpty ? _kInitialCodeLines : newCodeLines);
  }

  @override
  set selection(CodeLineSelection newSelection) {
    value = value.copyWith(selection: newSelection);
  }

  @override
  set composing(TextRange newComposing) {
    value = value.copyWith(composing: newComposing);
  }

  TextLineBreak get lineBreak => options.lineBreak;

  String get indent => options.indent;

  @override
  CodeLineEditingValue? get preValue => _preValue;

  @override
  CodeLines get codeLines => value.codeLines;

  @override
  CodeLineSelection get selection => value.selection;

  @override
  TextRange get composing => value.composing;

  @override
  CodeLine get baseLine => codeLines[selection.baseIndex];

  @override
  CodeLine get extentLine => codeLines[selection.extentIndex];

  @override
  CodeLine get startLine => codeLines[selection.startIndex];

  @override
  CodeLine get endLine => codeLines[selection.endIndex];

  @override
  bool get isComposing => composing.end > composing.start;

  @override
  String get text => codeLines.asString(lineBreak);

  @override
  String get selectedText {
    final StringBuffer sb = StringBuffer();
    if (selection.isSameLine) {
      sb.write(startLine.substring(selection.startOffset, selection.endOffset));
    } else {
      for (int i = selection.startIndex; i <= selection.endIndex; i++) {
        final CodeLine codeLine = codeLines[i];
        if (i == selection.startIndex) {
          if (codeLine.chunkParent) {
            sb.write(codeLine.asString(selection.startOffset, lineBreak));
          } else {
            sb.write(codeLine.substring(selection.startOffset));
          }
        } else if (i == selection.endIndex) {
          sb.write(codeLine.substring(0, selection.endOffset));
        } else {
          sb.write(codeLine.asString(0, lineBreak));
        }
        if (i < selection.endIndex) {
          sb.write(lineBreak.value);
        }
      }
    }
    return sb.toString();
  }

  @override
  int get lineCount => codeLines.lineCount;

  @override
  CodeLineSelection get unforldLineSelection {
    final int baseRawIndex;
    final int extentRawIndex;
    if (selection.isSameLine) {
      baseRawIndex = extentRawIndex = index2lineIndex(selection.baseIndex);
    } else {
      baseRawIndex = index2lineIndex(selection.baseIndex);
      extentRawIndex = index2lineIndex(selection.extentIndex);
    }
    return selection.copyWith(
        baseIndex: baseRawIndex, extentIndex: extentRawIndex);
  }

  @override
  bool get isEmpty => codeLines == _kInitialCodeLines;

  @override
  bool get isAllSelected =>
      selection.start.index == 0 &&
      selection.start.offset == 0 &&
      selection.end.index == codeLines.length - 1 &&
      selection.end.offset == codeLines.last.length;

  @override
  bool get canUndo => _cache.canUndo;

  @override
  bool get canRedo => _cache.canRedo;

  @override
  set text(String value) {
    runRevocableOp(() {
      this.value =
          CodeLineEditingValue(codeLines: CodeLineUtils.toCodeLines(value));
    });
  }

  @override
  set textAsync(String value) {
    CodeLineUtils.toCodeLinesAsync(value).then((value) {
      runRevocableOp(() {
        this.value = CodeLineEditingValue(codeLines: value);
      });
    }).onError((error, stackTrace) {
      // Should not happen
    });
  }

  @override
  void bindEditor(GlobalKey key) {
    _editorKey = key;
  }

  @override
  void edit(TextEditingValue newValue) {
    final CodeLines newCodeLines;
    final TextSelection newSelection;
    final TextRange newComposing;
    // FIXME: large list operation is very very slow
    if (selection.isSameLine) {
      if (startLine.text == newValue.text) {
        newCodeLines = codeLines;
      } else {
        newCodeLines = CodeLines.from(codeLines);
        newCodeLines[selection.startIndex] =
            startLine.copyWith(text: newValue.text);
      }
      newSelection = newValue.selection;
      newComposing = newValue.composing;
    } else if (selection.baseIndex < selection.extentIndex) {
      newCodeLines = codeLines.sublines(0, selection.startIndex);
      newCodeLines.add(endLine.copyWith(
          text: newValue.text + endLine.substring(selection.endOffset)));
      if (selection.endIndex + 1 < codeLines.length) {
        newCodeLines.addFrom(codeLines, selection.endIndex + 1);
      }
      newSelection = newValue.selection;
      newComposing = newValue.composing;
    } else {
      newCodeLines = codeLines.sublines(0, selection.startIndex);
      newCodeLines.add(endLine.copyWith(
          text: startLine.substring(0, selection.startOffset) + newValue.text));
      if (selection.endIndex + 1 < codeLines.length) {
        newCodeLines.addFrom(codeLines, selection.endIndex + 1);
      }
      newSelection = TextSelection.collapsed(
          offset: selection.startOffset + newValue.selection.baseOffset);
      if (newValue.composing.isValid) {
        newComposing = TextRange(
          start: selection.startOffset + newValue.composing.start,
          end: selection.startOffset + newValue.composing.end,
        );
      } else {
        newComposing = newValue.composing;
      }
    }
    if (_preEditLineIndex != selection.extentIndex) {
      _preEditLineIndex = selection.extentIndex;
      _cache.markNewRecord(true);
    }
    value = value.copyWith(
        codeLines: newCodeLines,
        selection: CodeLineSelection.fromTextSelection(
          index: selection.startIndex,
          selection: newSelection,
        ),
        composing: newComposing);
    _cache.markNewRecord(false);
    makeCursorCenterIfInvisible();
  }

  @override
  void selectLine(int index) {
    selectLines(index, index);
  }

  @override
  void selectLines(int base, int extent) {
    final int start = min(base, extent);
    final int end = max(base, extent);
    if (start < 0 || end >= codeLines.length) {
      return;
    }
    selection = selection.copyWith(
      baseIndex: base,
      baseOffset: base > extent ? codeLines[end].length : 0,
      extentIndex: extent,
      extentOffset: base > extent ? 0 : codeLines[end].length,
    );
    makeCursorCenterIfInvisible();
  }

  @override
  void selectAll() {
    selection = CodeLineSelection(
        baseIndex: 0,
        baseOffset: 0,
        extentIndex: codeLines.length - 1,
        extentOffset: codeLines.last.length);
  }

  @override
  void cancelSelection() {
    if (!selection.isCollapsed) {
      selection = CodeLineSelection.fromPosition(position: selection.extent);
      makeCursorCenterIfInvisible();
    }
  }

  @override
  void moveSelectionLinesUp() {
    runRevocableOp(_moveSelectionLinesUp);
  }

  @override
  void moveSelectionLinesDown() {
    runRevocableOp(_moveSelectionLinesDown);
  }

  @override
  void moveCursor(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.left:
        if (!selection.isCollapsed) {
          selection = CodeLineSelection.fromPosition(position: selection.start);
        } else if (selection.extentIndex != 0 || selection.extentOffset != 0) {
          if (selection.baseAffinity != selection.extentAffinity) {
            selection = selection.copyWith(
                baseAffinity: TextAffinity.upstream,
                extentAffinity: TextAffinity.upstream);
          } else {
            final int index;
            final int offset;
            if (selection.extentOffset == 0) {
              index = selection.extentIndex - 1;
              offset = codeLines[index].length;
            } else {
              index = selection.extentIndex;
              // Skip 1 character to left
              offset = codeLines[index]
                  .substring(0, selection.extentOffset)
                  .characters
                  .skipLast(1)
                  .string
                  .length;
            }
            selection = CodeLineSelection.collapsed(
              index: index,
              offset: offset,
              affinity: TextAffinity.downstream,
            );
          }
        }
        break;
      case AxisDirection.right:
        if (!selection.isCollapsed) {
          selection = CodeLineSelection.fromPosition(position: selection.end);
        } else if (selection.extentIndex != codeLines.length - 1 ||
            selection.extentOffset != codeLines.last.length) {
          if (selection.baseAffinity != selection.extentAffinity) {
            selection = selection.copyWith(
                baseAffinity: TextAffinity.downstream,
                extentAffinity: TextAffinity.downstream);
          } else {
            final int index;
            final int offset;
            if (selection.extentOffset == extentLine.length) {
              index = selection.extentIndex + 1;
              offset = 0;
            } else {
              index = selection.extentIndex;
              // Skip 1 character to right
              offset = selection.extentOffset +
                  codeLines[index]
                      .substring(selection.extentOffset)
                      .characters
                      .first
                      .length;
            }
            selection = CodeLineSelection.collapsed(
              index: index,
              offset: offset,
              affinity: TextAffinity.upstream,
            );
          }
        }
        break;
      case AxisDirection.up:
        final CodeLinePosition? position =
            _render?.getUpPosition(selection.start);
        if (position != null) {
          selection = CodeLineSelection.fromPosition(position: position);
        } else {
          final CodeLinePosition current = selection.start;
          if (current.index == 0) {
            selection = const CodeLineSelection.collapsed(index: 0, offset: 0);
          } else {
            selection = CodeLineSelection.collapsed(
                index: current.index - 1,
                offset:
                    min(codeLines[current.index - 1].length, current.offset));
          }
        }
        break;
      case AxisDirection.down:
        final CodeLinePosition? position =
            _render?.getDownPosition(selection.start);
        if (position != null) {
          selection = CodeLineSelection.fromPosition(position: position);
        } else {
          final CodeLinePosition current = selection.end;
          if (current.index == codeLines.length - 1) {
            selection = CodeLineSelection.collapsed(
                index: codeLines.length - 1, offset: codeLines.last.length);
          } else {
            selection = CodeLineSelection.collapsed(
                index: current.index + 1,
                offset:
                    min(codeLines[current.index + 1].length, current.offset));
          }
        }
        break;
    }
    makeCursorVisible();
  }

  @override
  void moveCursorToLineStart() {
    final String current = extentLine.text;
    final int prefixWhitespaceCount = _prefixWhitespaceCount(current);
    final int offset;
    if (selection.extentOffset == 0) {
      offset = prefixWhitespaceCount;
    } else {
      if (selection.extentOffset == prefixWhitespaceCount) {
        offset = 0;
      } else {
        offset = prefixWhitespaceCount;
      }
    }
    selection = CodeLineSelection.collapsed(
        index: selection.extentIndex, offset: offset);
    makeCursorVisible();
  }

  @override
  void moveCursorToLineEnd() {
    selection = CodeLineSelection.collapsed(
        index: selection.extentIndex, offset: extentLine.length);
    makeCursorVisible();
  }

  @override
  void moveCursorToPageStart() {
    selection = const CodeLineSelection.collapsed(index: 0, offset: 0);
    makeCursorVisible();
  }

  @override
  void moveCursorToPageEnd() {
    selection = CodeLineSelection.collapsed(
        index: codeLines.length - 1, offset: codeLines.last.length);
    makeCursorVisible();
  }

  @override
  void moveCursorToPageUp() {
    // TODO
  }

  @override
  void moveCursorToPageDown() {
    // TODO
  }

  @override
  void moveCursorToWordBoundaryBackward() {
    if (selection.extentOffset == 0) {
      final int newIndex = selection.extentIndex - 1;

      if (newIndex < 0) {
        return;
      }

      selection = CodeLineSelection.collapsed(
        index: newIndex,
        offset: codeLines[newIndex].length,
      );
      makeCursorVisible();
    }

    final String current = extentLine.text;

    if (current.isEmpty) {
      return;
    }

    int offset = selection.extentOffset - 1;

    while (offset > 0) {
      if (current.codeUnitAt(offset) == _kUnitCodeWhitespace) {
        offset--;
      } else {
        break;
      }
    }

    final int codeUnit = current.codeUnitAt(offset);
    bool isBeforeAlphanumeric = _isAlphanumeric(codeUnit);
    int i = offset - 1;

    while (i > 0) {
      bool isCurrentAlphanumeric = _isAlphanumeric(current.codeUnitAt(i));

      if (isBeforeAlphanumeric != isCurrentAlphanumeric) {
        break;
      }

      isBeforeAlphanumeric = isCurrentAlphanumeric;
      i--;
    }

    if (i <= 0) {
      i = 0;
    } else {
      i++;
    }

    selection = CodeLineSelection.collapsed(
      index: selection.extentIndex,
      offset: i,
    );
    makeCursorVisible();
  }

  @override
  void moveCursorToWordBoundaryForward() {
    if (selection.extentOffset == extentLine.text.length) {
      final int newIndex = selection.extentIndex + 1;

      if (newIndex >= codeLines.length) {
        return;
      }

      selection = CodeLineSelection.collapsed(
        index: newIndex,
        offset: 0,
      );
      makeCursorVisible();
    }

    final String current = extentLine.text;

    if (current.isEmpty) {
      return;
    }

    int offset = selection.extentOffset;

    while (offset < current.length) {
      if (current.codeUnitAt(offset) == _kUnitCodeWhitespace) {
        offset++;
      } else {
        break;
      }
    }

    final int codeUnit = current.codeUnitAt(offset);
    bool isBeforeAlphanumeric = _isAlphanumeric(codeUnit);
    int i = offset + 1;

    while (i < current.length) {
      bool isCurrentAlphanumeric = _isAlphanumeric(current.codeUnitAt(i));

      if (isBeforeAlphanumeric != isCurrentAlphanumeric) {
        break;
      }

      isBeforeAlphanumeric = isCurrentAlphanumeric;
      i++;
    }

    selection = CodeLineSelection.collapsed(
      index: selection.extentIndex,
      offset: i,
    );
    makeCursorVisible();
  }

  @override
  void extendSelection(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.left:
        if (selection.extentIndex != 0 || selection.extentOffset != 0) {
          final int index;
          final int offset;
          if (selection.extentOffset == 0) {
            index = selection.extentIndex - 1;
            offset = codeLines[index].length;
          } else {
            index = selection.extentIndex;
            final Characters characters =
                extentLine.substring(0, selection.extentOffset).characters;
            offset =
                selection.extentOffset - characters.takeLast(1).first.length;
          }
          selection = selection.copyWith(
              extentIndex: index,
              extentOffset: offset,
              extentAffinity: TextAffinity.downstream);
        }
        break;
      case AxisDirection.right:
        if (selection.extentIndex != codeLines.length - 1 ||
            selection.extentOffset != codeLines.last.length) {
          final int index;
          final int offset;
          if (selection.extentOffset == extentLine.length) {
            index = selection.extentIndex + 1;
            offset = 0;
          } else {
            final Characters characters =
                extentLine.substring(selection.extentOffset).characters;
            index = selection.extentIndex;
            offset = selection.extentOffset + characters.elementAt(0).length;
          }
          selection = selection.copyWith(
              extentIndex: index,
              extentOffset: offset,
              extentAffinity: TextAffinity.upstream);
        }
        break;
      case AxisDirection.up:
        final CodeLinePosition? position =
            _render?.getUpPosition(selection.extent);
        if (position != null) {
          selection = selection.copyWith(
              extentIndex: position.index,
              extentOffset: position.offset,
              extentAffinity: position.affinity);
        } else {
          final CodeLinePosition current = selection.extent;
          if (current.index == 0) {
            selection = selection.copyWith(extentIndex: 0, extentOffset: 0);
          } else {
            selection = selection.copyWith(
                extentIndex: current.index - 1,
                extentOffset:
                    min(codeLines[current.index - 1].length, current.offset));
          }
        }
        break;
      case AxisDirection.down:
        final CodeLinePosition? position =
            _render?.getDownPosition(selection.extent);
        if (position != null) {
          selection = selection.copyWith(
              extentIndex: position.index,
              extentOffset: position.offset,
              extentAffinity: position.affinity);
        } else {
          final CodeLinePosition current = selection.extent;
          if (current.index == codeLines.length - 1) {
            selection = selection.copyWith(
                extentIndex: codeLines.length - 1,
                extentOffset: codeLines.last.length);
          } else {
            selection = selection.copyWith(
                extentIndex: current.index + 1,
                extentOffset:
                    min(codeLines[current.index + 1].length, current.offset));
          }
        }
        break;
    }
    makeCursorVisible();
  }

  @override
  void extendSelectionToLineStart() {
    selection = selection.copyWith(extentOffset: 0);
    makeCursorVisible();
  }

  @override
  void extendSelectionToLineEnd() {
    selection = selection.copyWith(
        extentIndex: selection.extentIndex, extentOffset: extentLine.length);
    makeCursorVisible();
  }

  @override
  void extendSelectionToPageStart() {
    selection = selection.copyWith(extentIndex: 0, extentOffset: 0);
    makeCursorVisible();
  }

  @override
  void extendSelectionToPageEnd() {
    selection = selection.copyWith(
        extentIndex: codeLines.length - 1, extentOffset: codeLines.last.length);
    makeCursorVisible();
  }

  @override
  void extendSelectionToWordBoundaryForward() {
    if (selection.extentOffset == 0) {
      final int newIndex = selection.extentIndex - 1;

      if (newIndex < 0) {
        return;
      }

      selection = selection.copyWith(
        extentIndex: newIndex,
        extentOffset: codeLines[newIndex].length,
      );
      makeCursorVisible();
    }

    final String current = extentLine.text;

    if (current.isEmpty) {
      return;
    }

    int offset = selection.extentOffset - 1;

    while (offset > 0) {
      if (current.codeUnitAt(offset) == _kUnitCodeWhitespace) {
        offset--;
      } else {
        break;
      }
    }

    final int codeUnit = current.codeUnitAt(offset);
    bool isBeforeAlphanumeric = _isAlphanumeric(codeUnit);
    int i = offset - 1;

    while (i > 0) {
      bool isCurrentAlphanumeric = _isAlphanumeric(current.codeUnitAt(i));

      if (isBeforeAlphanumeric != isCurrentAlphanumeric) {
        break;
      }

      isBeforeAlphanumeric = isCurrentAlphanumeric;
      i--;
    }

    if (i <= 0) {
      i = 0;
    } else {
      i++;
    }

    selection = selection.copyWith(
      extentIndex: selection.extentIndex,
      extentOffset: i,
    );
    makeCursorVisible();
  }

  @override
  void extendSelectionToWordBoundaryBackward() {
    if (selection.extentOffset == extentLine.text.length) {
      final int newIndex = selection.extentIndex + 1;

      if (newIndex >= codeLines.length) {
        return;
      }

      selection = selection.copyWith(
        extentIndex: newIndex,
        extentOffset: 0,
      );
      makeCursorVisible();
    }

    final String current = extentLine.text;

    if (current.isEmpty) {
      return;
    }

    int offset = selection.extentOffset;

    while (offset < current.length) {
      if (current.codeUnitAt(offset) == _kUnitCodeWhitespace) {
        offset++;
      } else {
        break;
      }
    }

    final int codeUnit = current.codeUnitAt(offset);
    bool isBeforeAlphanumeric = _isAlphanumeric(codeUnit);
    int i = offset + 1;

    while (i < current.length) {
      bool isCurrentAlphanumeric = _isAlphanumeric(current.codeUnitAt(i));

      if (isBeforeAlphanumeric != isCurrentAlphanumeric) {
        break;
      }

      isBeforeAlphanumeric = isCurrentAlphanumeric;
      i++;
    }

    selection = selection.copyWith(
      extentIndex: selection.extentIndex,
      extentOffset: i,
    );
    makeCursorVisible();
  }

  @override
  void deleteLineForward() {
    runRevocableOp(_deleteLineForward);
  }

  @override
  void deleteLineBackward() {
    runRevocableOp(_deleteLineBackward);
  }

  @override
  void deleteSelectionLines([bool keepExtentOffset = true]) {
    runRevocableOp(() {
      _deleteSelectionLines(keepExtentOffset);
    });
  }

  @override
  void deleteSelection() {
    runRevocableOp(_deleteSelection);
  }

  @override
  void deleteBackward() {
    runRevocableOp(_deleteBackward);
  }

  @override
  void deleteForward() {
    runRevocableOp(_deleteForward);
  }

  @override
  void deleteWordBackward() {
    runRevocableOp(_deleteWordBackward);
  }

  @override
  void deleteWordForward() {
    runRevocableOp(_deleteWordForward);
  }

  @override
  void applyNewLine() {
    runRevocableOp(_applyNewLine);
  }

  @override
  void applyIndent() {
    runRevocableOp(_applyIndent);
  }

  @override
  void applyOutdent() {
    runRevocableOp(_applyOutdent);
  }

  @override
  void transposeCharacters() {
    runRevocableOp(_transposeCharacters);
  }

  @override
  void replaceSelection(String replacement, [CodeLineSelection? range]) {
    runRevocableOp(() {
      _replaceRange(replacement, range);
    });
  }

  @override
  void replaceAll(Pattern pattern, String replacement) {
    runRevocableOp(() {
      _replaceAll(pattern, replacement);
    });
  }

  @override
  void undo() => _cache.undo();

  @override
  void redo() => _cache.redo();

  @override
  Future<void> copy() {
    if (selection.isCollapsed) {
      return Clipboard.setData(
          ClipboardData(text: extentLine.text + lineBreak.value));
    } else {
      return Clipboard.setData(ClipboardData(text: selectedText));
    }
  }

  @override
  void cut() {
    copy();
    if (selection.isCollapsed) {
      deleteSelectionLines(true);
    } else {
      deleteSelection();
    }
  }

  @override
  void paste() {
    Clipboard.getData(Clipboard.kTextPlain).then((data) {
      final String? text = data?.text;
      if (text == null || text.isEmpty) {
        return;
      }
      replaceSelection(text);
    });
  }

  @override
  void collapseChunk(int start, int end) {
    if (start < 0 ||
        start >= codeLines.length ||
        end <= start + 1 ||
        end > codeLines.length) {
      return;
    }
    if (codeLines[start].chunkParent) {
      return;
    }
    final CodeLines newCodeLines = codeLines.sublines(0, start);
    newCodeLines.add(codeLines[start]
        .copyWith(chunks: codeLines.sublines(start + 1, end).toList()));
    if (end < codeLines.length) {
      newCodeLines.addFrom(codeLines, end);
    }
    final int newStartIndex;
    final int newStartOffset;
    if (selection.startIndex <= start) {
      newStartIndex = selection.startIndex;
      newStartOffset = selection.startOffset;
    } else if (selection.startIndex < end) {
      newStartIndex = start;
      newStartOffset = codeLines[start].text.length;
    } else {
      newStartIndex = selection.startIndex - (end - start - 1);
      newStartOffset = selection.startOffset;
    }
    final int newEndIndex;
    final int newEndOffset;
    if (selection.endIndex <= start) {
      newEndIndex = selection.endIndex;
      newEndOffset = selection.endOffset;
    } else if (selection.endIndex < end) {
      newEndIndex = start;
      newEndOffset = codeLines[start].text.length;
    } else {
      newEndIndex = selection.endIndex - (end - start - 1);
      newEndOffset = selection.endOffset;
    }
    final CodeLineSelection newSelection;
    if (selection.baseIndex < selection.extentIndex) {
      newSelection = selection.copyWith(
          baseIndex: newStartIndex,
          baseOffset: newStartOffset,
          extentIndex: newEndIndex,
          extentOffset: newEndOffset);
    } else {
      newSelection = selection.copyWith(
          baseIndex: newEndIndex,
          baseOffset: newEndOffset,
          extentIndex: newStartIndex,
          extentOffset: newStartOffset);
    }
    final TextRange newComposing;
    if (selection.baseIndex > start && selection.baseIndex < end) {
      newComposing = TextRange.empty;
    } else {
      newComposing = composing;
    }
    value = value.copyWith(
        codeLines: newCodeLines,
        selection: newSelection,
        composing: newComposing);
  }

  @override
  void expandChunk(int index) {
    if (!codeLines[index].chunkParent) {
      return;
    }
    final CodeLines newCodeLines = codeLines.sublines(0, index);
    newCodeLines.add(codeLines[index].copyWith(chunks: const []));
    final List<CodeLine> collapsedChunks = codeLines[index].chunks;
    newCodeLines.addAll(collapsedChunks);
    if (index + 1 < codeLines.length) {
      newCodeLines.addFrom(codeLines, index + 1);
    }
    final CodeLineSelection newSelection;
    if (selection.endIndex <= index) {
      newSelection = selection;
    } else if (selection.startIndex <= index) {
      if (selection.baseIndex < selection.extentIndex) {
        newSelection = selection.copyWith(
            extentIndex: selection.extentIndex + collapsedChunks.length);
      } else {
        newSelection = selection.copyWith(
            baseIndex: selection.baseIndex + collapsedChunks.length);
      }
    } else {
      newSelection = selection.copyWith(
          baseIndex: selection.baseIndex + collapsedChunks.length,
          extentIndex: selection.extentIndex + collapsedChunks.length);
    }
    value = value.copyWith(
      codeLines: newCodeLines,
      selection: newSelection,
    );
  }

  @override
  void clearComposing() {
    value = value.copyWith(composing: TextRange.empty);
  }

  @override
  void clearHistory() {
    _cache.clear();
  }

  @override
  int index2lineIndex(int index) => codeLines.index2lineIndex(index);

  @override
  CodeLineIndex lineIndex2Index(int lineIndex) =>
      codeLines.lineIndex2Index(lineIndex);

  @override
  void makeCursorCenterIfInvisible() {
    _render?.makePositionCenterIfInvisible(selection.extent);
  }

  @override
  void makeCursorVisible() {
    _render?.makePositionVisible(selection.extent);
  }

  @override
  void makePositionCenterIfInvisible(CodeLinePosition position) {
    _render?.makePositionCenterIfInvisible(position);
  }

  @override
  void makePositionVisible(CodeLinePosition position) {
    _render?.makePositionVisible(position);
  }

  @override
  void forceRepaint() {
    _render?.forceRepaint();
  }

  @override
  void runRevocableOp(VoidCallback op) {
    _cache.markNewRecord(true);
    op();
    _cache.markNewRecord(false);
  }

  @override
  void dispose() {
    _editorKey = null;
    _cache.dispose();
    super.dispose();
  }

  _CodeFieldRender? get _render =>
      _editorKey?.currentContext?.findRenderObject() as _CodeFieldRender?;

  bool _isAlphanumeric(int codeUnit) {
    return (codeUnit <= 57 && codeUnit >= 48) ||
        (codeUnit <= 90 && codeUnit >= 65) ||
        (codeUnit <= 122 && codeUnit >= 97);
  }

  void _moveSelectionLinesUp() {
    if (selection.startIndex == 0) {
      return;
    }
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    final CodeLine tmp = codeLines[selection.startIndex - 1];
    for (int i = selection.startIndex; i <= selection.endIndex; i++) {
      newCodeLines[i - 1] = newCodeLines[i];
    }
    newCodeLines[selection.endIndex] = tmp;
    value = value.copyWith(
        codeLines: newCodeLines,
        selection: selection.copyWith(
          baseIndex: selection.baseIndex - 1,
          extentIndex: selection.extentIndex - 1,
        ));
    makeCursorCenterIfInvisible();
  }

  void _moveSelectionLinesDown() {
    if (selection.endIndex == codeLines.length - 1) {
      return;
    }
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    final CodeLine tmp = codeLines[selection.endIndex + 1];
    for (int i = selection.endIndex; i >= selection.startIndex; i--) {
      newCodeLines[i + 1] = newCodeLines[i];
    }
    newCodeLines[selection.startIndex] = tmp;
    value = value.copyWith(
        codeLines: newCodeLines,
        selection: selection.copyWith(
          baseIndex: selection.baseIndex + 1,
          extentIndex: selection.extentIndex + 1,
        ));
    makeCursorCenterIfInvisible();
  }

  void _deleteLineForward() {
    if (!selection.isCollapsed) {
      _deleteForward();
      return;
    }
    if (selection.extentOffset >= extentLine.length) {
      _deleteForward();
      return;
    }
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    newCodeLines[selection.extentIndex] =
        extentLine.copyWith(text: _codeTextBefore(selection.extent));
    value = value.copyWith(
      codeLines: newCodeLines,
    );
    makeCursorVisible();
  }

  void _deleteLineBackward() {
    if (!selection.isCollapsed) {
      _deleteBackward();
      return;
    }
    if (selection.extentOffset == 0) {
      _deleteBackward();
      return;
    }
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    newCodeLines[selection.extentIndex] =
        extentLine.copyWith(text: _codeTextAfter(selection.extent));
    value = value.copyWith(
      codeLines: newCodeLines,
      selection: CodeLineSelection.collapsed(
        index: selection.extentIndex,
        offset: 0,
      ),
    );
    makeCursorVisible();
  }

  void _deleteSelectionLines([bool keepExtentOffset = true]) {
    if (codeLines.equals(_kInitialCodeLines)) {
      return;
    }
    final CodeLines newCodeLines = codeLines.sublines(0, selection.startIndex);
    if (selection.endIndex + 1 < codeLines.length) {
      newCodeLines.addFrom(codeLines, selection.endIndex + 1);
    }
    if (newCodeLines.isEmpty) {
      newCodeLines.add(CodeLine.empty);
    }
    final int index = min(selection.startIndex, newCodeLines.length - 1);
    final int offset;
    if (keepExtentOffset) {
      offset = min(newCodeLines[index].length, selection.extentOffset);
    } else {
      offset = 0;
    }
    value = value.copyWith(
      codeLines: newCodeLines,
      selection: CodeLineSelection.collapsed(index: index, offset: offset),
    );
    makeCursorCenterIfInvisible();
  }

  void _deleteSelection() {
    if (selection.isCollapsed) {
      return;
    }
    final CodeLines newCodeLines = codeLines.sublines(0, selection.startIndex);
    final CodeLine after = _codeLineAfter(selection.end);
    newCodeLines.add(after.copyWith(
      text: _codeTextBefore(selection.start) + after.text,
    ));
    if (selection.endIndex + 1 < codeLines.length) {
      newCodeLines.addFrom(codeLines, selection.endIndex + 1);
    }
    value = value.copyWith(
        codeLines: newCodeLines,
        selection: CodeLineSelection.collapsed(
            index: selection.startIndex,
            offset: selection.startOffset,
            affinity: selection.start.affinity));
    makeCursorCenterIfInvisible();
  }

  void _deleteBackward() {
    if (selection.isCollapsed) {
      if (selection.baseIndex == 0 && selection.baseOffset == 0) {
        // At the start position of page, nothing to delete
        return;
      }
      if (selection.baseOffset == 0) {
        // Delete this line and merge into the previous line
        final CodeLines newCodeLines =
            codeLines.sublines(0, selection.baseIndex - 1);
        final CodeLine preLine = codeLines[selection.baseIndex - 1];
        if (preLine.chunkParent) {
          // Should expand this chunk
          newCodeLines.add(CodeLine(preLine.text));
          newCodeLines
              .addAll(preLine.chunks.sublist(0, preLine.chunks.length - 1));
          newCodeLines.add(baseLine.copyWith(
              text: preLine.chunks.last.text + baseLine.text));
          if (selection.baseIndex + 1 < codeLines.length) {
            newCodeLines.addFrom(codeLines, selection.baseIndex + 1);
          }
          value = value.copyWith(
              codeLines: newCodeLines,
              selection: CodeLineSelection.collapsed(
                index: selection.baseIndex + preLine.chunks.length - 1,
                offset: preLine.chunks.last.length,
              ));
        } else {
          newCodeLines
              .add(baseLine.copyWith(text: preLine.text + baseLine.text));
          if (selection.baseIndex + 1 < codeLines.length) {
            newCodeLines.addFrom(codeLines, selection.baseIndex + 1);
          }
          value = value.copyWith(
              codeLines: newCodeLines,
              selection: CodeLineSelection.collapsed(
                index: selection.baseIndex - 1,
                offset: preLine.length,
              ));
        }
      } else {
        final CodeLines newCodeLines = CodeLines.from(codeLines);
        if (_isWrapedByClosureSymbol(baseLine.text, selection.baseOffset)) {
          // Delete left and right closure symbols at same time, like this:
          // abc{|}123 -> abc123
          newCodeLines[selection.baseIndex] = baseLine.copyWith(
              text: baseLine.substring(0, selection.baseOffset - 1) +
                  baseLine.substring(selection.baseOffset + 1));
          value = value.copyWith(
              codeLines: newCodeLines,
              selection: CodeLineSelection.collapsed(
                  index: selection.baseIndex,
                  offset: selection.baseOffset - 1));
        } else {
          String backward = _codeTextBefore(selection.base);
          if (_isMultipleIndent(backward)) {
            // Delete a indent
            backward = backward.substring(indent.length, backward.length);
          } else if (backward.isNotEmpty) {
            // Delete the previous character normally
            final Characters characters = backward.characters;
            backward = characters.skipLast(1).string;
          }
          newCodeLines[selection.baseIndex] = baseLine.copyWith(
              text: backward + baseLine.substring(selection.baseOffset));
          value = value.copyWith(
              codeLines: newCodeLines,
              selection: CodeLineSelection.collapsed(
                  index: selection.baseIndex, offset: backward.length));
        }
      }
    } else {
      _deleteSelection();
    }
    makeCursorCenterIfInvisible();
  }

  void _deleteForward() {
    if (selection.isCollapsed) {
      if (selection.extentIndex == codeLines.length - 1 &&
          selection.extentOffset == codeLines.last.length) {
        // At the end position of page, nothing to delete
        return;
      }
      if (selection.extentOffset == extentLine.length) {
        // Delete next line and merge into the current line
        final CodeLines newCodeLines =
            codeLines.sublines(0, selection.extentIndex);
        if (extentLine.chunkParent) {
          final CodeLine nextLine = extentLine.chunks.first;
          // Should expand this chunk
          newCodeLines
              .add(nextLine.copyWith(text: extentLine.text + nextLine.text));
          newCodeLines.addAll(extentLine.chunks.sublist(1));
          if (selection.extentIndex + 1 < codeLines.length) {
            newCodeLines.addFrom(codeLines, selection.extentIndex + 1);
          }
        } else {
          newCodeLines.add(codeLines[selection.extentIndex + 1].copyWith(
              text:
                  extentLine.text + codeLines[selection.extentIndex + 1].text));
          if (selection.extentIndex + 2 < codeLines.length) {
            newCodeLines.addFrom(codeLines, selection.extentIndex + 2);
          }
        }
        value = value.copyWith(
            codeLines: newCodeLines,
            selection: CodeLineSelection.collapsed(
              index: selection.extentIndex,
              offset: extentLine.length,
            ));
      } else {
        final CodeLines newCodeLines = CodeLines.from(codeLines);
        if (_isWrapedByClosureSymbol(extentLine.text, selection.extentOffset)) {
          // Delete left and right closure symbols at same time, like this:
          // abc{|}123 -> abc123
          newCodeLines[selection.extentIndex] = extentLine.copyWith(
              text: extentLine.substring(0, selection.extentOffset - 1) +
                  extentLine.substring(selection.extentOffset + 1));
          value = value.copyWith(
              codeLines: newCodeLines,
              selection: CodeLineSelection.collapsed(
                  index: selection.extentIndex,
                  offset: selection.extentOffset - 1));
        } else {
          String forward = _codeTextAfter(selection.extent);
          final int indentSizeInForward = _prefixWhitespaceCount(forward);
          if (indentSizeInForward > 0 &&
              indentSizeInForward % indent.length == 0) {
            forward = forward.substring(indent.length);
          } else {
            // Delete the next character normally
            final Characters characters = forward.characters;
            forward = characters.skip(1).string;
          }
          newCodeLines[selection.extentIndex] = extentLine.copyWith(
              text: _codeTextBefore(selection.extent) + forward);
          value = value.copyWith(
              codeLines: newCodeLines,
              selection: CodeLineSelection.collapsed(
                  index: selection.extentIndex,
                  offset: selection.extentOffset));
        }
      }
    } else {
      _deleteSelection();
    }
    makeCursorCenterIfInvisible();
  }

  void _deleteWordBackward() {
    if (!selection.isCollapsed) {
      _deleteBackward();
      return;
    }
    if (selection.extentOffset == 0) {
      _deleteBackward();
      return;
    }
    final String current = extentLine.text;
    int offset = selection.extentOffset - 1;
    while (offset > 0) {
      if (current.codeUnitAt(offset) == _kUnitCodeWhitespace) {
        offset--;
      } else {
        break;
      }
    }
    final int codeUnit = current.codeUnitAt(offset);
    bool isBeforeAlphanumeric = _isAlphanumeric(codeUnit);
    int i = offset - 1;
    while (i > 0) {
      bool isCurrentAlphanumeric = _isAlphanumeric(current.codeUnitAt(i));
      if (isBeforeAlphanumeric != isCurrentAlphanumeric) {
        break;
      }
      isBeforeAlphanumeric = isCurrentAlphanumeric;
      i--;
    }
    if (i <= 0) {
      i = 0;
    } else {
      i++;
    }
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    newCodeLines[selection.extentIndex] = extentLine.copyWith(
        text: _codeTextBefore(selection.extent.copyWith(offset: i)) +
            _codeTextAfter(selection.extent));
    value = value.copyWith(
      codeLines: newCodeLines,
      selection: CodeLineSelection.collapsed(
        index: selection.extentIndex,
        offset: i,
      ),
    );
    makeCursorVisible();
  }

  void _deleteWordForward() {
    if (!selection.isCollapsed) {
      _deleteForward();
      return;
    }
    if (selection.extentOffset >= extentLine.length) {
      _deleteForward();
      return;
    }
    final String current = extentLine.text;
    if (current.isEmpty) {
      return;
    }
    int offset = selection.extentOffset;
    while (offset < current.length) {
      if (current.codeUnitAt(offset) == _kUnitCodeWhitespace) {
        offset++;
      } else {
        break;
      }
    }
    final int codeUnit = current.codeUnitAt(offset);
    bool isBeforeAlphanumeric = _isAlphanumeric(codeUnit);
    int i = offset + 1;
    while (i < current.length) {
      bool isCurrentAlphanumeric = _isAlphanumeric(current.codeUnitAt(i));
      if (isBeforeAlphanumeric != isCurrentAlphanumeric) {
        break;
      }
      isBeforeAlphanumeric = isCurrentAlphanumeric;
      i++;
    }
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    newCodeLines[selection.extentIndex] = extentLine.copyWith(
        text: _codeTextBefore(selection.extent) +
            _codeTextAfter(selection.extent.copyWith(offset: i)));
    value = value.copyWith(
      codeLines: newCodeLines,
    );
    makeCursorVisible();
  }

  void _applyNewLine() {
    final CodeLines newCodeLines = codeLines.sublines(0, selection.startIndex);
    final CodeLine before = _codeLineBefore(selection.start);
    final CodeLine after = _codeLineAfter(selection.end);
    newCodeLines.add(before);
    final String alignIndent = before.substring(0, before.text.indentLength);
    final int offset;
    // If the enter tap in a closure, we should add a new code line inside the closure
    // with an addtional indent.
    // e.g.
    // {|} => {
    //           |
    //        }
    if (_selectionInClosure) {
      newCodeLines.add(CodeLine(alignIndent + indent));
      offset = newCodeLines.last.length;
    } else {
      offset = alignIndent.length;
    }
    // Align the next line's intent with pre code line
    newCodeLines.add(after.copyWith(text: alignIndent + after.text));
    if (selection.endIndex + 1 < codeLines.length) {
      newCodeLines.addFrom(codeLines, selection.endIndex + 1);
    }
    value = value.copyWith(
      codeLines: newCodeLines,
      selection: CodeLineSelection.collapsed(
          index: selection.startIndex + 1, offset: offset),
    );
    makeCursorCenterIfInvisible();
  }

  void _applyIndent() {
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    if (selection.isSameLine) {
      if (selection.isCollapsed ||
          selection.startOffset != 0 ||
          selection.endOffset != endLine.length) {
        final String textBefore = _codeTextBefore(selection.start);
        final int indentLength =
            indent.length - textBefore.length % indent.length;
        newCodeLines[selection.extentIndex] = extentLine.copyWith(
            text: textBefore +
                ' ' * indentLength +
                _codeTextAfter(selection.end));
        value = value.copyWith(
            codeLines: newCodeLines,
            selection: CodeLineSelection.collapsed(
                index: selection.startIndex,
                offset: selection.startOffset + indentLength));
      } else {
        // This whole line is selected, just add the indent
        newCodeLines[selection.extentIndex] =
            extentLine.copyWith(text: _applyTextIndent(extentLine.text));
        value = value.copyWith(
            codeLines: newCodeLines,
            selection: selection.copyWith(
                baseOffset: selection.baseOffset == 0
                    ? 0
                    : newCodeLines[selection.baseIndex].length,
                extentOffset: selection.extentOffset == 0
                    ? 0
                    : newCodeLines[selection.extentIndex].length));
      }
    } else {
      for (int i = selection.startIndex; i <= selection.endIndex; i++) {
        // Do not apply indent to the last line if the offset is 0
        if (i == selection.endIndex && selection.endOffset == 0) {
          continue;
        }
        List<CodeLine> chunks = codeLines[i].chunks;
        if (chunks.isNotEmpty && i != selection.endIndex) {
          // Apply indent to collapsed chunks
          chunks = _applyIndents(chunks);
        }
        newCodeLines[i] = codeLines[i].copyWith(
            text: _applyTextIndent(codeLines[i].text), chunks: chunks);
      }
      value = value.copyWith(
          codeLines: newCodeLines,
          selection: selection.copyWith(
            baseOffset:
                _whitespaceCountBefore(baseLine.text, selection.baseOffset) ==
                        selection.baseOffset
                    ? selection.baseOffset
                    : selection.baseOffset +
                        (newCodeLines[selection.baseIndex].length -
                            baseLine.text.length),
            extentOffset: _whitespaceCountBefore(
                        extentLine.text, selection.extentOffset) ==
                    selection.extentOffset
                ? selection.extentOffset
                : selection.extentOffset +
                    (newCodeLines[selection.extentIndex].length -
                        extentLine.text.length),
          ));
    }
    makeCursorCenterIfInvisible();
  }

  void _applyOutdent() {
    final CodeLines newCodeLines;
    if (selection.isSameLine) {
      final CodeLine outdentCodeLine =
          extentLine.copyWith(text: _applyTextOutdent(extentLine.text));
      if (outdentCodeLine == extentLine) {
        // Nothing changed
        return;
      }
      newCodeLines = CodeLines.from(codeLines);
      newCodeLines[selection.extentIndex] = outdentCodeLine;
    } else {
      final CodeLines outdentCodeLines = CodeLines.of([]);
      bool lastSkipped = false;
      for (int i = selection.startIndex; i <= selection.endIndex; i++) {
        // Do not apply outdent to the last line if the offset is 0
        if (i == selection.endIndex && selection.endOffset == 0) {
          lastSkipped = true;
          continue;
        }
        List<CodeLine> chunks = codeLines[i].chunks;
        if (chunks.isNotEmpty && i != selection.endIndex) {
          // Apply indent to collapsed chunks
          chunks = _applyOutdents(chunks);
        }
        outdentCodeLines.add(codeLines[i].copyWith(
            text: _applyTextOutdent(codeLines[i].text), chunks: chunks));
      }
      if (outdentCodeLines.equals(codeLines.sublines(selection.startIndex,
          lastSkipped ? selection.endIndex : selection.endIndex + 1))) {
        // Nothing changed
        return;
      }
      newCodeLines = CodeLines.from(codeLines);
      for (int i = 0; i < outdentCodeLines.length; i++) {
        newCodeLines[i + selection.startIndex] = outdentCodeLines[i];
      }
    }
    // If there are enough whitespace after the selection, we should keep the selection offset.
    final int whitespaceCountAfterBaseLine =
        max(0, _prefixWhitespaceCount(baseLine.text) - selection.baseOffset);
    final int baseOffset = max(
        0,
        selection.baseOffset -
            max(
                0,
                baseLine.length -
                    newCodeLines[selection.baseIndex].length -
                    whitespaceCountAfterBaseLine));
    final int whitespaceCountAfterExtentLine = max(
        0, _prefixWhitespaceCount(extentLine.text) - selection.extentOffset);
    final int extentOffset = max(
        0,
        selection.extentOffset -
            max(
                0,
                extentLine.length -
                    newCodeLines[selection.extentIndex].length -
                    whitespaceCountAfterExtentLine));
    value = value.copyWith(
        codeLines: newCodeLines,
        selection: selection.copyWith(
          baseOffset: baseOffset,
          extentOffset: extentOffset,
        ));
    makeCursorCenterIfInvisible();
  }

  void _transposeCharacters() {
    if (!selection.isCollapsed) {
      return;
    }
    if (selection.baseIndex == 0 && selection.baseOffset == 0) {
      return;
    }
    if (selection.baseOffset == 0) {
      final CodeLines newCodeLines;
      final int newOffset;
      final CodeLine preLine = codeLines[selection.baseIndex - 1];
      if (baseLine.length == 0) {
        if (preLine.length == 0) {
          return;
        }
        newCodeLines = CodeLines.from(codeLines);
        final String take = preLine.takeLastCharacter(1);
        newCodeLines[selection.baseIndex - 1] =
            preLine.copyWith(text: preLine.skipLastCharacter(1));
        newCodeLines[selection.baseIndex] = baseLine.copyWith(text: take);
        newOffset = take.length;
      } else {
        newCodeLines = CodeLines.from(codeLines);
        newCodeLines[selection.baseIndex - 1] =
            preLine.copyWith(text: preLine.text + baseLine.takeCharacter(1));
        newCodeLines[selection.baseIndex] =
            baseLine.copyWith(text: baseLine.skipCharacter(1));
        newOffset = 0;
      }
      value = value.copyWith(
          codeLines: newCodeLines,
          selection: selection.copyWith(
            baseOffset: newOffset,
            extentOffset: newOffset,
          ));
    } else if (selection.baseOffset == baseLine.length &&
        baseLine.characterLength == 1) {
      if (selection.baseIndex == 0) {
        return;
      }
      final CodeLine preLine = codeLines[selection.baseIndex - 1];
      final CodeLines newCodeLines = CodeLines.from(codeLines);
      newCodeLines[selection.baseIndex - 1] =
          preLine.copyWith(text: preLine.text + baseLine.text);
      newCodeLines[selection.baseIndex] = baseLine.copyWith(text: '');
      value = value.copyWith(
          codeLines: newCodeLines,
          selection: selection.copyWith(
            baseOffset: 0,
            extentOffset: 0,
          ));
    } else if (selection.baseOffset == baseLine.length) {
      final CodeLines newCodeLines = CodeLines.from(codeLines);
      newCodeLines[selection.baseIndex] = baseLine.copyWith(
          text: baseLine.skipLastCharacter(2) +
              baseLine.takeCharacterAtLastIndex(0) +
              baseLine.takeCharacterAtLastIndex(1));
      value = value.copyWith(
        codeLines: newCodeLines,
      );
    } else {
      final CodeLines newCodeLines = CodeLines.from(codeLines);
      final Characters characters = baseLine.text.characters;
      final int index =
          baseLine.text.substring(0, selection.baseOffset).characters.length;
      final String start = characters.take(index - 1).string;
      final String right = characters.elementAt(index);
      final String left = characters.elementAt(index - 1);
      final String end =
          characters.takeLast(characters.length - index - 1).string;
      newCodeLines[selection.baseIndex] =
          baseLine.copyWith(text: start + right + left + end);
      value = value.copyWith(
          codeLines: newCodeLines,
          selection: selection.copyWith(
            baseOffset: selection.baseOffset + right.length,
            extentOffset: selection.extentOffset + right.length,
          ));
    }
  }

  void _replaceRange(String replacement, [CodeLineSelection? range]) {
    range ??= selection;
    if (replacement.isEmpty && range.isCollapsed) {
      return;
    }
    final List<String> replaceCodeLines =
        CodeLineUtils.toTextLines(replacement);
    final CodeLines newCodeLines = codeLines.sublines(0, range.startIndex);
    int index = 0;
    int offset = 0;
    if (replaceCodeLines.length == 1) {
      newCodeLines.add(codeLines[range.endIndex].copyWith(
          text: _codeTextBefore(range.start) +
              replaceCodeLines.first +
              _codeTextAfter(range.end)));
      index = range.startIndex;
      offset = range.startOffset + replaceCodeLines.first.length;
    } else {
      for (int i = 0; i < replaceCodeLines.length; i++) {
        final String replaceCodeLine = replaceCodeLines[i];
        if (i == 0) {
          newCodeLines
              .add(CodeLine(_codeTextBefore(range.start) + replaceCodeLine));
        } else if (i == replaceCodeLines.length - 1) {
          newCodeLines.add(codeLines[range.endIndex]
              .copyWith(text: replaceCodeLine + _codeTextAfter(range.end)));
          index = newCodeLines.length - 1;
          offset = replaceCodeLine.length;
        } else {
          newCodeLines.add(CodeLine(replaceCodeLine));
        }
      }
    }
    if (range.endIndex + 1 < codeLines.length) {
      newCodeLines.addFrom(codeLines, range.endIndex + 1);
    }
    value = CodeLineEditingValue(
        codeLines: newCodeLines,
        selection: CodeLineSelection.collapsed(
            index: index, offset: offset, affinity: range.extentAffinity));
    makeCursorCenterIfInvisible();
  }

  void _replaceAll(Pattern pattern, String replacement) {
    if (pattern is String && pattern.isEmpty) {
      return;
    }
    int extentOffset = selection.extentOffset;
    for (int i = 0; i < selection.extentIndex; i++) {
      extentOffset += codeLines[i].charCount + lineBreak.value.length;
    }
    final String preText = text;
    int delta = 0;
    final String newText = text.replaceAllMapped(pattern, (match) {
      if (match.end <= extentOffset) {
        delta += replacement.length - (match.end - match.start);
      }
      return replacement;
    });
    if (preText == newText) {
      return;
    }
    final CodeLines newCodeLines = CodeLineUtils.toCodeLines(newText);
    int newExtentIndex = 0;
    int newExtentOffset = 0;
    int start = 0;
    extentOffset += delta;
    final int length = newCodeLines.length;
    for (int i = 0; i < length; i++) {
      final int end =
          start + newCodeLines[i].charCount + lineBreak.value.length;
      if (extentOffset >= start && extentOffset < end) {
        newExtentIndex = i;
        newExtentOffset = extentOffset - start;
        break;
      }
      start = end;
    }
    value = CodeLineEditingValue(
        codeLines: newCodeLines,
        selection: CodeLineSelection.collapsed(
            index: newExtentIndex, offset: newExtentOffset));
    makeCursorCenterIfInvisible();
  }

  List<CodeLine> _applyIndents(List<CodeLine> children) {
    if (children.isEmpty) {
      return children;
    }
    final List<CodeLine> newChildren = [];
    for (final CodeLine codeLine in children) {
      newChildren.add(CodeLine(
          _applyTextIndent(codeLine.text), _applyIndents(codeLine.chunks)));
    }
    return newChildren;
  }

  List<CodeLine> _applyOutdents(List<CodeLine> children) {
    if (children.isEmpty) {
      return children;
    }
    final List<CodeLine> newChildren = [];
    for (final CodeLine codeLine in children) {
      newChildren.add(CodeLine(
          _applyTextOutdent(codeLine.text), _applyOutdents(codeLine.chunks)));
    }
    return newChildren;
  }

  String _applyTextIndent(String text) {
    // Indent the mod count of whitespace
    final int mod = _prefixWhitespaceCount(text) % indent.length;
    return ' ' * (mod == 0 ? indent.length : mod) + text;
  }

  String _applyTextOutdent(String text) {
    final int index = _prefixWhitespaceCount(text);
    if (index == 0) {
      return text;
    }
    // Outdent the mod count of whitespace
    final int mod = index % indent.length;
    return text.substring(mod == 0 ? indent.length : mod);
  }

  String _codeTextBefore(CodeLinePosition position) {
    return codeLines[position.index].substring(0, position.offset);
  }

  String _codeTextAfter(CodeLinePosition position) {
    return codeLines[position.index].substring(position.offset);
  }

  CodeLine _codeLineBefore(CodeLinePosition position) {
    return CodeLine(_codeTextBefore(position));
  }

  CodeLine _codeLineAfter(CodeLinePosition position) {
    return CodeLine(_codeTextAfter(position), codeLines[position.index].chunks);
  }

  int _prefixWhitespaceCount(String text) {
    int index = 0;
    for (; index < text.length; index++) {
      if (text.codeUnitAt(index) != _kUnitCodeWhitespace) {
        break;
      }
    }
    return index;
  }

  int _whitespaceCountBefore(String text, int offset) {
    int count = 0;
    for (int i = offset - 1; i >= 0; i--) {
      if (text.codeUnitAt(i) != _kUnitCodeWhitespace) {
        break;
      }
      count++;
    }
    return count;
  }

  bool _isWrapedByClosureSymbol(String text, int offset) {
    if (text.isEmpty) {
      return false;
    }
    if (offset == 0 || offset == text.length) {
      return false;
    }
    return _kClosureAndQuates.contains(text.substring(offset - 1, offset + 1));
  }

  bool _isMultipleIndent(String text) =>
      text.isNotEmpty &&
      text.length % indent.length == 0 &&
      _prefixWhitespaceCount(text) == text.length;

  bool get _selectionInClosure {
    int? forwardUnitCode;
    for (int i = selection.startOffset - 1; i >= 0; i--) {
      final int codeUnit = startLine.codeUnitAt(i);
      if (codeUnit == _kUnitCodeWhitespace) {
        continue;
      }
      forwardUnitCode = codeUnit;
      break;
    }
    if (forwardUnitCode == null) {
      return false;
    }
    int? backwardUnitCode;
    for (int i = selection.endOffset; i < endLine.length; i++) {
      final int codeUnit = endLine.codeUnitAt(i);
      if (codeUnit == _kUnitCodeWhitespace) {
        continue;
      }
      backwardUnitCode = codeUnit;
      break;
    }
    if (backwardUnitCode == null) {
      return false;
    }
    return _kClosures
        .contains(String.fromCharCodes([forwardUnitCode, backwardUnitCode]));
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required TextStyle style,
  }) {
    if (spanBuilder != null) {
      return spanBuilder!
          .call(context: context, codeLines: codeLines, style: style);
    }
    return TextSpan(text: codeLines.asString(TextLineBreak.lf), style: style);
  }
}

class _CodeLineEditingCache {
  final CodeLineEditingController controller;
  late _CodeLineEditingCacheNode _node;
  late bool _markNewRecord;

  _CodeLineEditingCache(this.controller) {
    controller.addListener(_onValueChanged);
    _node = _CodeLineEditingCacheNode(controller.value);
    _markNewRecord = false;
  }

  bool get canUndo => _node.pre != null;

  bool get canRedo => _node.next != null;

  void undo() {
    if (_node.pre != null) {
      _node = _node.pre!;
      controller.value = _node.value;
    }
  }

  void redo() {
    if (_node.next != null) {
      _node = _node.next!;
      controller.value = _node.value;
    }
  }

  void clear() {
    _node = _CodeLineEditingCacheNode(controller.value);
    _markNewRecord = false;
  }

  void dispose() {
    controller.removeListener(_onValueChanged);
  }

  void markNewRecord(bool flag) {
    _markNewRecord = flag;
  }

  void _onValueChanged() {
    if (_node.value == controller.value) {
      return;
    }
    if (_node.isInitial) {
      _appendNewNode();
      return;
    }
    if (!_node.isTail) {
      _appendNewNode();
      return;
    }
    if (_markNewRecord) {
      _markNewRecord = false;
      _appendNewNode();
      return;
    }
    _node.value = controller.value;
  }

  void _appendNewNode() {
    final _CodeLineEditingCacheNode newNode =
        _CodeLineEditingCacheNode(controller.value);
    if (_node.next != null) {
      _node.next!.pre = null;
    }
    _node.next = newNode;
    newNode.pre = _node;
    _node = newNode;
  }
}

class _CodeLineEditingCacheNode {
  _CodeLineEditingCacheNode? pre;
  _CodeLineEditingCacheNode? next;
  CodeLineEditingValue value;

  _CodeLineEditingCacheNode(this.value);

  bool get isRoot => pre == null;

  bool get isInitial => pre == null && next == null;

  bool get isTail => next == null;
}

extension _StringExtension on String {
  int get indentLength {
    int index = 0;
    for (; index < length; index++) {
      if (codeUnitAt(index) != _kUnitCodeWhitespace) {
        break;
      }
    }
    return index;
  }

  int getOffsetWithoutIndent(String indent) {
    int index = 0;
    while (startsWith(indent, index)) {
      index += indent.length;
    }
    return index;
  }

  String insert(String value, int index) {
    return substring(0, index) + value + substring(index);
  }
}

class _CodeLineEditingControllerDelegate implements CodeLineEditingController {
  late CodeLineEditingController _delegate;
  final List<ui.VoidCallback> _listeners = [];

  CodeLineEditingController get delegate => _delegate;

  set delegate(CodeLineEditingController value) {
    for (final listener in _listeners) {
      value.addListener(listener);
    }
    _delegate = value;
    notifyListeners();
  }

  @override
  CodeLines get codeLines => _delegate.codeLines;

  @override
  set codeLines(CodeLines value) {
    _delegate.codeLines = value;
  }

  @override
  ui.TextRange get composing => _delegate.composing;

  @override
  set composing(ui.TextRange value) {
    _delegate.composing = value;
  }

  @override
  CodeLineSelection get selection => _delegate.selection;

  @override
  set selection(CodeLineSelection value) {
    _delegate.selection = value;
  }

  @override
  String get text => _delegate.text;

  @override
  set text(String value) {
    _delegate.text = value;
  }

  @override
  CodeLineEditingValue get value => _delegate.value;

  @override
  set value(CodeLineEditingValue value) {
    _delegate.value = value;
  }

  @override
  void addListener(ui.VoidCallback listener) {
    _listeners.add(listener);
    _delegate.addListener(listener);
  }

  @override
  void applyIndent() {
    _delegate.applyIndent();
  }

  @override
  void applyNewLine() {
    _delegate.applyNewLine();
  }

  @override
  void applyOutdent() {
    _delegate.applyOutdent();
  }

  @override
  CodeLine get baseLine => _delegate.baseLine;

  @override
  void bindEditor(GlobalKey<State<StatefulWidget>> key) {
    _delegate.bindEditor(key);
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required TextStyle style,
  }) {
    return _delegate.buildTextSpan(context: context, style: style);
  }

  @override
  bool get canRedo => _delegate.canRedo;

  @override
  bool get canUndo => _delegate.canUndo;

  @override
  void cancelSelection() {
    _delegate.cancelSelection();
  }

  @override
  void clearComposing() {
    _delegate.clearComposing();
  }

  @override
  void clearHistory() {
    _delegate.clearHistory();
  }

  @override
  void collapseChunk(int index, int end) {
    _delegate.collapseChunk(index, end);
  }

  @override
  Future<void> copy() => _delegate.copy();

  @override
  void cut() {
    _delegate.cut();
  }

  @override
  void deleteBackward() {
    _delegate.deleteBackward();
  }

  @override
  void deleteForward() {
    _delegate.deleteForward();
  }

  @override
  void deleteWordBackward() {
    _delegate.deleteWordBackward();
  }

  @override
  void deleteWordForward() {
    _delegate.deleteWordForward();
  }

  @override
  void deleteLineForward() {
    _delegate.deleteLineForward();
  }

  @override
  void deleteLineBackward() {
    _delegate.deleteLineBackward();
  }

  @override
  void deleteSelection() {
    _delegate.deleteSelection();
  }

  @override
  void deleteSelectionLines([bool keepExtentOffset = true]) {
    _delegate.deleteSelectionLines(keepExtentOffset);
  }

  @override
  void dispose() {
    _listeners.clear();
    _delegate.dispose();
  }

  @override
  void edit(TextEditingValue newValue) {
    _delegate.edit(newValue);
  }

  @override
  CodeLine get endLine => _delegate.endLine;

  @override
  void expandChunk(int index) {
    _delegate.expandChunk(index);
  }

  @override
  void extendSelection(AxisDirection direction) {
    _delegate.extendSelection(direction);
  }

  @override
  void extendSelectionToLineEnd() {
    _delegate.extendSelectionToLineEnd();
  }

  @override
  void extendSelectionToLineStart() {
    _delegate.extendSelectionToLineStart();
  }

  @override
  void extendSelectionToPageEnd() {
    _delegate.extendSelectionToPageEnd();
  }

  @override
  void extendSelectionToPageStart() {
    _delegate.extendSelectionToPageStart();
  }

  @override
  void extendSelectionToWordBoundaryBackward() {
    _delegate.extendSelectionToWordBoundaryBackward();
  }

  @override
  void extendSelectionToWordBoundaryForward() {
    _delegate.extendSelectionToWordBoundaryForward();
  }

  @override
  CodeLine get extentLine => _delegate.extentLine;

  @override
  bool get hasListeners => _delegate.hasListeners;

  @override
  int index2lineIndex(int index) {
    return _delegate.index2lineIndex(index);
  }

  @override
  bool get isAllSelected => _delegate.isAllSelected;

  @override
  bool get isComposing => _delegate.isComposing;

  @override
  bool get isEmpty => _delegate.isEmpty;

  @override
  int get lineCount => _delegate.lineCount;

  @override
  CodeLineIndex lineIndex2Index(int lineIndex) {
    return _delegate.lineIndex2Index(lineIndex);
  }

  @override
  void makeCursorCenterIfInvisible() {
    _delegate.makeCursorCenterIfInvisible();
  }

  @override
  void makeCursorVisible() {
    _delegate.makeCursorVisible();
  }

  @override
  void makePositionCenterIfInvisible(CodeLinePosition position) {
    _delegate.makePositionCenterIfInvisible(position);
  }

  @override
  void makePositionVisible(CodeLinePosition position) {
    _delegate.makePositionVisible(position);
  }

  @override
  void moveCursor(AxisDirection direction) {
    _delegate.moveCursor(direction);
  }

  @override
  void moveCursorToLineEnd() {
    _delegate.moveCursorToLineEnd();
  }

  @override
  void moveCursorToLineStart() {
    _delegate.moveCursorToLineStart();
  }

  @override
  void moveCursorToPageDown() {
    _delegate.moveCursorToPageDown();
  }

  @override
  void moveCursorToPageEnd() {
    _delegate.moveCursorToPageEnd();
  }

  @override
  void moveCursorToPageStart() {
    _delegate.moveCursorToPageStart();
  }

  @override
  void moveCursorToPageUp() {
    _delegate.moveCursorToPageUp();
  }

  @override
  void moveCursorToWordBoundaryBackward() {
    _delegate.moveCursorToWordBoundaryBackward();
  }

  @override
  void moveCursorToWordBoundaryForward() {
    _delegate.moveCursorToWordBoundaryForward();
  }

  @override
  void moveSelectionLinesDown() {
    _delegate.moveSelectionLinesDown();
  }

  @override
  void moveSelectionLinesUp() {
    _delegate.moveSelectionLinesUp();
  }

  @override
  void forceRepaint() {
    _delegate.forceRepaint();
  }

  @override
  void notifyListeners() {
    _delegate.notifyListeners();
  }

  @override
  CodeLineOptions get options => _delegate.options;

  @override
  void paste() {
    _delegate.paste();
  }

  @override
  CodeLineEditingValue? get preValue => _delegate.preValue;

  @override
  CodeLineSelection get unforldLineSelection => _delegate.unforldLineSelection;

  @override
  void redo() {
    _delegate.redo();
  }

  @override
  void removeListener(ui.VoidCallback listener) {
    _listeners.remove(listener);
    _delegate.removeListener(listener);
  }

  @override
  void replaceAll(Pattern pattern, String replacement) {
    _delegate.replaceAll(pattern, replacement);
  }

  @override
  void replaceSelection(String replacement, [CodeLineSelection? selection]) {
    _delegate.replaceSelection(replacement, selection);
  }

  @override
  void runRevocableOp(ui.VoidCallback op) {
    _delegate.runRevocableOp(op);
  }

  @override
  void selectAll() {
    _delegate.selectAll();
  }

  @override
  void selectLine(int index) {
    _delegate.selectLine(index);
  }

  @override
  void selectLines(int base, int extent) {
    _delegate.selectLines(base, extent);
  }

  @override
  String get selectedText => _delegate.selectedText;

  @override
  CodeLine get startLine => _delegate.startLine;

  @override
  set textAsync(String value) {
    _delegate.textAsync = value;
  }

  @override
  void transposeCharacters() {
    _delegate.transposeCharacters();
  }

  @override
  void undo() {
    _delegate.undo();
  }
}
