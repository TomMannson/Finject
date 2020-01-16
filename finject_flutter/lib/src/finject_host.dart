import 'package:flutter/material.dart';

import '../finject_flutter.dart';

class FInjectHost extends StatelessWidget {
  final Widget host;

  FInjectHost.scoped({@required Widget child, String scopeName})
      : host = ScopeInjectHost(child: child, scopeName: scopeName);

  FInjectHost.inject({@required Widget child})
      : host = InjectHost(child: child);

  FInjectHost.flat({@required Widget child})
      : host = JustInjectHost(child: child);

  @override
  Widget build(BuildContext context) {
    return host;
  }
}

class FInject {
  static T get<T>({String name}) {
    return JustInjectionProviderImpl().get<T>(name);
  }

  static T getWithContext<T>(BuildContext context, {String name}) {
    final injectionProviderImpl = InjectionProviderImpl();
    injectionProviderImpl.context = context;
    return injectionProviderImpl.get<T>(name);
  }
}
