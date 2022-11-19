import '../dartpoet.dart';

class FileSpec implements Spec {
  List<DependencySpec> dependencies = [];
  List<ClassSpec> classes = [];
  List<PropertySpec> properties = [];
  List<GetterSpec> getters = [];
  List<SetterSpec> setters = [];
  List<CodeBlockSpec> codeBlocks = [];
  List<MethodSpec> methods = [];

  FileSpec.build({
    this.methods,
    this.classes,
    this.properties,
    this.getters,
    this.setters,
    this.codeBlocks,
    this.dependencies,
  }) {
    methods ??= [];
    classes ??= [];
    properties ??= [];
    getters ??= [];
    setters ??= [];
    codeBlocks ??= [];
    dependencies ??= [];
  }

  @override
  String code({Map<String, Object> args = const {}}) {
    var reverseClasses = args[KEY_REVERSE_CLASSES] as bool ?? false;
    if (reverseClasses) classes = classes.reversed.toList();
    var inner = StringBuffer();
    var dependenciesBlock = collectDependencies(dependencies);
    var classesBlock = collectClasses(classes);
    var propertiesBlock = collectProperties(properties);
    var gettersBlock = collectGetters(getters);
    var settersBlock = collectSetters(setters);
    var codeBlocksBlock = collectCodeBlocks(codeBlocks);
    var methodsBlock = collectMethods(methods);
    if (dependenciesBlock.isNotEmpty) {
      inner
        ..writeln()
        ..writeln(dependenciesBlock);
    }
    if (propertiesBlock.isNotEmpty) {
      inner
        ..writeln()
        ..writeln(propertiesBlock);
    }
    if (gettersBlock.isNotEmpty) {
      inner
        ..writeln()
        ..writeln(gettersBlock);
    }
    if (settersBlock.isNotEmpty) {
      inner
        ..writeln()
        ..writeln(settersBlock);
    }
    if (codeBlocksBlock.isNotEmpty) {
      inner
        ..writeln()
        ..writeln(codeBlocksBlock);
    }
    if (classesBlock.isNotEmpty) {
      inner
        ..writeln()
        ..writeln(classesBlock);
    }
    if (methodsBlock.isNotEmpty) {
      inner
        ..writeln()
        ..writeln(methodsBlock);
    }
    return inner.toString();
  }
}

class DependencySpec implements Spec {
  String route;
  DependencyMode mode;

  DependencySpec.build(
    this.mode,
    this.route,
  );

  DependencySpec.import(String route)
      : this.build(DependencyMode.import, route);

  DependencySpec.export(String route)
      : this.build(DependencyMode.export, route);

  DependencySpec.part(String route) : this.build(DependencyMode.part, route);

  DependencySpec.partOf(String route)
      : this.build(DependencyMode.partOf, route);

  @override
  String code({Map<String, Object> args = const {}}) {
    var raw = '';
    switch (mode) {
      case DependencyMode.import:
        raw += "import '$route';";
        break;
      case DependencyMode.export:
        raw += "export '$route';";
        break;
      case DependencyMode.part:
        raw += "part '$route';";
        break;
      case DependencyMode.partOf:
        raw += "part of '$route";
        break;
    }
    return raw;
  }
}

enum DependencyMode { import, export, part, partOf }

String collectDependencies(List<DependencySpec> dependencies) {
  dependencies.sort((o1, o2) => o1.mode.index - o2.mode.index);
  return dependencies.map((o) => o.code()).join('\n');
}
