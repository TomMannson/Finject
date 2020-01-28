import 'package:finject/finject.dart';



class TestClass  implements DisposableScopedObject {
  String value;

  TestClass(this.value);

  @override
  void onDispose() {
    // TODO: implement onDispose
  }


}

Function asd;