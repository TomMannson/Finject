import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

import 'injection_provider.dart';

class InjectHost extends StatelessWidget {
  final Widget child;
  final _InjectionProviderImpl _provider;

  @protected
  InjectHost({this.child}) : _provider = _InjectionProviderImpl();

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
    var qualifier = QualifierFactory.create(T, name);

    var foundInjection = findParrent(context);
    var parentInjector = foundInjection.provider;
    if (parentInjector != null) {
      value = parentInjector.get(name);
      return value;
    }

    Factory factory = rootDependencyResolver['factory'][qualifier] as Factory;
    if (factory != null) {
      value = factory.create(this) as T;
      rootDependencyResolver["injector"][qualifier].inject(value, this);
      return value;
    }
    return null;
  }

  inject(Object target, [String name]) {
    var qualifier = QualifierFactory.create(target.runtimeType, name);

    var foundInjection = findParrent(context);
    var parentInjector = foundInjection.provider;
    if (parentInjector != null) {
      parentInjector.inject(target, name);
      return;
    }

    var injector = rootDependencyResolver["injector"][qualifier] as Injector;
    if (injector != null) {
      injector.inject(target, this);
    }
  }
}
