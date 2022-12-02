import 'dart:developer';

import 'package:flutter/material.dart';

import '../finject_flutter.dart';

class InjectHost extends StatelessWidget {
  final Widget child;
  final InjectionProviderImpl _provider;

  @protected
  InjectHost({required this.child}) : _provider = InjectionProviderImpl(null);

  @override
  Widget build(BuildContext context) {
    _provider.context =
        context.getElementForInheritedWidgetOfExactType<ScopeInjectHost>();
    _provider.inject(child);
    log('InjectHost build');
    return child;
  }
}

class InjectionProviderImpl extends AbstractInjectionProvider {
  ScopeInjecHostElement? scopedContext;

  InjectionProviderImpl(this.scopedContext);

  @override
  T get<T>([String? name]) {
    T value;
    var qualifier = QualifierFactory.create(T, name);

    if (scopedContext != null) {
      final scope = scopedContext?.injectorProvider.scope;
      if (scope != null) {
        final injector = scope.factory(qualifier);
        if (injector != null) {
          return injector.create(this) as T;
        }
      }
    }

    final factory = rootDependencyResolver['factory']![qualifier] as Factory?;
    if (factory != null) {
      value = factory.create(this) as T;
      rootDependencyResolver['injector']![qualifier].inject(value, this);
      return value;
    }

    throw "value not found";
    // return null;
  }

  @override
  void inject(Object target, [String? name]) {
    var qualifier = QualifierFactory.create(target.runtimeType, name);

    if (scopedContext != null) {
      final scope = scopedContext?.injectorProvider.scope;
      if (scope != null) {
        final injector = scope.injector(qualifier);
        if (injector != null) {
          injector.inject(target, this);
          return;
        }
      }
    }

    var injector = rootDependencyResolver['injector']![qualifier] as Injector?;
    if (injector != null) {
      injector.inject(target, this);
    }
  }

  @override
  FoundInjection findParent(BuildContext context) {
    final scopeElement = context as ScopeInjecHostElement;
    final scopeHost = scopeElement.widget as ScopeInjectHost;

    return FoundInjection(scopeHost.currentInjector, scopeElement);
  }
}

class InjectionContext {
  final scopes = <Scope>[];
}
