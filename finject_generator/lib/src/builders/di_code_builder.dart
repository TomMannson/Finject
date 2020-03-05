import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dartpoet/dartpoet.dart';
import 'package:finject/finject.dart';
import 'package:finject_generator/src/builders/validation/dependency_bag.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import '../json_schema/injector_Info.dart';
import 'build_utils.dart';

class DiCodeBuilder implements Builder {
  static final _allFilesInLib = Glob('lib/**');
  static final declaratedProfiles = Glob('lib/declarated_profiles.dart');
  static const output_file = 'finject_config.dart';

  static AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      p.join('lib', output_file),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return const {
      r'$lib$': [output_file],
    };
  }

  bool notContainsOneOf(
      Set<String> injectorProfiles, List<String> activeProfiles) {
    for (final injectorProfile in injectorProfiles) {
      if (activeProfiles.contains(injectorProfile)) {
        return false;
      }
    }
    return true;
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    var allInjectors = <ClassSpec>[];
    var scopes = <String, List<InjectorDs>>{};
    var allTypes = <InjectorDs>[];

    final profiles = await processProfiles(buildStep);

    final listOfInjectorDs = <InjectorDs>[];
    await for (final input in buildStep.findAssets(_allFilesInLib)) {
      if (input.path.endsWith('summary.json')) {
        var injectorJson = await buildStep.readAsString(input);

        var readData = (jsonDecode(injectorJson) as Iterable)
            .map((value) => InjectorDs.fromJson(value as Map<String, dynamic>))
            .toList();
        listOfInjectorDs.addAll(readData);
      }
    }

    analizeGraph(listOfInjectorDs);

    for (var oneInjectable in listOfInjectorDs) {
      if (oneInjectable.profiles.isNotEmpty &&
          notContainsOneOf(oneInjectable.profiles, profiles)) {
        continue;
      }

      if (oneInjectable.scopeName != null) {
        var scopeList = scopes[oneInjectable.scopeName];
        if (scopeList == null) {
          scopeList = <InjectorDs>[];
          scopes[oneInjectable.scopeName] = scopeList;
        }

        scopeList.add(oneInjectable);
      }

      allTypes.add(oneInjectable);
      allInjectors.addAll(createClassesForSummary(oneInjectable));
    }

    allInjectors.add(createClassesForScope(scopes));

    var fileSpec = FileSpec.build(
        dependencies: [...generateImport(allTypes)],
        classes: allInjectors,
        properties: [
          PropertySpec.ofMapByToken(
            'injectorMapper',
            keyType: TypeToken.of(Qualifier),
            valueType: TypeToken.ofFullName('Injector'),
            defaultValue: {},
          ),
          PropertySpec.ofMapByToken(
            'factoryMapper',
            keyType: TypeToken.of(Qualifier),
            valueType: TypeToken.ofFullName('Factory'),
            defaultValue: {},
          ),
        ],
        methods: [
          MethodSpec.build('init', codeBlock: generateCodeForMappers(allTypes))
        ]);

    var dartFile = DartFile.fromFileSpec(fileSpec);

    final output = _allFileOutput(buildStep);
    return buildStep.writeAsString(output, dartFile.outputContent());
  }

  Future<List<String>> processProfiles(BuildStep buildStep) async {
    var profiles = <String>[];
    await for (final input in buildStep.findAssets(declaratedProfiles)) {
      var library = await buildStep.resolver.libraryFor(input);
      var profilesValue = library.topLevelElements
          .whereType<TopLevelVariableElement>()
          .where(
              (TopLevelVariableElement element) => element.name == 'profiles')
          .map((TopLevelVariableElement element) =>
              element.computeConstantValue())
          .toList();

      if (profilesValue.length == 1) {
        profiles = profilesValue[0]
            .toListValue()
            .map((dartObject) => dartObject.toStringValue())
            .toList();
      }
    }
    return profiles;
  }

  ClassSpec createClassesForScope(Map<String, List<InjectorDs>> scopes) {
    return ClassSpec.build('ScopeFactoryImpl',
        superClass: TypeToken.of(ScopeFactory),
        methods: [
          MethodSpec.build('createScope',
              returnType: TypeToken.of(Scope),
              parameters: [
                ParameterSpec.build('scopeName', type: TypeToken.ofString())
              ],
              codeBlock:
                  CodeBlockSpec.lines(generateMethodCodeForScopes(scopes)))
        ]);
  }

  void analizeGraph(List<InjectorDs> listOfInjectorDs) {
    final bag = DependencyBag();
    for (final injector in listOfInjectorDs) {
      bag.addType(injector);
    }

    bag.process();
    bag.toString();
  }
}

List<String> generateMethodCodeForScopes(Map<String, List<InjectorDs>> scopes) {
  var linesOfCode = <String>[];

  for (var scope in scopes.keys) {
    linesOfCode.add("if (scopeName == '$scope') {");
    linesOfCode.add('return Scope([');
    for (var injectable in scopes[scope]) {
      linesOfCode.add(
          'ScopeEntry<Injector>(const ${generateKeyForInjector(injectable)}, ${generatePrefixClassName(injectable)}_Injector()),');
      linesOfCode.add(
          'ScopeEntry<Factory>(const ${generateKeyForInjector(injectable)}, ${generatePrefixClassName(injectable)}_Factory()),');
    }
    linesOfCode.add(']);');
    linesOfCode.add('}');
  }

  linesOfCode.add('//default value');
  linesOfCode.add('return null;');
  return linesOfCode;
}

Iterable<ClassSpec> createClassesForSummary(InjectorDs readData) sync* {
  yield ClassSpec.build(
    generatePrefixClassName(readData) + '_Injector',
    superClass: TypeToken.ofFullName(
      'Injector<${generateTypeFromTypeInfo(readData.typeName)}>',
    ),
    doc: DocSpec.text(
        'this is injector for ' + readData.typeName.className + ' class'),
    properties: createPropertyInjectorForScopedSingleton(readData).toList(),
    methods: [
      MethodSpec.build(
        'inject',
        parameters: [
          ParameterSpec.build(
            'instance',
            type: TypeToken.ofName2(
              generateTypeFromTypeInfo(readData.typeName),
            ),
          ),
          ParameterSpec.normal('injectionProvider',
              type: TypeToken.ofFullName('InjectionProvider')),
        ],
        returnType: TypeToken.ofVoid(),
        codeBlock: generateCodeForInjector(readData),
      ),
    ],
  );
  yield ClassSpec.build(
    generatePrefixClassName(readData) + '_Factory',
//          metas: [MetaSpec.of('Object()')],
    doc: DocSpec.text('this is factory for ' +
        generateTypeFromTypeInfo(readData.typeName) +
        ' class'),
    superClass: TypeToken.ofFullName(
        'Factory<${generateTypeFromTypeInfo(readData.typeName)}>'),
    properties: createPropertyFactoryForScopedSingleton(readData).toList(),
    methods: [
      MethodSpec.build(
        'create',
        returnType:
            TypeToken.ofName2(generateTypeFromTypeInfo(readData.typeName)),
        parameters: [
          ParameterSpec.normal('injectionProvider',
              type: TypeToken.ofFullName('InjectionProvider')),
        ],
        codeBlock: generateCodeForFactory(readData),
      ),
    ],
  );
}

Iterable<PropertySpec> createPropertyFactoryForScopedSingleton(
    InjectorDs data) sync* {
  if (data.singleton) {
    yield PropertySpec.of('cache',
        type: TypeToken.ofName2(generateTypeFromTypeInfo(data.typeName)));
  }
}

Iterable<PropertySpec> createPropertyInjectorForScopedSingleton(
    InjectorDs data) sync* {
  if (data.singleton) {
    yield PropertySpec.of('cache',
        type: TypeToken.ofBool(), defaultValue: false);
  }
}
