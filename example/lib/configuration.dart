import 'package:example/test.dart';
import 'package:finject/finject.dart';

@Configuration()
class Config {
  @Named("one")
  @Scoped("test")
  @Singleton()
  TestClass one() {
    return TestClass("one");
  }

  @Named("two")
  @Scoped("test")
  TestClass two() {
    return TestClass("two");
  }

  String valueString() {
    return "three";
  }
}
