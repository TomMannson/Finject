import 'dart:developer';

import 'package:finject/finject.dart';

class TestClass implements DisposableScopedObject {
  String value;

  TestClass(this.value);

  @override
  void onDispose() {
    log("onDispose");
  }
}
