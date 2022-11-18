import 'package:flutter/material.dart';

import '../finject_flutter.dart';

class FInject {
  static void inject(BuildContext context, Object target) {
    final scopedContext =
        context.getElementForInheritedWidgetOfExactType<ScopeInjectHost>()
            as ScopeInjecHostElement;
    final injector = InjectionProviderImpl(scopedContext);
    injector.inject(target);
  }

  static T of<T>(BuildContext context, {String name, bool flat = false}) {
    final scopedContext =
        context.getElementForInheritedWidgetOfExactType<ScopeInjectHost>()
            as ScopeInjecHostElement;
    final injector = InjectionProviderImpl(scopedContext);
    return injector.get(name);
  }
}
