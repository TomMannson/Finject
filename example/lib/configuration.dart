import 'package:example/test.dart';
import 'package:example/test2.dart' as a;
import 'package:finject/finject.dart';


@Configuration()
class Config {

  @Named("one")
  @Scoped("test")
  @Singleton()
  TestClass one(){
    return TestClass("one");
  }

  @Named("two")
  @Scoped("test")
  TestClass two(){
    return TestClass("two");
  }

  a.TestClass three(){
    return a.TestClass("three");
  }
}