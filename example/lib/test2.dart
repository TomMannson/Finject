import 'package:finject/finject.dart';

@Injectable()
class TestClass extends SuperTestClass{
  String value;

  @Inject()
  TestClass.value(this.value) : super(value);

}

class SuperTestClass {
  @Inject()
  String superValue;

  SuperTestClass(this.superValue);
}
