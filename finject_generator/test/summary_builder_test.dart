import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:finject_generator/src/builders/summary_builder.dart';
import 'package:finject_generator/src/builders/summary_generation/summary_generator_impl.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('generate ', () {
    test('valid Injectable', () async {
      expect(await generate(basicInjectable),
          '''[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{"value":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"namedNames":{"value":"value_one"}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]}]''');
    });
    test('valid Injectable with no costructor', () async {
      expect(await generate(basicInjectableWithNoConstructor),
          '''[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]}]''');
    });
    test('valid Injectable with constructor', () async {
      expect(await generate(basicConstructorInjectable),
          '''[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}],"namedParameters":{"value2":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"blackList":["value","value2"],"orderedNames":[null],"namedNames":{"value2":null}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]}]''');
    });
    test('valid Injectable with named constructor', () async {
      expect(await generate(namedConstructorInjectable),
          '''[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}],"namedParameters":{"value2":{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}},"blackList":["value","value2"],"orderedNames":[null],"namedNames":{"value2":null}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}]}]''');
    });
    test('valid Configuration', () async {
      expect(await generate(basicConfiguration),
          '''[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"TestConfig","libraryId":"id1"},"singleton":true,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]},{"typeName":{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"},"singleton":true,"scopeName":"test","name":"value_one","profiles":[],"factoryTypeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"TestConfig","libraryId":"id1"},"constructorInjection":null,"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[{"name":"value","orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}}],"dependencies":[]}]''');
    });
    test('valid Configuration with optional formal setter', () async {
      expect(await generate(basicConfigurationWithOptional),
          '''[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"TestConfig","libraryId":"id1"},"singleton":true,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]},{"typeName":{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"TestConfig","libraryId":"id1"},"constructorInjection":null,"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[{"name":"value","orderedParameters":[{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}],"namedParameters":{},"blackList":[],"orderedNames":[null],"namedNames":{}}],"dependencies":[]}]''');
    });
    test('valid Configuration with profile and parameters', () async {
      expect(await generate(configurationWithProfile),
          '''[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"TestConfig","libraryId":"id1"},"singleton":true,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]},{"typeName":{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"},"singleton":false,"scopeName":null,"name":null,"profiles":["test"],"factoryTypeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"TestConfig","libraryId":"id1"},"constructorInjection":null,"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[{"name":"value","orderedParameters":[{"packageName":"dart","libraryName":"core","className":"int","libraryId":"id2"}],"namedParameters":{"value2":{"packageName":"dart","libraryName":"async","className":"Future","libraryId":"id3"}},"blackList":[],"orderedNames":[null],"namedNames":{"value2":null}}],"dependencies":[{"packageName":"dart","libraryName":"core","className":"int","libraryId":"id2"},{"packageName":"dart","libraryName":"async","className":"Future","libraryId":"id3"}]}]''');
    });
    test('valid Injectable with superClass', () async {
      expect(await generate(basicInjectableWithSuperClass),
          '''[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{"value":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"superValue":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"namedNames":{"value":"value_one","superValue":"value_one"}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"SuperTest","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{"superValue":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"namedNames":{"superValue":"value_one"}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]}]''');
    });
    test('valid Injectable with setter', () async {
      expect(await generate(injectableWithSetter),
          '''[{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"TestConfig","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{"value=":{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}},"namedNames":{"value=":null}},"methodInjections":[],"dependencies":[{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}]}]''');
    });
    test('no file if no injectable', () async {
      expect(await generate(noInjectableNorConfiguration), null);
    });
  });
  group('error when', (){
    test('invalid Injectable private class', () async {
      expect(await generate(privateClass),
          '''Class which is @Injectable can't be  private''');
    });
    test('invalid Injectable with no injection at any constructor', () async {
      expect(await generate(noAnnotatedConstructor),
          '''No constructor found with annotation @Inject''');
    });
    test('invalid Injectable with 2 injections', () async {
      expect(await generate(moreThenOneConstructorAnnotated),
          '''Class should have exacly one constructor with inject annotation''');
    });
    test('invalid Injectable when no Type information', () async {
      expect(await generate(noTypeInformationForInjection),
          '''Unknown type found, no import or something. Find compilation error''');
    });
  });
}

final Builder builder = BuildSummary([SummaryGeneratorImpl()]);
final String pkgName = 'pkg';

Future<String> generate(String source) async {
  String errorText;
  var srcs = <String, String>{
    '$pkgName|lib/test.dart': source,
  };

  void captureErrorLog(LogRecord logRecord) {
    if (logRecord.error is InvalidGenerationSourceError) {
//      if (errorText != null) throw StateError('Expected max one error');
//      errorText = logRecord.error.toString();
    }
  }

  var writer = InMemoryAssetWriter();
  try {
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
  }on InvalidGenerationSourceError catch(e){
    errorText = e.message;
  }
  if (errorText != null) {
    return errorText;
  } else if (writer.assets[AssetId(pkgName, 'lib/test.summary.json')] != null) {
    return String.fromCharCodes(
        writer.assets[AssetId(pkgName, 'lib/test.summary.json')] ?? []);
  } else {
    return null;
  }
}

String basicInjectable = r'''
import 'package:finject/finject.dart';

@Injectable()
class Test {

  @Singleton()
  @Scoped("test")
  @Named("value_one")
  @Inject()
  Test2 value;

}

@Injectable()
class Test2 {

}
''';

String basicConstructorInjectable = r'''
import 'package:finject/finject.dart';

@Injectable()
class Test {

  final Test2 value;
  final Test2 value2;

  @Inject()
  Test(this.value, {this.value2});

}

@Injectable()
class Test2 {

}
''';

String basicInjectableWithNoConstructor = r'''
import 'package:finject/finject.dart';

@Injectable()
class Test {

}
''';

String namedConstructorInjectable = r'''
import 'package:finject/finject.dart';

@Injectable()
class Test {

  final String value;
  final String value2;

  @Inject()
  Test.name(this.value, {this.value2});

}
''';

String configurationWithProfile = r'''
import 'package:finject/finject.dart';

@Configuration()
class TestConfig {

  @Profile(['test'])
  String value(@Named('test') int value, {Future value2}){
    return '';
  }

}
''';

String basicInjectableWithSuperClass = r'''
import 'package:finject/finject.dart';

@Injectable()
class Test extends SuperTest {

  @Singleton()
  @Scoped("test")
  @Named("value_one")
  @Inject()
  Test2 value;

}

@Injectable()
class SuperTest {
  @Singleton()
  @Scoped("test")
  @Named("value_one")
  @Inject()
  Test2 superValue;
}

@Injectable()
class Test2 {

}
''';

String basicConfiguration = r'''
import 'package:finject/finject.dart';

@Configuration()
class TestConfig {

  @Singleton()
  @Scoped("test")
  @Named("value_one")
  String value(){
    return "";
  }

}
''';

String basicConfigurationWithOptional = r'''
import 'package:finject/finject.dart';

@Configuration()
class TestConfig {

  String value([String param]){
    return "";
  }

}
''';

String injectableWithSetter = r'''
import 'package:finject/finject.dart';

@Injectable()
class TestConfig {

  String _value;

  @Inject()
  set value(String value){
    _value = value;
  }

}
''';



String noInjectableNorConfiguration = r'''
import 'package:finject/finject.dart';

class TestConfig {

  String value(){
    return "";
  }

}
''';

String privateClass = r'''
import 'package:finject/finject.dart';

@Injectable()
class _Test2 {

}
''';

String noAnnotatedConstructor = r'''
import 'package:finject/finject.dart';

@Injectable()
class Test2 {

  Test2(String value){
  
  }
  
  Test2(Test2 value){
  
  }

}
''';

String moreThenOneConstructorAnnotated = r'''
import 'package:finject/finject.dart';

@Injectable()
class Test2 {

  @Inject()
  Test2(String value){
  
  }
  
  @Inject()
  Test2.named(String value){
  
  }

}
''';

String noTypeInformationForInjection = r'''
import 'package:finject/finject.dart';

@Injectable()
class Test2 {
  
  @Inject()
  Test2.named(UnknownType value){
  
  }

}
''';