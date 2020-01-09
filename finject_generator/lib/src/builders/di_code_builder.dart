import 'dart:convert';
import 'dart:async';

import 'package:build/build.dart';
import 'package:dartpoet/dartpoet.dart';
import 'package:finject/finject.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import '../json_schema/injector_Info.dart';
import 'build_utils.dart';

class DiCodeBuilder implements Builder {
  static final _allFilesInLib = new Glob('lib/**');
  static const output_file = 'finject_config.dart';

  static AssetId _allFileOutput(BuildStep buildStep) {
    return new AssetId(
      buildStep.inputId.package,
      p.join('lib', output_file),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return const {
      r'$lib$': const [output_file],
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    List<ClassSpec> allInjectors = [];
    Map<String, List<InjectorDs>> scopes = {};
    List<InjectorDs> allTypes = [];
    await for (final input in buildStep.findAssets(_allFilesInLib)) {
      if (input.path.endsWith("summary.json")) {
        String injectorJson = await buildStep.readAsString(input);

        List<InjectorDs> readData = (jsonDecode(injectorJson) as Iterable)
            .map((value) => InjectorDs.fromJson(value))
            .toList();

        for (InjectorDs oneInjectable in readData) {
          if (oneInjectable.scopeName != null) {
            List<InjectorDs> scopeList = scopes[oneInjectable.scopeName];
            if (scopeList == null) {
              scopeList = List<InjectorDs>();
              scopes[oneInjectable.scopeName] = scopeList;
            }

            scopeList.add(oneInjectable);
          }

          allTypes.add(oneInjectable);
          allInjectors.addAll(createClassesForSummary(oneInjectable));
        }
      }
    }

    allInjectors.add(createClassesForScope(scopes));

    FileSpec fileSpec = FileSpec.build(
        dependencies: [...generateImport(allTypes)],
        classes: allInjectors,
        properties: [
          PropertySpec.ofMapByToken(
            "injectorMapper",
            keyType: TypeToken.of(Qualifier),
            valueType: TypeToken.ofFullName("Injector"),
            defaultValue: {},
          ),
          PropertySpec.ofMapByToken(
            "factoryMapper",
            keyType: TypeToken.of(Qualifier),
            valueType: TypeToken.ofFullName("Factory"),
            defaultValue: {},
          ),
        ],
        methods: [
          MethodSpec.build("init", codeBlock: generateCodeForMappers(allTypes))
        ]);

    DartFile dartFile = DartFile.fromFileSpec(fileSpec);

    final output = _allFileOutput(buildStep);
    return buildStep.writeAsString(output, dartFile.outputContent());
  }

  ClassSpec createClassesForScope(Map<String, List<InjectorDs>> scopes) {
    return ClassSpec.build("ScopeFactoryImpl",
        superClass: TypeToken.of(ScopeFactory),
        methods: [
          MethodSpec.build("createScope",
              returnType: TypeToken.of(Scope),
              parameters: [
                ParameterSpec.build("scopeName", type: TypeToken.ofString())
              ],
              codeBlock:
                  CodeBlockSpec.lines(generateMethodCodeForScopes(scopes)))
        ]);
  }
}

List<String> generateMethodCodeForScopes(Map<String, List<InjectorDs>> scopes) {
  List<String> linesOfCode = [];

  for (String scope in scopes.keys) {
    linesOfCode.add("if (scopeName == '$scope') {");
    linesOfCode.add("return Scope([");
    for (InjectorDs injectable in scopes[scope]) {
      linesOfCode.add(
          "ScopeEntry<Injector>(const ${generateKeyForInjector(injectable)}, ${generatePrefixClassName(injectable)}_Injector()),");
      linesOfCode.add(
          "ScopeEntry<Factory>(const ${generateKeyForInjector(injectable)}, ${generatePrefixClassName(injectable)}_Factory()),");
    }
    linesOfCode.add("]);");
    linesOfCode.add("}");
  }

  linesOfCode.add("//default value");
  linesOfCode.add("return null;");
  return linesOfCode;
}

Iterable<ClassSpec> createClassesForSummary(InjectorDs readData) sync* {
  yield ClassSpec.build(
    generatePrefixClassName(readData) + "_Injector",
    superClass: TypeToken.ofFullName(
      "Injector<${generateTypeFromTypeInfo(readData.typeName)}>",
    ),
    doc: DocSpec.text(
        'this is injector for ' + readData.typeName.className + ' class'),
    properties: createPropertyInjectorForScopedSingleton(readData).toList(),
    methods: [
      MethodSpec.build(
        'inject',
        parameters: [
          ParameterSpec.build(
            "instance",
            type: TypeToken.ofName2(
              generateTypeFromTypeInfo(readData.typeName),
            ),
          ),
          ParameterSpec.normal("injectionProvider",
              type: TypeToken.ofFullName("InjectionProvider")),
        ],
        returnType: TypeToken.ofVoid(),
        codeBlock: generateCodeForInjector(readData),
      ),
    ],
  );
  yield ClassSpec.build(
    generatePrefixClassName(readData) + "_Factory",
//          metas: [MetaSpec.of('Object()')],
    doc: DocSpec.text('this is factory for ' +
        generateTypeFromTypeInfo(readData.typeName) +
        ' class'),
    superClass: TypeToken.ofFullName(
        "Factory<${generateTypeFromTypeInfo(readData.typeName)}>"),
    properties: createPropertyFactoryForScopedSingleton(readData).toList(),
    methods: [
      MethodSpec.build(
        'create',
        returnType:
            TypeToken.ofName2(generateTypeFromTypeInfo(readData.typeName)),
        parameters: [
          ParameterSpec.normal("injectionProvider",
              type: TypeToken.ofFullName("InjectionProvider")),
        ],
        codeBlock: generateCodeForFactory(readData),
      ),
    ],
  );
}

Iterable<PropertySpec> createPropertyFactoryForScopedSingleton(
    InjectorDs data) sync* {
  if (data.singleton) {
    yield PropertySpec.of("cache",
        type: TypeToken.ofName2(generateTypeFromTypeInfo(data.typeName)));
  }
}

Iterable<PropertySpec> createPropertyInjectorForScopedSingleton(
    InjectorDs data) sync* {
  if (data.singleton) {
    yield PropertySpec.of("cache",
        type: TypeToken.ofBool(), defaultValue: false);
  }
}
