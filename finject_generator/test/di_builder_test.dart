import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:finject_generator/src/builders/di_code_builder.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('generate ', () {
    test('valid Injectable', () async {
      expect(await generate(basicInjectable), basicInjectableResult);
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
[{
    "typeName":{
      "packageName":"package",
      "libraryName":"pkg/test.dart",
      "className":"Test2",
      "libraryId":"id1"
    },
    "singleton":false,
    "scopeName":null,
    "name":"value_one",
    "profiles":[

    ],
    "factoryTypeName":null,
    "constructorInjection":{
      "name":null,
      "orderedParameters":[

      ],
      "namedParameters":{

      },
      "blackList":[

      ],
      "orderedNames":[

      ],
      "namedNames":{

      }
    },
    "setterInjection":{
      "namedParameter":{

      }
    },
    "fieldInjection":{
      "namedParameter":{

      },
      "namedNames":{

      }
    },
    "methodInjections":[

    ],
    "dependencies":[

    ]
  },
{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test","libraryId":"id1"},"singleton":false,"scopeName":"test","name":"name","profiles":[],"factoryTypeName":null,"constructorInjection":{"name":"name","orderedParameters":[ 
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
         }},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{"value":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"superValue":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"namedNames":{"value":"value_one","superValue":"value_one"}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"SuperTest","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{"superValue":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}},"namedNames":{"superValue":"value_one"}},"methodInjections":[],"dependencies":[{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"}]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Test2","libraryId":"id1"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]},{"typeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Config","libraryId":"id1"},"singleton":true,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":null,"constructorInjection":{"name":null,"orderedParameters":[],"namedParameters":{},"blackList":[],"orderedNames":[],"namedNames":{}},"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[],"dependencies":[]},{"typeName":{"packageName":"dart","libraryName":"core","className":"String2","libraryId":"id2"},"singleton":false,"scopeName":null,"name":null,"profiles":[],"factoryTypeName":{"packageName":"package","libraryName":"pkg/test.dart","className":"Config","libraryId":"id1"},"constructorInjection":null,"setterInjection":{"namedParameter":{}},"fieldInjection":{"namedParameter":{},"namedNames":{}},"methodInjections":[{"name":"value","orderedParameters":[{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}],"namedParameters":{"value2":{"packageName":"dart","libraryName":"core","className":"String","libraryId":"id2"}},"blackList":[],"orderedNames":[null],"namedNames":{"value2":null}}],"dependencies":[]},
         {
  "typeName":{
    "packageName":"dart",
    "libraryName":"core",
    "className":"String",
    "libraryId":"id2"
  },
  "singleton":false,
  "scopeName":null,
  "name":null,
  "profiles":[

  ],
  "factoryTypeName":{
    "packageName":"package",
    "libraryName":"pkg/test.dart",
    "className":"Config",
    "libraryId":"id1"
  },
  "constructorInjection":null,
  "setterInjection":{
    "namedParameter":{

    }
  },
  "fieldInjection":{
    "namedParameter":{

    },
    "namedNames":{

    }
  },
  "methodInjections":[
    {
      "name":"value",
      "orderedParameters":[
        
      ],
      "namedParameters":{
       
      },
      "blackList":[

      ],
      "orderedNames":[
       
      ],
      "namedNames":{
      
      }
    }
  ],
  "dependencies":[

  ]
},
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

final basicInjectableResult = r'''
import 'package:finject/finject.dart';
import 'package:pkg/test.dart' as id1;
import 'package:pkg/test.dart' as id1;
import 'package:pkg/test.dart' as id1;
import 'package:pkg/test.dart' as id1;
import 'package:pkg/test.dart' as id1;
import 'dart:core';
import 'dart:core';
import 'package:pkg/test.dart' as id1;

Map<Qualifier, Injector> injectorMapper = {};
Map<Qualifier, Factory> factoryMapper = {};

class ScopeFactoryImpl extends ScopeFactory {
  Scope createScope(String scopeName) {
    if (scopeName == 'test') {
      return Scope([
        ScopeEntry<Injector>(const NamedQualifier(id1.Test, "name"),
            Test_id1NAME$nameSCOPE$test_Injector()),
        ScopeEntry<Factory>(const NamedQualifier(id1.Test, "name"),
            Test_id1NAME$nameSCOPE$test_Factory()),
        ScopeEntry<Injector>(
            const TypeQualifier(id1.Test3), Test3_id1SCOPE$test_Injector()),
        ScopeEntry<Factory>(
            const TypeQualifier(id1.Test3), Test3_id1SCOPE$test_Factory()),
      ]);
    }
//default value
    return null;
  }
}

/// this is factory for id1.Test3 class
class Test3_id1SCOPE$test_Factory extends Factory<id1.Test3> {
  id1.Test3 create(InjectionProvider injectionProvider) {
    var value = id1.Test3(
      injectionProvider.get(),
      value2: injectionProvider.get(),
    );
    return value;
  }
}

/// this is injector for Test3 class
class Test3_id1SCOPE$test_Injector extends Injector<id1.Test3> {
  void inject(id1.Test3 instance, InjectionProvider injectionProvider) {
    instance.value = injectionProvider.get("value_one");
    instance.superValue = injectionProvider.get("value_one");
  }
}

/// this is factory for String class
class String_id2_Factory extends Factory<String> {
  String create(InjectionProvider injectionProvider) {
    id1.Config factory = injectionProvider.get();
    var value = factory.value();
    return value;
  }
}

/// this is injector for String class
class String_id2_Injector extends Injector<String> {
  void inject(String instance, InjectionProvider injectionProvider) {
//no injection
//no injection
  }
}

/// this is factory for String2 class
class String2_id2_Factory extends Factory<String2> {
  String2 create(InjectionProvider injectionProvider) {
    id1.Config factory = injectionProvider.get();
    var value = factory.value(
      injectionProvider.get(),
      value2: injectionProvider.get(),
    );
    return value;
  }
}

/// this is injector for String2 class
class String2_id2_Injector extends Injector<String2> {
  void inject(String2 instance, InjectionProvider injectionProvider) {
//no injection
//no injection
  }
}

/// this is factory for id1.Config class
class Config_id1_Factory extends Factory<id1.Config> {
  id1.Config cache;

  id1.Config create(InjectionProvider injectionProvider) {
    if (cache != null) {
      return cache;
    }
    var value = id1.Config();
    cache = value;
    return value;
  }
}

/// this is injector for Config class
class Config_id1_Injector extends Injector<id1.Config> {
  bool cache = false;

  void inject(id1.Config instance, InjectionProvider injectionProvider) {
    if (cache) {
      return;
    }
    cache = true;
  }
}

/// this is factory for id1.Test2 class
class Test2_id1_Factory extends Factory<id1.Test2> {
  id1.Test2 create(InjectionProvider injectionProvider) {
    var value = id1.Test2();
    return value;
  }
}

/// this is injector for Test2 class
class Test2_id1_Injector extends Injector<id1.Test2> {
  void inject(id1.Test2 instance, InjectionProvider injectionProvider) {
//no injection
//no injection
  }
}

/// this is factory for id1.SuperTest class
class SuperTest_id1_Factory extends Factory<id1.SuperTest> {
  id1.SuperTest create(InjectionProvider injectionProvider) {
    var value = id1.SuperTest();
    return value;
  }
}

/// this is injector for SuperTest class
class SuperTest_id1_Injector extends Injector<id1.SuperTest> {
  void inject(id1.SuperTest instance, InjectionProvider injectionProvider) =>
      instance.superValue = injectionProvider.get("value_one");
}

/// this is factory for id1.Test class
class Test_id1NAME$nameSCOPE$test_Factory extends Factory<id1.Test> {
  id1.Test create(InjectionProvider injectionProvider) {
    var value = id1.Test.name(
      injectionProvider.get(),
      value2: injectionProvider.get(),
    );
    return value;
  }
}

/// this is injector for Test class
class Test_id1NAME$nameSCOPE$test_Injector extends Injector<id1.Test> {
  void inject(id1.Test instance, InjectionProvider injectionProvider) {
    instance.value = injectionProvider.get("value_one");
    instance.superValue = injectionProvider.get("value_one");
  }
}

/// this is factory for id1.Test2 class
class Test2_id1NAME$value_one_Factory extends Factory<id1.Test2> {
  id1.Test2 create(InjectionProvider injectionProvider) {
    var value = id1.Test2();
    return value;
  }
}

/// this is injector for Test2 class
class Test2_id1NAME$value_one_Injector extends Injector<id1.Test2> {
  void inject(id1.Test2 instance, InjectionProvider injectionProvider) {
//no injection
//no injection
  }
}

init() {
  defaultScopeFactory = ScopeFactoryImpl();
  injectorMapper.clear();
  factoryMapper.clear();
  injectorMapper[NamedQualifier(id1.Test2, "value_one")] =
      Test2_id1NAME$value_one_Injector();
  factoryMapper[NamedQualifier(id1.Test2, "value_one")] =
      Test2_id1NAME$value_one_Factory();
  injectorMapper[TypeQualifier(id1.SuperTest)] = SuperTest_id1_Injector();
  factoryMapper[TypeQualifier(id1.SuperTest)] = SuperTest_id1_Factory();
  injectorMapper[TypeQualifier(id1.Test2)] = Test2_id1_Injector();
  factoryMapper[TypeQualifier(id1.Test2)] = Test2_id1_Factory();
  injectorMapper[TypeQualifier(id1.Config)] = Config_id1_Injector();
  factoryMapper[TypeQualifier(id1.Config)] = Config_id1_Factory();
  injectorMapper[TypeQualifier(String2)] = String2_id2_Injector();
  factoryMapper[TypeQualifier(String2)] = String2_id2_Factory();
  injectorMapper[TypeQualifier(String)] = String_id2_Injector();
  factoryMapper[TypeQualifier(String)] = String_id2_Factory();
  rootDependencyResolver = {
    "injector": injectorMapper,
    "factory": factoryMapper
  };
}
''';
