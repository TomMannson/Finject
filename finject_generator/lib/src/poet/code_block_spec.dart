import '../dartpoet.dart';

class CodeBlockSpec implements Spec {
  List<String> statements = [];

  bool get singleLine => statements.join('\n').split('\n').length == 1;

  CodeBlockSpec.empty();

  CodeBlockSpec.lines(this.statements) {
    statements ??= [];
  }

  CodeBlockSpec.line(String line) : this.lines([line]);

  void addLine(String line) {
    statements.add(line);
  }

  void addLines(List<String> lines) {
    statements.addAll(lines);
  }

  @override
  String code({Map<String, Object> args = const {}}) {
    var withBlock = args[KEY_WITH_BLOCK] as bool ?? false;
    var withLambda = args[KEY_WITH_LAMBDA] as bool ?? true;
    if (singleLine && withLambda) {
      return ' => ${statements.single}';
    } else {
      var tmp = statements.join('\n');
      if (withBlock) tmp = '{\n$tmp\n}';
      return tmp;
    }
  }
}

enum CodeBlockEmptiedCollectingMode { nothing, emptyBlock, end }

String collectCodeBlock(
  CodeBlockSpec codeBlock, {
  bool withLambda = true,
  bool withBlock = true,
  CodeBlockEmptiedCollectingMode collectingMode =
      CodeBlockEmptiedCollectingMode.end,
}) {
  if (codeBlock == null) {
    switch (collectingMode) {
      case CodeBlockEmptiedCollectingMode.nothing:
        return '';
      case CodeBlockEmptiedCollectingMode.emptyBlock:
        return '{}';
      case CodeBlockEmptiedCollectingMode.end:
        return ';';
    }
  }
  return codeBlock
      .code(args: {KEY_WITH_BLOCK: withBlock, KEY_WITH_LAMBDA: withLambda});
}

String collectCodeBlocks(List<CodeBlockSpec> codeBlocks) {
  return codeBlocks.map((o) => o.code()).join('\n');
}
