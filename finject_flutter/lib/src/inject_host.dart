import 'dart:developer';

import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

import '../finject_flutter.dart';
import 'injection_provider.dart';

class InjectHost extends StatelessWidget {
  final Widget child;
  final InjectionProviderImpl _provider;

  @protected
  InjectHost({this.child}) : _provider = InjectionProviderImpl();

  @override
  Widget build(BuildContext context) {
    _provider.context = context.getElementForInheritedWidgetOfExactType<ScopeInjectHost>();
    _provider.inject(child);
    log("InjectHost build");
    return child;
  }
}

class InjectionProviderImpl extends AbstractInjectionProvider {
  BuildContext context;

  InjectionProviderImpl();

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

  @override
  FoundInjection findParrent(BuildContext context) {
    ScopeInjecHostElement scopeElement = context as ScopeInjecHostElement;
    ScopeInjectHost scopeHost = scopeElement.widget as ScopeInjectHost;
    if (context == null) {
      return FoundInjection(null, null);
    }
    return FoundInjection(scopeHost.currentInjector, scopeElement);
  }
}
