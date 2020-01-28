import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:finject_generator/src/builders/di_code_builder.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('generate ', () {
    test('valid Injectable', () async {
//      expect(
      await generate(basicInjectable);
//        '''''',
//      );
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

String basicInjectable = r'''
[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"},"singleton":false,"scopeName":"test","name":"name","profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[ 
            { 
               "packageName":"package",
               "libraryName":"pkg/test.dart",
               "className":"Test2",
               "libraryId":"id1"
            }
         ],
         "namedParameters":{ 
            "value2":{ 
               "packageName":"package",
               "libraryName":"pkg/test.dart",
               "className":"Test2",
               "libraryId":"id1"
            }
         },"blackList":[]
         ,"orderedNames":[ 
            null
         ],
         "namedNames":{ 
            "value2":null
         }},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{"value":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"superValue":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"namedNames":{"value":"value_one","superValue":"value_one"}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"SuperTest","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{"superValue":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"namedNames":{"superValue":"value_one"}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Config","libraryId":"id1"},"singleton":true,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]},{"typeName":{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Config","libraryId":"id1"},"constructorInjection":null,"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[{"name":"value","orderedParameters":[{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}],"namedParameters":{"value2":{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}},"blackList":[],"orderedNames":[null],"namedNames":{"value2":null}}],"dependencies":[]},
         {"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test3","libraryId":"id1"},"singleton":false,"scopeName":"test","name":null,"profiles":["dev"],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[ 
            { 
               "packageName":"package",
               "libraryName":"pkg/test.dart",
               "className":"Test2",
               "libraryId":"id1"
            }
         ],
         "namedParameters":{ 
            "value2":{ 
               "packageName":"package",
               "libraryName":"pkg/test.dart",
               "className":"Test2",
               "libraryId":"id1"
            }
         },"blackList":[]
         ,"orderedNames":[ 
            null
         ],
         "namedNames":{ 
            "value2":null
         }},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{"value":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"superValue":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"namedNames":{"value":"value_one","superValue":"value_one"}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]}]
''';
