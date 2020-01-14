import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

import 'injection_provider.dart';

class ScopeInjectHost extends InheritedWidget {
  final String scopeName;
  final InjectionProvider _getItContainer;

  @protected
  ScopeInjectHost({Widget child, this.scopeName})
      : _getItContainer = _ScopeInjectionProviderImpl(
          defaultScopeFactory.createScope(scopeName),
        ),
        super(child: child);

  @override
  InheritedElement createElement() {
    return ScopeInjecHostElement(this);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  InjectionProvider getIt() {
    return _getItContainer;
  }
}

class ScopeInjecHostElement extends InheritedElement {
  ScopeInjecHostElement(ScopeInjectHost widget) : super(widget);

  @override
  Widget build() {
    return HostStatefulWidget(widget as ScopeInjectHost, super.build());
  }
}

class HostStatefulWidget extends StatefulWidget {
  final ScopeInjectHost parent;
  final Widget child;

  HostStatefulWidget(this.parent, this.child);

  @override
  State<StatefulWidget> createState() {
    return _InjectHostState();
  }
}

class _InjectHostState extends State<HostStatefulWidget> {
  _ScopeInjectionProviderImpl provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = widget.parent.getIt() as _ScopeInjectionProviderImpl;
    provider.context = context;
    provider.inject(widget.child);
    return widget.child;
  }

  @override
  void dispose() {
    provider.context = null;
    super.dispose();
  }
}

class _ScopeInjectionProviderImpl extends AbstractInjectionProvider {
  Scope scope;

  _ScopeInjectionProviderImpl(this.scope);

  @override
  T get<T>([String name]) {
    T value;

    Qualifier qualifier = QualifierFactory.create(T, name);

    if (scope != null &&
        scope.factories[qualifier] != null &&
        scope.injectors[qualifier] != null) {
      value = scope.factories[qualifier].create(this) as T;
      scope.injectors[qualifier].inject(value, this);
      return value;
    }

    FoundInjection foundInjection = findParrent(context);
    InjectionProvider parentInjector = foundInjection.provider;
    if (parentInjector != null) {
      value = parentInjector.get(name);
      return value;
    }

    Factory factory = rootDependencyResolver["factory"][qualifier] as Factory;
    if (factory != null) {
      value = factory.create(this) as T;
      rootDependencyResolver["injector"][qualifier].inject(value, this);
      return value;
    }
    return null;
  }

  inject(Object target, [String name]) {
    Qualifier qualifier = QualifierFactory.create(target.runtimeType, name);

    if (scope != null && scope.injectors[qualifier] != null) {
      scope.injectors[qualifier].inject(target, this);
      return;
    }

    FoundInjection foundInjection = findParrent(context);
    InjectionProvider parentInjector = foundInjection.provider;
    if (parentInjector != null) {
      parentInjector.inject(target, name);
      return;
    }

    Injector injector = rootDependencyResolver["injector"][qualifier] as Injector;
    if (injector != null) {
      injector.inject(target, this);
    }
  }
}
