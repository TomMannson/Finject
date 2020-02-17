import 'package:flutter/material.dart';

import '../finject.dart';

abstract class DiState<T extends StatefulWidget> extends State<T> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FInject.inject(context, this);
  }
}
