import 'package:flutter/material.dart';

import '../finject_flutter.dart';

class FInject {
  static void inject(BuildContext context, Object target) {
    final injector = InjectionProviderImpl();
    injector.inject(target);
  }

  static T of<T>(BuildContext context, {String name, bool flat = false}) {
    final injector = InjectionProviderImpl();
    if (!flat) {
      injector.context =
          context.getElementForInheritedWidgetOfExactType<ScopeInjectHost>();
    }
    return injector.get(name);
  }
}
