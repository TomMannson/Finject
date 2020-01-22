import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:finject_generator/src/builders/di_code_builder.dart';
import 'package:finject_generator/src/builders/summary_builder.dart';
import 'package:finject_generator/src/builders/summary_generation/summary_generator_impl.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('generate ', () {
    test('valid Injectable', () async {
      try {
        await generate(basicInjectable);
      }on Exception {

      }
//      expect(await ,
//          '''''');
    });
  });
}

final Builder builder = DiCodeBuilder();
final String pkgName = 'pkg';

Future<String> generate(String source) async {
  String errorText;
  var srcs = <String, String>{
    '$pkgName|lib/test.summary.json': source,
  };

  void captureErrorLog(LogRecord logRecord) {
    if (logRecord.error is InvalidGenerationSourceError) {
      if (errorText != null) throw StateError('Expected max one error');
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
      rootPackage: 'finject',
    ),
  );
  if (errorText != null) {
    return errorText;
  } else if (writer.assets[AssetId(pkgName, 'lib/finject_config.dart')] != null) {
    return String.fromCharCodes(
        writer.assets[AssetId(pkgName, 'lib/finject_config.dart')] ?? []);
  } else {
    return null;
  }
}

String basicInjectable = r'''
[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}],"namedParameters":{"value2":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"blackList":["value","value2"],"orderedNames":[null],"namedNames":{"value2":null}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]}]
''';