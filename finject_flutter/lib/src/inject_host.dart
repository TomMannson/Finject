import 'package:finject/finject.dart';
import 'package:flutter/material.dart';

import 'injection_provider.dart';

typedef InjectionProvider ContainerBuilder();

class InjectHost extends InheritedWidget {
  static InjectorMatcher injectorMatcher;

  String scopeName;

  InjectionProvider _getItContainer;

  @protected
  InjectHost({Widget child, this.scopeName}) : super(child: child) {
    _getItContainer =
        InjectionProviderImpl(defaultScopeFactory.createScope(scopeName));
  }

  @override
  InheritedElement createElement() {
    return InjectHostElement(this);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  InjectionProvider getIt() {
    return _getItContainer;
  }
}

class InjectHostElement extends InheritedElement {
  InjectHostElement(InjectHost widget) : super(widget);

  @override
  Widget build() {
    return HostWidget(widget, super.build());
  }
}

class HostWidget extends StatefulWidget {
  InjectHost parent;
  Widget child;

  HostWidget(this.parent, this.child);

  @override
  State<StatefulWidget> createState() {
    return _InjectHostState();
    ;
  }
}

class _InjectHostState extends State<HostWidget> {
  InjectionProviderImpl provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = widget.parent.getIt();
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

abstract class InjectorMatcher {
  Injector getInjectorFor(Widget widget, BuildContext context);
}
