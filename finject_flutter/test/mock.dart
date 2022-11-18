import 'package:finject/finject.dart';

import 'main_test.dart';

Map<Qualifier, Injector> injectorMapper = {};
Map<Qualifier, Factory> factoryMapper = {};

class Test {}

class ScopeFactoryImpl extends ScopeFactory {
  @override
  Scope createScope(String scopeName) {
//default value
    return null;
  }
}

/// this is factory for id4.TestClass class
class Test_Factory extends Factory<Test> {
  @override
  Test create(InjectionProvider injectionProvider) {
    return Test();
  }
}

/// this is injector for TestClass class
class Test_Injector extends Injector<Test> {
  @override
  void inject(Test instance, InjectionProvider injectionProvider) {}
}

class InjectableWidget_Injector extends Injector<InjectableWidget> {
  @override
  void inject(InjectableWidget instance, InjectionProvider injectionProvider) {
    instance.value = injectionProvider.get();
  }
}

void init() {
  defaultScopeFactory = ScopeFactoryImpl();
  injectorMapper.clear();
  factoryMapper.clear();
  injectorMapper[TypeQualifier(Test)] = Test_Injector();
  factoryMapper[TypeQualifier(Test)] = Test_Factory();
  injectorMapper[TypeQualifier(InjectableWidget)] = InjectableWidget_Injector();
  rootDependencyResolver = {
    'injector': injectorMapper,
    'factory': factoryMapper
  };
}
