import 'package:finject/finject.dart';
import 'package:test/test.dart';

void main() {
  group('annotations ', () {
    test('works', () {
      Configuration();
      Binds();
      Injectable();
      Inject();
      Scoped('test');
      Singleton();
      Named('name');
      Profile(['dev']);
      expect(rootDependencyResolver != null, true);
    });
  });
}
