import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

import 'injection_provider.dart';

class InjectHost extends StatelessWidget {
  final Widget child;
  _InjectionProviderImpl _provider;

  @protected
  InjectHost({this.child}) {
    _provider = _InjectionProviderImpl();
  }

  @override
  Widget build(BuildContext context) {
    _provider.context = context;
    _provider.inject(child);
    return child;
  }
}

class _InjectionProviderImpl extends AbstractInjectionProvider {
  BuildContext context;

  _InjectionProviderImpl();

  @override
  T get<T>([String name]) {
    T value;
    Qualifier qualifier = QualifierFactory.create(T, name);

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
}
