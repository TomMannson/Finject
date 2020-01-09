//import 'package:get_it/get_it.dart';
import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

import 'inject_host.dart';

class InjectionProviderImpl extends InjectionProvider {
  BuildContext context;
  Scope scope;

  InjectionProviderImpl(this.scope);

  @override
  T get<T>([String name]) {
    T value;

    Qualifier qualifier = QualifierFactory.create(T, name);

    if (scope != null &&
        scope.factories[qualifier] != null &&
        scope.injectors[qualifier] != null) {
      value = scope.factories[qualifier].create(this);
      scope.injectors[qualifier].inject(value, this);
      return value;
    }

    FoundInjection foundInjection = findParrent(context as BuildContext);
    InjectionProvider parentInjector = foundInjection.provider;
    if (parentInjector != null) {
      value = parentInjector.get(name);
      return value;
    }

    Factory factory = rootDependencyResolver["factory"][qualifier];
    if (factory != null) {
      value = factory.create(this);
      rootDependencyResolver["injector"][qualifier].inject(value, this);
      return value;
    }
  }

  inject(Object target, [String name]) {
    Qualifier qualifier = QualifierFactory.create(target.runtimeType, name);

    if (scope != null && scope.injectors[qualifier] != null) {
      scope.injectors[qualifier].inject(target, this);
      return;
    }

    FoundInjection foundInjection = findParrent(context as BuildContext);
    InjectionProvider parentInjector = foundInjection.provider;
    if (parentInjector != null) {
      parentInjector.inject(target, name);
      return;
    }

    Injector injector = rootDependencyResolver["injector"][qualifier];
    if (injector != null) {
      injector.inject(target, this);
    }
  }

  FoundInjection findParrent(BuildContext context) {
    Element element = (context as BuildContext)
        .getElementForInheritedWidgetOfExactType<InjectHost>();

    element.visitAncestorElements((el) {
      element = el;
      return false;
    });

    element = element.getElementForInheritedWidgetOfExactType<InjectHost>();
    if (element == null) {
      return FoundInjection(null, null);
    }

    InjectHost widget = element.widget as InjectHost;
    return FoundInjection(widget.getIt(), element);
  }
}

class FoundInjection {
  InjectionProvider provider;
  BuildContext foundIn;

  FoundInjection(this.provider, this.foundIn);
}
