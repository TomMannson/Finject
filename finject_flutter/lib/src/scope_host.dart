import 'dart:developer';

import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

import 'injection_provider.dart';

class ScopeInjectHost extends InheritedWidget {
  final String scopeName;
  final InjectionProvider _getItContainer;

  @protected
  ScopeInjectHost({Widget child, this.scopeName})
      : _getItContainer = ScopeInjectionProviderImpl(
          defaultScopeFactory.createScope(scopeName),
        ),
        super(child: child);

  @override
  InheritedElement createElement() {
    return ScopeInjecHostElement(this);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  InjectionProvider get currentInjector {
    return _getItContainer;
  }
}

class ScopeInjecHostElement extends InheritedElement {
  ScopeInjectionProviderImpl injectorProvider;

  ScopeInjecHostElement(ScopeInjectHost widget) : super(widget) {
    injectorProvider = widget._getItContainer as ScopeInjectionProviderImpl;
  }

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
    return _ScopeInjectHostState();
  }
}

class _ScopeInjectHostState extends State<HostStatefulWidget> {
  ScopeInjectionProviderImpl provider;

  @override
  Widget build(BuildContext context) {
    if (provider != null) {
      var lastDisposables = provider.disposables;
      var lastScope = provider.scope;
      provider = widget.parent.currentInjector as ScopeInjectionProviderImpl;

      provider.disposables = lastDisposables;
      provider.scope = lastScope;
    } else {
      provider = widget.parent.currentInjector as ScopeInjectionProviderImpl;
    }

    provider.context =
        context.getElementForInheritedWidgetOfExactType<ScopeInjectHost>();
    provider.inject(widget.child);

    log('_ScopeInjectHostState build');
    return widget.child;
  }

  @override
  void dispose() {
    provider.clean();
    super.dispose();
  }
}

class ScopeInjectionProviderImpl extends AbstractInjectionProvider {
  Scope scope;
  Set<DisposableScopedObject> disposables = {};

  ScopeInjectionProviderImpl(this.scope);

  @override
  T get<T>([String name]) {
    T value;

    var qualifier = QualifierFactory.create(T, name);

    if (scope != null &&
        scope.factory(qualifier) != null &&
        scope.injector(qualifier) != null) {
      value = scope.factory(qualifier).create(this) as T;
      scope.injector(qualifier).inject(value, this);
      if (value is DisposableScopedObject) {
        disposables.add(value);
      }
      return value;
    }

    if (context != null) {
      var foundInjection = findParrent(context);
      var parentInjector = foundInjection.provider;
      if (parentInjector != null) {
        value = parentInjector.get(name);
        return value;
      }
    }

    var factory = rootDependencyResolver['factory'][qualifier] as Factory;
    if (factory != null) {
      value = factory.create(this) as T;
      rootDependencyResolver['injector'][qualifier].inject(value, this);

      return value;
    }
    return null;
  }

  @override
  void inject(Object target, [String name]) {
    var qualifier = QualifierFactory.create(target.runtimeType, name);

    if (scope != null && scope.injector(qualifier) != null) {
      scope.injector(qualifier).inject(target, this);
      return;
    }

    var foundInjection = findParrent(context);
    var parentInjector = foundInjection.provider;
    if (parentInjector != null) {
      parentInjector.inject(target, name);
      return;
    }

    var injector = rootDependencyResolver['injector'][qualifier] as Injector;
    if (injector != null) {
      injector.inject(target, this);
    }
  }

  @override
  FoundInjection findParrent(BuildContext context) {
    Element firstParentOfScopedHost;

    context.visitAncestorElements((el) {
      firstParentOfScopedHost = el;
      return false;
    });

    final foundScopeInjectHost = firstParentOfScopedHost
            .getElementForInheritedWidgetOfExactType<ScopeInjectHost>()
        as ScopeInjecHostElement;
    if (foundScopeInjectHost == null) {
      return FoundInjection(null, null);
    }

    var widget = foundScopeInjectHost.widget as ScopeInjectHost;
    return FoundInjection(widget.currentInjector, foundScopeInjectHost);
  }

  void clean() {
    disposables.forEach((value) => value.onDispose());
    disposables = {};
  }
}
