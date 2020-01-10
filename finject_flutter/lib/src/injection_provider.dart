//import 'package:get_it/get_it.dart';
import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

import 'scope_host.dart';

abstract class AbstractInjectionProvider extends InjectionProvider {
  BuildContext context;

  FoundInjection findParrent(BuildContext context) {
    Element element =
        context.getElementForInheritedWidgetOfExactType<ScopeInjectHost>();

    if (context is StatelessElement) {
      ScopeInjectHost widget = element.widget as ScopeInjectHost;
      return FoundInjection(widget.getIt(), element);
    }

    element.visitAncestorElements((el) {
      element = el;
      return false;
    });

    element =
        element.getElementForInheritedWidgetOfExactType<ScopeInjectHost>();
    if (element == null) {
      return FoundInjection(null, null);
    }

    ScopeInjectHost widget = element.widget as ScopeInjectHost;
    return FoundInjection(widget.getIt(), element);
  }
}

class FoundInjection {
  InjectionProvider provider;
  BuildContext foundIn;

  FoundInjection(this.provider, this.foundIn);
}
