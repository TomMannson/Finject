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
  @Profile(["dev"])
  @Scoped("test")
  TestClass two() {
    return TestClass("two");
  }

  @Named("two")
  @Profile(["test"])
  @Scoped("test")
  TestClass twoTest() {
    return TestClass("two test");
  }

  String valueString() {
    return "three";
  }
}
