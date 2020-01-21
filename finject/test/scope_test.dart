import 'package:finject/finject.dart';
import 'package:test/test.dart';

void main() {
  group('when scope is creating', () {
    var testInjector = TestClass_Injector();
    var testScopedInjector = TestClass_withScope_id1_Injector();
    var testFactory = TestClass_Factory();

    var scopeToTest = Scope([
      ScopeEntry<Injector>(const TypeQualifier(TestClass), testInjector),
      ScopeEntry<Factory>(const TypeQualifier(TestClass), testFactory),
      ScopeEntry<Injector>(
          const NamedQualifier(TestClass, 'two'), testScopedInjector),
    ]);

    test('map should return valid injector', () {
      expect(
          scopeToTest.injector(const TypeQualifier(TestClass)), testInjector);
      expect(scopeToTest.injector(const NamedQualifier(TestClass, 'two')),
          testScopedInjector);
      expect(scopeToTest.injector(const TypeQualifier(TestClass2)), null);
      expect(scopeToTest.factory(const TypeQualifier(TestClass)), testFactory);
    });
  });
}

class TestClass2 {}

class TestClass {}

class TestClass_Injector extends Injector<TestClass> {
  @override
  void inject(TestClass instance, InjectionProvider provider) {
    // TODO: implement inject
  }
}

class TestClass_withScope_id1_Injector extends Injector<TestClass> {
  @override
  void inject(TestClass instance, InjectionProvider provider) {
    // TODO: implement inject
  }
}

class TestClass_Factory extends Factory<TestClass> {
  @override
  TestClass create(InjectionProvider provider) {
    return null;
  }
}
