import 'package:finject/finject.dart';
import 'package:test/test.dart';

void main() {
  group('when scope is creating', () {
    var testInjector = TestClass_Injector();
    var testScopedInjector = TestClass_withScope_id1_Injector();

    var scopeToTest = Scope([
      ScopeEntry<Injector>(const TypeQualifier(TestClass), testInjector),
      ScopeEntry<Factory>(const TypeQualifier(TestClass), TestClass_Factory()),
      ScopeEntry<Injector>(
          const NamedQualifier(TestClass, 'two'), testScopedInjector),
    ]);

    test('scope contains 2 injectors and 1 factory', () {
      expect(scopeToTest.factories.length, 1);
      expect(scopeToTest.injectors.length, 2);
    });

    test('map should return valid injector', () {
      expect(
          scopeToTest.injectors[const TypeQualifier(TestClass)], testInjector);
      expect(scopeToTest.injectors[const NamedQualifier(TestClass, 'two')],
          testScopedInjector);
      expect(scopeToTest.injectors[const TypeQualifier(TestClass2)], null);
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
