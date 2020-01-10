import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

import 'injection_provider.dart';

class JustInjectHost extends StatelessWidget {
  final Widget child;
  final JustInjectionProviderImpl _provider;

  @protected
  JustInjectHost({this.child}):
        _provider = JustInjectionProviderImpl();


  @override
  Widget build(BuildContext context) {
    _provider.inject(child);
    return child;
  }
}

class JustInjectionProviderImpl extends AbstractInjectionProvider {
  JustInjectionProviderImpl();

  @override
  T get<T>([String name]) {
    T value;
    Qualifier qualifier = QualifierFactory.create(T, name);

    Factory factory = rootDependencyResolver["factory"][qualifier];
    if (factory != null) {
      value = factory.create(this);
      rootDependencyResolver["injector"][qualifier].inject(value, this);
      return value;
    }
    return null;
  }

  inject(Object target, [String name]) {
    Qualifier qualifier = QualifierFactory.create(target.runtimeType, name);

    Injector injector = rootDependencyResolver["injector"][qualifier];
    if (injector != null) {
      injector.inject(target, this);
    }
  }
}
