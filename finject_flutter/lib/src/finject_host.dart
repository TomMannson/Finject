import 'package:finject_flutter/src/builder_inject_host.dart';
import 'package:flutter/material.dart';

import '../finject_flutter.dart';

class FInjectHost extends StatelessWidget {
  final Widget host;

  FInjectHost.scoped({required Widget child, required String scopeName})
      : host = ScopeInjectHost(scopeName: scopeName, child: child);

  FInjectHost.inject({required Widget child}) : host = InjectHost(child: child);

  FInjectHost.flat({required Widget child})
      : host = JustInjectHost(child: child);

  FInjectHost.builder({required LayoutInjectWidgetBuilder builder})
      : host = BuilderInjectHost(builder);

  @override
  Widget build(BuildContext context) {
    return host;
  }
}
