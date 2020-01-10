import 'package:flutter/material.dart';

import '../finject_flutter.dart';

class FInjectHost extends StatelessWidget {
  final Widget host;

  FInjectHost.scoped({@required Widget child, String scopeName})
      : host = ScopeInjectHost(child: child, scopeName: scopeName);

  FInjectHost.inject({@required Widget child})
      : host = InjectHost(child: child);

  FInjectHost.flat({@required Widget child})
      : host = JustInjectHost(
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    return host;
  }
}
