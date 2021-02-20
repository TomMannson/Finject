import 'package:finject/finject.dart';
import 'package:test/test.dart';

void main() {
  group('qualifier with ', () {
    test('notnull name returns NameQualifier', () {
      expect(
        QualifierFactory.create(TestClass, 'one'),
        NamedQualifier(TestClass, 'one'),
      );
    });

    test('null name returns TypeQualifier', () {
      expect(
        QualifierFactory.create(TestClass2, null),
        TypeQualifier(TestClass2),
      );
    });
  });
}

class TestClass2 {}

class TestClass {}
