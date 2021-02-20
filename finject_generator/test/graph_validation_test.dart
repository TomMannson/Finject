import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:finject_generator/src/builders/di_code_builder.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('invalid graph ', () {
    test('cycles in graph', () {
      expect(generate(graphValidation),
          throwsA(TypeMatcher<InvalidGenerationSourceError>()));
    });
    test('dependency not found', () {
      expect(generate(graphInvalidNoDependency),
          throwsA(TypeMatcher<InvalidGenerationSourceError>()));
    });
    test('dependency duplicate', () {
      expect(generate(graphInvalidDependencyDuplicate),
          throwsA(TypeMatcher<InvalidGenerationSourceError>()));
    });
    test('dependency with conflicted scopes', () {
      expect(generate(graphInvalidWithConflictedScope),
          throwsA(TypeMatcher<InvalidGenerationSourceError>()));
    });
  });
}

final Builder builder = DiCodeBuilder();
final String pkgName = 'finject_generator';

Future<String> generate(String source) async {
  String errorText;
  var srcs = <String, String>{
    '$pkgName|lib/test.summary.json': source,
    '$pkgName|lib/declarated_profiles.dart': 'const profiles = ["dev"];',
  };

  void captureErrorLog(LogRecord logRecord) {
    if (logRecord.error is InvalidGenerationSourceError) {
      errorText = logRecord.error.toString();
    }
  }

  var writer = InMemoryAssetWriter();
  await testBuilder(
    builder,
    srcs,
    rootPackage: pkgName,
    writer: writer,
    onLog: captureErrorLog,
    reader: await PackageAssetReader.currentIsolate(
      rootPackage: pkgName,
    ),
  );
  if (errorText != null) {
    return errorText;
  } else if (writer.assets[AssetId(pkgName, 'lib/finject_config.dart')] !=
      null) {
    return String.fromCharCodes(
        writer.assets[AssetId(pkgName, 'lib/finject_config.dart')] ?? []);
  } else {
    return null;
  }
}

String graphValidation = r'''
[
{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Config","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]},
{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Config","libraryId":"id1"},"constructorInjection":{"name":"name","orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[{"name" : "test", "orderedParameters": [{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}], "orderedNames": [null], "namedParameters" : {}, "namedNames": {}, "blackList": []}],"dependencies":[]},
{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"}],"namedParameters":{},"blackList":[],"orderedNames":[null],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"}]}]
''';

String graphInvalidNoDependency = r'''
[
{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"}],"namedParameters":{},"blackList":[],"orderedNames":[null],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"}]}
]
''';

String graphInvalidDependencyDuplicate = r'''
[
{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"}],"namedParameters":{},"blackList":[],"orderedNames":[null],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"}]},
{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"}],"namedParameters":{},"blackList":[],"orderedNames":[null],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"}]}
]
''';

String graphInvalidWithConflictedScope = r'''
[
{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":"Scope1","name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test3","libraryId":"id1"}],"namedParameters":{},"blackList":[],"orderedNames":[null],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test3","libraryId":"id1"}]},
{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test3","libraryId":"id1"},"singleton":false,"scopeName":"Scope2","name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]}
]
''';
