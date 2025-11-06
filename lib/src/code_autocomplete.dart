part of re_editor;

/// Define code autocomplate prompt information.
///
/// See also [CodeKeywordPrompt], [CodeFieldPrompt] and [CodeFunctionPrompt].
abstract class CodePrompt {
  const CodePrompt({required this.word});

  /// Content associated with user input.
  ///
  /// e.g. User input is 're', the prompt word 'return' will be displayed to user.
  final String word;

  /// Get the final auto completion content. In most cases it is equal to [word], but there are some exceptions.
  /// For example, for functions, auto completion of parameters may be required.
  ///
  /// e.g. User input is 'he', 'hello(String name)' will be auto completed.
  CodeAutocompleteResult get autocomplete;

  /// Check whether the input meets this prompt condition.
  bool match(String input);
}

/// The keyword autocomplate prompt. such as 'return', 'class', 'new' and so on.
class CodeKeywordPrompt extends CodePrompt {
  const CodeKeywordPrompt({required super.word});

  @override
  CodeAutocompleteResult get autocomplete =>
      CodeAutocompleteResult.fromWord(word);

  @override
  bool match(String input) {
    return word != input && word.startsWith(input);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeKeywordPrompt && other.word == word;
  }

  @override
  int get hashCode => word.hashCode;
}

class CodeCaseInsensitiveKeywordPrompt extends CodeKeywordPrompt {
  const CodeCaseInsensitiveKeywordPrompt({required super.word});

  @override
  bool match(String input) {
    String inputUpper = input.toUpperCase();
    String wordUpper = word.toUpperCase();
    return wordUpper != inputUpper && wordUpper.startsWith(inputUpper);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeCaseInsensitiveKeywordPrompt && other.word == word;
  }

  @override
  int get hashCode => word.hashCode;
}

/// The field autocomplate prompt. Compared to [CodeKeywordPrompt],
/// type definitions also need to be provided.
///
/// If a line of code is 'String foo;', 'foo' is the word and 'String' is the type.
class CodeFieldPrompt extends CodePrompt {
  const CodeFieldPrompt({
    required super.word,
    required this.type,
    this.customAutocomplete,
  });

  /// The field type name.
  final String type;

  /// Will use custom autocomplete rather than word if this is not null.
  final CodeAutocompleteResult? customAutocomplete;

  @override
  CodeAutocompleteResult get autocomplete =>
      customAutocomplete ?? CodeAutocompleteResult.fromWord(word);

  @override
  bool match(String input) {
    return word != input && word.startsWith(input);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeFieldPrompt &&
        other.word == word &&
        other.type == type &&
        other.customAutocomplete == customAutocomplete;
  }

  @override
  int get hashCode => Object.hash(word, type, customAutocomplete);
}

/// The function autocomplate prompt.
class CodeFunctionPrompt extends CodePrompt {
  const CodeFunctionPrompt({
    required super.word,
    required this.type,
    this.parameters = const {},
    this.optionalParameters = const {},
    this.customAutocomplete,
  });

  /// The function return type.
  final String type;

  /// The function required parameters.
  final Map<String, String> parameters;

  /// The function optional parameters.
  final Map<String, String> optionalParameters;

  /// Will use custom autocomplete rather than word if this is not null.
  final CodeAutocompleteResult? customAutocomplete;

  @override
  CodeAutocompleteResult get autocomplete =>
      customAutocomplete ??
      CodeAutocompleteResult.fromWord('$word(${parameters.keys.join(', ')})');

  @override
  bool match(String input) {
    return word != input && word.startsWith(input);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CodeFunctionPrompt &&
        other.word == word &&
        other.type == type &&
        mapEquals(other.parameters, parameters) &&
        mapEquals(other.optionalParameters, optionalParameters) &&
        other.customAutocomplete == customAutocomplete;
  }

  @override
  int get hashCode => Object.hash(
      word, type, parameters, optionalParameters, customAutocomplete);
}

/// The autocomplete result selected by user, the editor will apply this
/// to code content.
class CodeAutocompleteResult {
  const CodeAutocompleteResult(
      {required this.input, required this.word, required this.selection});

  factory CodeAutocompleteResult.fromWord(String word) {
    return CodeAutocompleteResult(
        input: '',
        word: word,
        selection: TextSelection.collapsed(offset: word.length));
  }

  /// The autocomplete text.
  /// e.g.
  /// If user inputs `go` and the word is `good`, we will replace `go` with `good`.
  final String input;
  final String word;

  /// The new selection after the autocompletion.
  final TextSelection selection;
}

/// The current user input and prompts for editing a run of text.
class CodeAutocompleteEditingValue {
  const CodeAutocompleteEditingValue({
    required this.input,
    required this.prompts,
    required this.index,
  });

  /// User input content.
  final String input;

  /// Matched code prompts.
  final List<CodePrompt> prompts;

  /// Current selected code prompt.
  final int index;

  CodeAutocompleteEditingValue copyWith({
    String? input,
    List<CodePrompt>? prompts,
    int? index,
  }) {
    return CodeAutocompleteEditingValue(
      input: input ?? this.input,
      prompts: prompts ?? this.prompts,
      index: index ?? this.index,
    );
  }

  CodeAutocompleteResult get autocomplete {
    final CodeAutocompleteResult result = prompts[index].autocomplete;
    if (result.word.isEmpty) {
      return result;
    }
    final TextSelection finalSelection = result.selection.copyWith(
      baseOffset: result.selection.baseOffset - input.length,
      extentOffset: result.selection.extentOffset - input.length,
    );
    return CodeAutocompleteResult(
      input: input,
      word: result.word,
      selection: finalSelection,
    );
  }
}

/// Builds the overlay autocomplete prompts view.
typedef CodeAutocompleteWidgetBuilder = PreferredSizeWidget Function(
    BuildContext context,
    ValueNotifier<CodeAutocompleteEditingValue> notifier,
    ValueChanged<CodeAutocompleteResult> onSelected);

/// The autocomplete prompts builder.
abstract class CodeAutocompletePromptsBuilder {
  /// Build the prompts with the current code.
  CodeAutocompleteEditingValue? build(
    BuildContext context,
    CodeLine codeLine,
    CodeLineSelection selection,
  );
}

/// The default autocomplete prompts builder.
abstract class DefaultCodeAutocompletePromptsBuilder
    implements CodeAutocompletePromptsBuilder {
  /// Constructs the builder with defined prompts.
  factory DefaultCodeAutocompletePromptsBuilder({
    Mode? language,
    List<CodeKeywordPrompt> keywordPrompts = const [],
    List<CodePrompt> directPrompts = const [],
    Map<String, List<CodePrompt>> relatedPrompts = const {},
  }) =>
      _DefaultCodeAutocompletePromptsBuilder(
        language: language,
        keywordPrompts: keywordPrompts,
        directPrompts: directPrompts,
        relatedPrompts: relatedPrompts,
      );
}

/// A widget enables code autocomplete for [CodeEditor].
///
/// Developers can customize the view styles and prompt logic they need.
///
/// The following is a common usage.
///
/// ```
/// CodeAutocomplete(
///   viewBuilder: (context, notifier, onSelected) {
///     // TODO build the options list widget.
///   },
///   promptsBuilder: DefaultCodeAutocompletePromptsBuilder(
///     language: langDart,
///     directPrompts: [
///       CodeFieldPrompt(
///         word: 'foo',
///         type: 'String'
///       ),
///       CodeFunctionPrompt(
///         word: 'hello',
///         type: 'void',
///         parameters: {
///           'value': 'String',
///         }
///       )
///     ],
///   ),
///   child: CodeEditor()
/// )
/// ```
class CodeAutocomplete extends StatelessWidget {
  const CodeAutocomplete({
    super.key,
    required this.viewBuilder,
    required this.promptsBuilder,
    required this.child,
  });

  final CodeAutocompleteWidgetBuilder viewBuilder;
  final CodeAutocompletePromptsBuilder promptsBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _CodeAutocomplete(
        viewBuilder: viewBuilder, promptsBuilder: promptsBuilder, child: child);
  }
}

class _DefaultCodeAutocompletePromptsBuilder
    implements DefaultCodeAutocompletePromptsBuilder {
  final Mode? language;
  final List<CodeKeywordPrompt> keywordPrompts;
  final List<CodePrompt> directPrompts;
  final Map<String, List<CodePrompt>> relatedPrompts;

  final Set<CodePrompt> _allKeywordPrompts = {};

  _DefaultCodeAutocompletePromptsBuilder(
      {this.language,
      required this.keywordPrompts,
      required this.directPrompts,
      required this.relatedPrompts}) {
    _allKeywordPrompts.addAll(keywordPrompts);
    _allKeywordPrompts.addAll(directPrompts);
    final dynamic keywords = language?.keywords;
    if (keywords is Map) {
      final dynamic keywordList = keywords['keyword'];
      if (keywordList is List) {
        _allKeywordPrompts.addAll(
            keywordList.map((keyword) => CodeKeywordPrompt(word: keyword)));
      }
      final dynamic builtInList = keywords['built_in'];
      if (builtInList is List) {
        _allKeywordPrompts.addAll(
            builtInList.map((keyword) => CodeKeywordPrompt(word: keyword)));
      }
      final dynamic literalList = keywords['literal'];
      if (literalList is List) {
        _allKeywordPrompts.addAll(
            literalList.map((keyword) => CodeKeywordPrompt(word: keyword)));
      }
      final dynamic typeList = keywords['type'];
      if (typeList is List) {
        _allKeywordPrompts.addAll(
            typeList.map((keyword) => CodeKeywordPrompt(word: keyword)));
      }
    }
  }

  @override
  CodeAutocompleteEditingValue? build(
      BuildContext context, CodeLine codeLine, CodeLineSelection selection) {
    final String text = codeLine.text;
    final Characters charactersBefore =
        text.substring(0, selection.extentOffset).characters;
    if (charactersBefore.isEmpty) {
      return null;
    }
    final Characters charactersAfter =
        text.substring(selection.extentOffset).characters;
    // FIXME：Check whether the position is inside a string
    if (charactersBefore.containsSymbols(const ['\'', '"']) &&
        charactersAfter.containsSymbols(const ['\'', '"'])) {
      return null;
    }
    // TODO Should check operator `->` for some languages like c/c++
    final Iterable<CodePrompt> prompts;
    final String input;
    if (charactersBefore.takeLast(1).string == '.') {
      input = '';
      int start = charactersBefore.length - 2;
      for (; start >= 0; start--) {
        if (!charactersBefore.elementAt(start).isValidVariablePart) {
          break;
        }
      }
      final String target = charactersBefore
          .getRange(start + 1, charactersBefore.length - 1)
          .string;
      prompts = relatedPrompts[target] ?? const [];
    } else {
      int start = charactersBefore.length - 1;
      for (; start >= 0; start--) {
        if (!charactersBefore.elementAt(start).isValidVariablePart) {
          break;
        }
      }
      input =
          charactersBefore.getRange(start + 1, charactersBefore.length).string;
      if (input.isEmpty) {
        return null;
      }
      if (start > 0 && charactersBefore.elementAt(start) == '.') {
        final int mark = start;
        for (start = start - 1; start >= 0; start--) {
          if (!charactersBefore.elementAt(start).isValidVariablePart) {
            break;
          }
        }
        final String target = charactersBefore.getRange(start + 1, mark).string;
        prompts =
            relatedPrompts[target]?.where((prompt) => prompt.match(input)) ??
                const [];
      } else {
        prompts = _allKeywordPrompts.where((prompt) => prompt.match(input));
      }
    }
    if (prompts.isEmpty) {
      return null;
    }
    return CodeAutocompleteEditingValue(
        input: input, prompts: prompts.toList(), index: 0);
  }
}

class _CodeAutocomplete extends StatefulWidget {
  const _CodeAutocomplete({
    required this.viewBuilder,
    required this.promptsBuilder,
    required this.child,
  });

  final CodeAutocompleteWidgetBuilder viewBuilder;
  final CodeAutocompletePromptsBuilder promptsBuilder;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _CodeAutocompleteState();
}

class _CodeAutocompleteState extends State<_CodeAutocomplete> {
  late final _CodeAutocompleteNavigateAction _navigateAction;
  late final _CodeAutocompleteAction _selectAction;

  ValueChanged<CodeAutocompleteResult>? _onAutocomplete;
  OverlayEntry? _overlayEntry;
  ValueNotifier<CodeAutocompleteEditingValue>? _notifier;

  @override
  void initState() {
    super.initState();
    _navigateAction = _CodeAutocompleteNavigateAction(
      onInvoke: (intent) {
        final CodeAutocompleteEditingValue? value = _notifier?.value;
        if (value == null) {
          return null;
        }
        int newIndex = value.index;
        if (intent.direction == AxisDirection.up) {
          newIndex--;
        } else {
          newIndex++;
        }
        if (newIndex < 0) {
          newIndex = value.prompts.length - 1;
        } else if (newIndex >= value.prompts.length) {
          newIndex = 0;
        }
        _notifier?.value = value.copyWith(
          index: newIndex,
        );
        return intent;
      },
    );
    _selectAction = _CodeAutocompleteAction<CodeShortcutEditableIntent>(
      onInvoke: (intent) {
        final CodeAutocompleteEditingValue? value = _notifier?.value;
        if (value == null) {
          return null;
        }
        _onAutocomplete?.call(value.autocomplete);
        return intent;
      },
    );
  }

  @override
  void didUpdateWidget(covariant _CodeAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Actions(actions: {
      CodeShortcutCursorMoveIntent: _navigateAction,
      CodeShortcutNewLineIntent: _selectAction,
      CodeShortcutIndentIntent: _selectAction,
    }, child: widget.child);
  }

  void show({
    required LayerLink layerLink,
    required Offset position,
    required double lineHeight,
    required CodeLineEditingValue value,
    required ValueChanged<CodeAutocompleteResult> onAutocomplete,
  }) {
    dismiss();
    final CodeAutocompleteEditingValue? autocompleteEditingValue =
        widget.promptsBuilder.build(
      context,
      value.codeLines[value.selection.extentIndex],
      value.selection,
    );
    if (autocompleteEditingValue == null) {
      return;
    }
    _notifier = ValueNotifier(autocompleteEditingValue);
    _onAutocomplete = onAutocomplete;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _buildWidget(context, layerLink, position, lineHeight);
      },
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    _navigateAction.setEnabled(true);
    _selectAction.setEnabled(true);
  }

  void dismiss() {
    _notifier = null;
    _onAutocomplete = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _navigateAction.setEnabled(false);
    _selectAction.setEnabled(false);
  }

  Widget _buildWidget(BuildContext context, LayerLink layerLink,
      Offset position, double lineHeight) {
    final PreferredSizeWidget child =
        widget.viewBuilder(context, _notifier!, (result) {
      _onAutocomplete?.call(result);
    });
    final Size screenSize = MediaQuery.of(context).size;
    final double offsetX;
    if (position.dx + child.preferredSize.width > screenSize.width) {
      offsetX = screenSize.width - (position.dx + child.preferredSize.width);
    } else {
      offsetX = 0;
    }
    final double offsetY;
    if (position.dy + child.preferredSize.height > screenSize.height) {
      offsetY = -child.preferredSize.height - lineHeight;
    } else {
      offsetY = 0;
    }
    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      offset: Offset(offsetX, offsetY),
      child: Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: TapRegion(
                onTapOutside: (event) {
                  dismiss();
                },
                child: CodeEditorTapRegion(
                    child: ExcludeSemantics(
                  child: child,
                ))),
          )),
    );
  }
}

class _CodeAutocompleteAction<T extends Intent> extends CallbackAction<T> {
  bool _isEnabled = false;

  _CodeAutocompleteAction({required super.onInvoke});

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  @override
  bool get isActionEnabled => _isEnabled;
}

class _CodeAutocompleteNavigateAction
    extends _CodeAutocompleteAction<CodeShortcutCursorMoveIntent> {
  _CodeAutocompleteNavigateAction({required super.onInvoke});

  @override
  bool consumesKey(CodeShortcutCursorMoveIntent intent) {
    return intent.direction == AxisDirection.up ||
        intent.direction == AxisDirection.down;
  }
}

extension _CodeAutocompleteStringExtension on String {
  bool get isValidVariablePart {
    final int char = codeUnits.first;
    return (char >= 65 && char <= 90) || // A–Z
        (char >= 97 && char <= 122) || // a–z
        (char >= 48 && char <= 57) || // 0–9
        char == 95; // _
  }
}

extension _CodeAutocompleteCharactersExtension on Characters {
  bool containsSymbols(List<String> symbols) {
    for (int i = length - 1; i >= 0; i--) {
      if (symbols.contains(elementAt(i))) {
        return true;
      }
    }
    return false;
  }
}
