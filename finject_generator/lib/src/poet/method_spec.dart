import '../dartpoet.dart';

class MethodSpec implements Spec {
  DocSpec doc;
  String methodName;
  List<MetaSpec> metas = [];
  List<ParameterSpec> parameters = [];
  TypeToken returnType;
  bool returnNullable;
  CodeBlockSpec codeBlock;
  bool isStatic;
  bool isFactory;
  bool isAbstract;
  List<TypeToken> generics = [];

  bool get hasGeneric => generics.isNotEmpty;
  AsynchronousMode asynchronousMode;

  MethodSpec.build(
    this.methodName, {
    this.doc,
    this.metas,
    this.parameters,
    this.returnType,
    this.codeBlock,
    this.isStatic = false,
    this.isFactory = false,
    this.isAbstract = false,
    this.returnNullable = false,
    this.asynchronousMode = AsynchronousMode.none,
    this.generics,
  }) {
    metas ??= [];
    parameters ??= [];
    generics ??= [];
  }

  @override
  String code({Map<String, Object> args = const {}}) {
    var raw = '';
    var elements = [];
    if (isFactory) elements.add('factory');
    if (isStatic) elements.add('static');
    var nullableState = "";
    if (returnNullable) {
      nullableState = "?";
    }
    if (returnType != null) {
      elements.add(returnType.fullTypeName + nullableState);
    }
    elements.add(methodName);
    if (hasGeneric) elements.add("<${generics.join(", ")}>");
    raw += elements.join(' ');
    raw += '(${collectParameters(parameters)})';
    if (isAbstract) {
      raw += ';';
    } else {
      switch (asynchronousMode) {
        case AsynchronousMode.none:
          break;
        case AsynchronousMode.asyncFuture:
          raw += ' async';
          break;
        case AsynchronousMode.asyncStream:
          raw += ' async*';
          break;
        case AsynchronousMode.syncIterable:
          raw += ' sync*';
          break;
      }
      raw += ' ' + collectCodeBlock(codeBlock, withLambda: true);
    }
    raw = collectWithMeta(metas, raw);
    raw = collectWithDoc(doc, raw);
    return raw;
  }
}

String collectMethods(List<MethodSpec> methods) {
  return methods.map((o) => o.code()).join('\n\n');
}

enum AsynchronousMode {
  none,
  asyncFuture,
  asyncStream,
  syncIterable,
}
