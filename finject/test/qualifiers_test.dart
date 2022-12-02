import 'package:finject/finject.dart';
import 'package:test/test.dart';

void main() {
  group('when scope is creating', () {
    var qualifierTypedString = TypeQualifier(String);
    var qualifierTypedString2 = TypeQualifier(String);
    var qualifierTypedFuture = TypeQualifier(Future);
    var qualifierNamed = NamedQualifier(String, 'text');
    var qualifierNamedText2 = NamedQualifier(String, 'text');
    var qualifierNamedOtherText = NamedQualifier(String, 'otherText');

    test('map should return valid injector', () {
      expect(qualifierNamed, qualifierNamedText2);
      expect(qualifierNamed.hashCode, qualifierNamedText2.hashCode);
      expect(qualifierNamedText2 == qualifierNamedOtherText, false);
      expect(
        qualifierNamedText2.hashCode == qualifierNamedOtherText.hashCode,
        false,
      );
      expect(qualifierTypedString, qualifierTypedString2);
      expect(qualifierTypedString.hashCode, qualifierTypedString2.hashCode);
      expect(
        qualifierNamed.hashCode == qualifierTypedFuture.hashCode,
        false,
      );
      expect(
        qualifierTypedString == qualifierTypedFuture,
        false,
      );
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
    throw 'NULL value';
    // return null;
  }
}
